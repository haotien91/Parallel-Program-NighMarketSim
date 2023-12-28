#include "street.cuh"

void street::Load_map(char *infilename)
{
    FILE *file = fopen(infilename, "rb");
    int inp_size = MAP_SIZE / SCALE_SIZE;

    int *tmp = (int *)malloc(inp_size * inp_size);

    for (int i = 0; i < inp_size; i++)
    {
        fread(&tmp, sizeof(int), inp_size * inp_size, file);
    }

    // throw to gpu

    cudaMalloc((void **)&Dstreetmap, inp_size * inp_size * sizeof(int));
    cudaMemcpy(Dstreetmap, tmp, inp_size * inp_size * sizeof(int), cudaMemcpyHostToDevice);
}

void street::Output_map(char *outfilename)
{
    // if a phase is ended. output current map.

    FILE *outfile = fopen(outfilename, "ab");
    int inp_size = MAP_SIZE / SCALE_SIZE;

    for (int i = 0; i < inp_size; i++)
    {
    }

    fclose(outfile);

    return;
}