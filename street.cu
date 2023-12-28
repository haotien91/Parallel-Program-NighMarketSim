#include "global.cuh"
#include "street.cuh"

void street::Load_map(char *infile)
{
    FILE *file = fopen(infile, "rb");

    int tmp[MAP_SIZE / SCALE_SIZE][MAP_SIZE / SCALE_SIZE];

    for (int i = 0; i < MAP_SIZE / SCALE_SIZE; i++)
    {
        fread(&tmp[i], sizeof(int), MAP_SIZE / SCALE_SIZE, file);
    }

    for (int i = 0; i < MAP_SIZE / SCALE_SIZE; i++)
    {
        for (int j = 0; j < MAP_SIZE / SCALE_SIZE; j++)
        {
        }
    }
}