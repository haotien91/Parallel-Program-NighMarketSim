#include"functions.cuh"


__device__ void scale_map(int * Dstreetmap,map * Dscaled_map,pos position)
{
    int scale_x = position.x;
    int scale_y = position.y ; 
    int inp_x = scale_x/SCALE_SIZE;
    int inp_y = scale_y/SCALE_SIZE;

    if(Dstreetmap[ C(inp_x,inp_y,MAP_SIZE/SCALE_SIZE)]  == 1)
    {
        Dscaled_map[C(scale_x,scale_y,MAP_SIZE)].vis = -1;
    }
    else
    {
        Dscaled_map[C(scale_x,scale_y,MAP_SIZE)].vis = -2;

    }

    return;
}

__device__ void output_map(map * Dscaled_map,int* DOutput_map,pos position)
{
   if(Dscaled_map[C(position.x,position.y,MAP_SIZE)].vis > -1)DOutput_map[C(position.x,position.y,MAP_SIZE)] = 1;

    return ;
}
__global__ void set(int * Dstreetmap,map * Dscaled_map)
{
    // scale map 
    pos position((blockIdx.x * blockDim.x + threadIdx.x) , (blockIdx.y * blockDim.y + threadIdx.y) );
    scale_map(Dstreetmap,Dscaled_map,position);
    person * p ;
    // set people
    if(position.x == 0 && position.y < NUMOFPEOPLE)
    {
         // should set people 

        int direction = LEFT;
        preference prefer(4,4,90,2);
        p = new person(direction,position,1,prefer);
        Dscaled_map[C(position.x,position.y,MAP_SIZE)].vis = direction;
        Dscaled_map[C(position.x,position.y,MAP_SIZE)].buffer[direction] = p ;  
    }


    return ;
}

void
__global__ decide(map * Dscaled_map)
{
    pos position((blockIdx.x * blockDim.x + threadIdx.x) , (blockIdx.y * blockDim.y + threadIdx.y) );

    if(Dscaled_map[C(position.x,position.y,MAP_SIZE)].vis > -1)
    {
            // have person 
            Dscaled_map[C(position.x,position.y,MAP_SIZE)].buffer[Dscaled_map[C(position.x,position.y,MAP_SIZE)].vis]->decide(Dscaled_map);
    }
    return ;

}

void
__global__  run(map * Dscaled_map)
{
  
    pos position((blockIdx.x * blockDim.x + threadIdx.x) , (blockIdx.y * blockDim.y + threadIdx.y) );
    
    // walk 
    if(Dscaled_map[C(position.x,position.y,MAP_SIZE)].vis > -1 )
    {
        // have person 
        Dscaled_map[C(position.x,position.y,MAP_SIZE)].buffer[Dscaled_map[C(position.x,position.y,MAP_SIZE)].vis]->walk(Dscaled_map);
    }
    return ;
}

void
__global__ check(map * Dscaled_map,int * DOutput_map)
{
    std::srand(std::time(0)); 

    pos position((blockIdx.x * blockDim.x + threadIdx.x) , (blockIdx.y * blockDim.y + threadIdx.y) );
    map location = Dscaled_map[C(position.x,position.y,MAP_SIZE)];

    // walk 
    if(location.vis > -1)
    {
        std::vector<int> tmp ;
        for(int i = 0 ; i < 4 ; i++)
        {
            if(location.buffer[i] != NULL)
            {
                tmp.push_back(i);
            }
        }
        int random_pos = std::rand() % tmp.size(); 
        int random_val = tmp[random_pos];

        for(int i = 0 ; i < 4 ; i++)
        {
            if(location.buffer[i] != NULL)
            {
                if(i  != random_val)
                {
                    // go back to previous_position
                location.buffer[i]->walk_back(Dscaled_map);
                location.buffer[i]->next_position = location.buffer[i]->position;

                //set to null 
                location.buffer[i] = NULL;

                }
                else
                {
                    location.buffer[i]->position = location.buffer[i]->next_position;
                }
            }
        }
        location.vis = random_val;
        Dscaled_map[C(position.x,position.y,MAP_SIZE)] = location;
    }
    output_map( Dscaled_map,DOutput_map,position);
}
