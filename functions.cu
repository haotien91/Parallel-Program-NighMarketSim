#include"functions.cuh"


__device__ void scale_map(int * Dstreetmap,map * Dscaled_map,pos position)
{
    int scale_x = position.x;
    int scale_y = position.y ; 
    int inp_x = scale_x/SCALE_SIZE;
    int inp_y = scale_y/SCALE_SIZE;

    if (Dstreetmap[C(inp_x, inp_y, MAP_SIZE / SCALE_SIZE)] == 0) // obstacles
    {
        Dscaled_map[C(scale_x, scale_y, MAP_SIZE)].original = Dscaled_map[C(scale_x,scale_y,MAP_SIZE)].vis = OBSTACLES;
    }
    else
    {
        Dscaled_map[C(scale_x, scale_y, MAP_SIZE)].original = Dscaled_map[C(scale_x, scale_y, MAP_SIZE)].vis = Dstreetmap[C(inp_x, inp_y, MAP_SIZE / SCALE_SIZE)];    // put in grad
    }

    return;
}

__device__ void output_map(map * Dscaled_map,int* DOutput_map,pos position)
{
    if (Dscaled_map[C(position.x, position.y, MAP_SIZE)].vis >= UP_GRAD) // empty
        DOutput_map[C(position.x, position.y, MAP_SIZE)] = 0;
    else if (Dscaled_map[C(position.x, position.y, MAP_SIZE)].vis >= UP) // people
        DOutput_map[C(position.x, position.y, MAP_SIZE)] = 1;
    else if (Dscaled_map[C(position.x, position.y, MAP_SIZE)].vis == OBSTACLES) // obstacle
        DOutput_map[C(position.x, position.y, MAP_SIZE)] = 2;

    return ;
}
__global__ void set(int * Dstreetmap,map * Dscaled_map)
{
    // scale map
    pos position((blockIdx.x * blockDim.x + threadIdx.x), (blockIdx.y * blockDim.y + threadIdx.y));

    scale_map(Dstreetmap, Dscaled_map, position);

    person *p;

    // set people
    if (position.x >= LINEOFPEOPLE  && position.y < NUMOFPEOPLE && Dscaled_map[C(position.x, position.y, MAP_SIZE)].vis != OBSTACLES)
    {
         // should set people 

        int direction = LEFT;
        preference prefer(direction);
        // prefer.set_preference(4,4,90,2);

        p = new person(direction,position,1,prefer);
        Dscaled_map[C(position.x,position.y,MAP_SIZE)].vis = direction;
        Dscaled_map[C(position.x,position.y,MAP_SIZE)].buffer[direction] = p ;  
    }

    return;
}

__global__ void decide(map *Dscaled_map)
{
    pos position((blockIdx.x * blockDim.x + threadIdx.x), (blockIdx.y * blockDim.y + threadIdx.y));

    if(Dscaled_map[C(position.x,position.y,MAP_SIZE)].vis > -1 && Dscaled_map[C(position.x,position.y,MAP_SIZE)].vis < UP_GRAD)
    {
        // have person
        int status = Dscaled_map[C(position.x, position.y, MAP_SIZE)].buffer[Dscaled_map[C(position.x, position.y, MAP_SIZE)].vis]->decide(Dscaled_map);

        if (status == REMOVE)
        {
            Dscaled_map[C(position.x, position.y, MAP_SIZE)].buffer[Dscaled_map[C(position.x, position.y, MAP_SIZE)].vis]->oob = true;
            printf("Delete this person.\n");
            
        }

        //  Dscaled_map[C(position.x,position.y,MAP_SIZE)].vis =  Dscaled_map[C(position.x,position.y,MAP_SIZE)].buffer[Dscaled_map[C(position.x,position.y,MAP_SIZE)].vis]->direction;
    }

    return;
}


__global__ void run(map * Dscaled_map)
{
  
    pos position((blockIdx.x * blockDim.x + threadIdx.x) , (blockIdx.y * blockDim.y + threadIdx.y) );
    
    // walk 
    if(Dscaled_map[C(position.x,position.y,MAP_SIZE)].vis > -1 && Dscaled_map[C(position.x,position.y,MAP_SIZE)].vis < UP_GRAD && !Dscaled_map[C(position.x, position.y, MAP_SIZE)].buffer[Dscaled_map[C(position.x, position.y, MAP_SIZE)].vis]->oob )
    {
        // have person 
        Dscaled_map[C(position.x,position.y,MAP_SIZE)].buffer[Dscaled_map[C(position.x,position.y,MAP_SIZE)].vis]->walk(Dscaled_map);
    }
    return ;
}


__global__ void check(map * Dscaled_map,int * DOutput_map)
{

    pos position((blockIdx.x * blockDim.x + threadIdx.x) , (blockIdx.y * blockDim.y + threadIdx.y) );
    map location = Dscaled_map[C(position.x,position.y,MAP_SIZE)];

    // walk 
    if(location.vis > -1 && location.vis < UP_GRAD)
    {
        if(location.buffer[location.vis]->oob)
        {
            delete location.buffer[location.vis];
            location.vis = location.original;
        }
        else
        {
            int tmp[4] ;
            int counter =0 ;
            int all_null = 1;
            for(int i = 0 ; i < 4 ; i++)
            {

                if(location.buffer[i] != NULL)
                {
                    all_null = 0; 
                    // is a moved person
                    if (location.buffer[i]->next_position.x == position.x && location.buffer[i]->next_position.y == position.y)
                        tmp[counter++] = i;

                    // person original place is gone
                    else
                    {
                        location.buffer[i] = NULL;
                        location.vis = location.original;
                    }
                }
            }
            if(all_null)
            {
                location.vis = location.original;
            }
            if (counter > 0)
            {
                curandState state;
                curand_init(clock64(), C(position.x,position.y,MAP_SIZE) , 0, &state);
                float myrandf = curand_uniform(&state);
                myrandf *= (counter);
                myrandf += UP;
                int random_pos = (int)truncf(myrandf);
                ; // NEED TO CHANGE
                int random_val = tmp[random_pos];

                // synchronize next position and position
                for (int i = 0; i < 4; i++)
                {
                    if (location.buffer[i] != NULL)
                    {
                        if (i != random_val)
                        {
                            // go back to previous_position
                            location.buffer[i]->walk_back(Dscaled_map);
                            location.buffer[i]->next_position = location.buffer[i]->position;

                            // set to null
                            location.buffer[i] = NULL;
                        }
                        else
                        {
                            location.buffer[i]->position = location.buffer[i]->next_position;
                            location.buffer[i]->p.set_weight(location.original);
                            location.vis = i;
                            
                        }
                    }
                }
            }
        }
        
        
        
        Dscaled_map[C(position.x, position.y, MAP_SIZE)] = location;
    }

    //Delete people if people is out
    // code here 

    // create people at a rate , if this is a startpoint , (之後再說)


    output_map( Dscaled_map,DOutput_map,position);
}

__global__ void test_write(int *Dstreetmap, map *Dscaled_map, int *DOutput_map)
{
    pos position((blockIdx.x * blockDim.x + threadIdx.x), (blockIdx.y * blockDim.y + threadIdx.y));
    // output_map(Dscaled_map, DOutput_map, position);

    if (position.x == 0 && position.y == 0)
    {
        printf("My blkIdx = (%d,%d), thrIdx=(%d,%d) with pos.x=%d (actual=%d), pos.y=%d (actual=%d)\n", blockIdx.x, blockIdx.y, threadIdx.x, threadIdx.y, position.x, blockIdx.x * blockDim.x + threadIdx.x, position.y, blockIdx.y * blockDim.y + threadIdx.y);
        printf("This is Dscaled_map\n");
        for (int i = 0; i < 64; i++)
        {
            for (int j = 0; j < 64; j++)
            {
                printf("%d ", Dscaled_map[C(j, i, MAP_SIZE)].vis);
            }
            // printf("64\n");
            printf("\n");
        }
        printf("greets from Dscaled_map\n");
    }
}

__global__ void test_out(int *DOutput_map)
{
    pos position((blockIdx.x * blockDim.x + threadIdx.x), (blockIdx.y * blockDim.y + threadIdx.y));

    // printf("My blkIdx = (%d,%d), thrIdx=(%d,%d) with pos.x=%d (actual=%d), pos.y=%d (actual=%d)\n", blockIdx.x, blockIdx.y, threadIdx.x, threadIdx.y, position.x, blockIdx.x * blockDim.x + threadIdx.x, position.y, blockIdx.y * blockDim.y + threadIdx.y);

    // check
    if (position.x == 0 && position.y == 0)
    {
        printf("My blkIdx = (%d,%d), thrIdx=(%d,%d) with pos.x=%d (actual=%d), pos.y=%d (actual=%d)\n", blockIdx.x, blockIdx.y, threadIdx.x, threadIdx.y, position.x, blockIdx.x * blockDim.x + threadIdx.x, position.y, blockIdx.y * blockDim.y + threadIdx.y);
        printf("This is DOutput_map\n");
        for (int i = 0; i < 64; i++)
        {
            for (int j = 0; j < 64; j++)
            {
                printf("%d ", DOutput_map[C(i, j, MAP_SIZE)]);
            }
            // printf("64\n");
            printf("\n");
        }
        printf("greets from Doutput_map\n");
    }
}
