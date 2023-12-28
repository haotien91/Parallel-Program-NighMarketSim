#include "street.cuh"

void 
street::Load_map(char *infile)
{
    FILE *file = fopen(infile, "rb");
    int inp_size = MAP_SIZE / SCALE_SIZE; 



    int * tmp = (int*)malloc(inp_size *inp_size);

    for (int i = 0; i < inp_size; i++)
    {
        fread(&tmp, sizeof(int), inp_size * inp_size, file);
    }

    // throw to gpu 

    cudaMalloc((void**)&Dstreetmap, inp_size *inp_size * sizeof(int));
    cudaMemcpy(Dstreetmap, tmp , inp_size *inp_size * sizeof(int) , cudaMemcpyHostToDevice);
}

void 
street::Output_map(char *outfile)
{
    return ;
   
}