#include "global.cuh"
#include "street.cuh"

void street::Read_map(int *infile)
{
    FILE *file = fopen(infile, "rb");

    int tmp[16][16];

    for (int i = 0; i < 16; i++)
    {
        fread(&tmp[i], sizeof(int), 16, file);
    }

    for (int i = 0; i < MAP_SIZE; i++)
    {
        for (int j = 0; j < MAP_SIZE; j++)
        {
        }
    }
}