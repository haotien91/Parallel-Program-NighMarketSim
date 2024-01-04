#include "street.cuh"

int cmpfunc (const void * a, const void * b) {
   return ( *(int*)a - *(int*)b );
}

void street::Load_map(char *infilename)
{
    FILE *file = fopen(infilename, "rb");
    int inp_size = MAP_SIZE / SCALE_SIZE;

    this->streetmap = (int *)malloc(inp_size * inp_size *sizeof(int));
    this->Outputmap = (int *)malloc(MAP_SIZE * MAP_SIZE *sizeof(int));

    fread(this->streetmap, sizeof(int), inp_size * inp_size, file);

    for (int i = 0; i < inp_size; i++)
    {
        for (int j = 0; j < inp_size; j++)
        {
            printf("%d ", this->streetmap[C(j, i, inp_size)]);
        }
        printf("\n");
    }

    // throw to gpu

    cudaMalloc((void **)&this->Dstreetmap, inp_size * inp_size * sizeof(int));
    cudaMemcpy(this->Dstreetmap, this->streetmap, inp_size * inp_size * sizeof(int), cudaMemcpyHostToDevice);

    cudaMalloc((void **)&this->Dscaled_map, MAP_SIZE * MAP_SIZE * sizeof(map));
    cudaMalloc((void **)&this->DOutputmap, MAP_SIZE * MAP_SIZE * sizeof(int));

    printf("loaded input  map , inp size %d \n", inp_size);
}

void street::Set_bounds()
{
    int x_count = 0 ,y_count = 0,state  ;
    int inp_size = MAP_SIZE / SCALE_SIZE;

    this->x_bounds = (int*)malloc(inp_size * inp_size * sizeof(int));
    this->y_bounds = (int*)malloc(inp_size * inp_size * sizeof(int));
    memset(this->x_bounds,-1, inp_size * inp_size * sizeof(int));
    memset(this->y_bounds,-1, inp_size * inp_size * sizeof(int));
    
    for(int i = 0 ; i < inp_size ; i++ )
    {
        state = this->streetmap[C(0,i,inp_size)];
        x_count = 0;
        for(int j = 0 ; j < inp_size ;j++)
        {
            if(this->streetmap[C(j,i,inp_size)] != state)
            {
                if(state == 0)
                {
                   if(this->x_bounds[C(x_count,i,inp_size)] != j-1)this->x_bounds[C(x_count++,i,inp_size)]  = j-1;
                   state  = 1;
                }
                else
                {
                    this->x_bounds[C(x_count++,i,inp_size)] = j;
                    state  = 0;
                }
            }
        }
        qsort(this->x_bounds,x_count,sizeof(int),cmpfunc);
    }

    for(int i = 0 ; i < inp_size ; i++ )
    {
        state = this->streetmap[C(i,0,inp_size)];
        y_count = 0;
        for(int j = 0 ; j < inp_size ;j++)
        {
            if(this->streetmap[C(i,j,inp_size)] != state)
            {
                if(state == 0)
                {
                   if(this->y_bounds[C(y_count,i,inp_size)] != j-1)this->y_bounds[C(y_count++,i,inp_size)] = j-1;
                   state  = 1;
                }
                else
                {
                    this->y_bounds[C(y_count++,i,inp_size)] = j;
                    state  = 0;
                }
            }
        }
        qsort(this->y_bounds,y_count,sizeof(int),cmpfunc);
    }

    printf("y_bounds:\n");
    for(int i= 0 ; i< inp_size ;i++)
    {
        for(int j =0 ; j< inp_size ;j++)
        {
            printf("%d ", this->y_bounds[C(j,i,inp_size)]);
        }
        printf("\n");
    }

    printf("x_bounds:\n"); 
    for(int i= 0 ; i< inp_size ;i++)
    {
        for(int j =0 ; j< inp_size ;j++)
        {
            printf("%d ", this->x_bounds[C(j,i,inp_size)]);
        }
        printf("\n");
    }

    //SCALING 
    for(int i = 0 ; i < inp_size * inp_size ; i++ )
    {
        this -> x_bounds[i] = this -> x_bounds[i] * SCALE_SIZE + (SCALE_SIZE-1);
        this -> y_bounds[i] = this -> y_bounds[i] * SCALE_SIZE + (SCALE_SIZE-1);
    }
    
    cudaMalloc((void **)&this->Dx_bounds, inp_size * inp_size * sizeof(int));
    cudaMemcpy(this->Dx_bounds, this->x_bounds, inp_size * inp_size * sizeof(int), cudaMemcpyHostToDevice);
    cudaMalloc((void **)&this->Dy_bounds, inp_size * inp_size * sizeof(int));
    cudaMemcpy(this->Dy_bounds, this->y_bounds, inp_size * inp_size * sizeof(int), cudaMemcpyHostToDevice);

    


}
void street::Output_map(char *outfilename)
{

    cudaMemcpy(this->Outputmap, this->DOutputmap, MAP_SIZE * MAP_SIZE * sizeof(int), cudaMemcpyDeviceToHost);

    // char newline = '\n';

    // if a phase is ended. output current map.
    FILE *outfile = fopen(outfilename, "ab");

    fwrite(this->Outputmap, sizeof(int), MAP_SIZE * MAP_SIZE, outfile);
    // fwrite(&newline, sizeof(char), 1, outfile);

    fclose(outfile);

    return;
}

void street::Output_size(char *outfilename)
{
    FILE *outfile = fopen(outfilename, "w");

    // char blank = ' ';
    // char newline = '\n';

    fwrite(&this->size, sizeof(int), 1, outfile);
    // fwrite(&blank, sizeof(char), 1, outfile);
    // fwrite(&this->height, sizeof(int), 1, outfile);
    // fwrite(&newline, sizeof(char), 1, outfile);
}
