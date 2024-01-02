#ifndef STREET_H_INCLUDED
#define STREET_H_INCLUDED

#include "global.cuh"
#include "person.cuh"

class street
{
public:
    street()
    {
        this->width = this->height = MAP_SIZE / SCALE_SIZE;
    }
    ~street()
    {
        cudaFree(Dstreetmap);
        cudaFree(Dscaled_map);
        cudaFree(DOutputmap);
        free(streetmap);
        free(Outputmap);
    }
    void Load_map(char *infilename);
    void Output_map(char *outfilename);

    int width;
    int height;

    int *streetmap;
    int *Dstreetmap;
    map *Dscaled_map;
    int *Outputmap, *DOutputmap;

private:
};

#endif