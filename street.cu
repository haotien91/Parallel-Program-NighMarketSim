#include "street.cuh"

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
