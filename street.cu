#include "street.cuh"

void street::Load_map(char *infilename)
{
    FILE *file = fopen(infilename, "rb");
    int inp_size = MAP_SIZE / SCALE_SIZE;

    streetmap = (int *)malloc(inp_size * inp_size);
    Outputmap = (int *)malloc(MAP_SIZE * MAP_SIZE);

    for (int i = 0; i < inp_size; i++)
    {
        fread(&streetmap, sizeof(int), inp_size * inp_size, file);
    }

    // throw to gpu

    cudaMalloc((void **)&Dstreetmap, inp_size * inp_size * sizeof(int));
    cudaMemcpy(Dstreetmap, streetmap, inp_size * inp_size * sizeof(int), cudaMemcpyHostToDevice);

    cudaMalloc((void **)&Dscaled_map, MAP_SIZE * MAP_SIZE * sizeof(map));
    cudaMalloc((void **)&DOutputmap, MAP_SIZE * MAP_SIZE * sizeof(Outputmap));
}

void street::Output_map(char *outfilename)
{

    cudaMemcpy(Outputmap, DOutputmap, sizeof(Outputmap), cudaMemcpyDeviceToHost);

    // if a phase is ended. output current map.
    FILE *outfile = fopen(outfilename, "ab");

    fwrite(&Outputmap, sizeof(int), MAP_SIZE * MAP_SIZE, outfile);

    fclose(outfile);

    return;
}