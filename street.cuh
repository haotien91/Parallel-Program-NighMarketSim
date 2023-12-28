#include "global.cuh"
#include "main.cuh"

#define MAP_SIZE 64

class street
{
public:
    street()
    {
        printf("Street Initialized\n");
        streetmap = new int *[MAP_SIZE];

        for (int i = 0; i < MAP_SIZE; i++)
        {
            streetmap[i] = new int[MAP_SIZE]; // create an 64x64 map
        }
    }
    void Load_map(int *infile);

    int **streetmap;

private:
};
