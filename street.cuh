#ifndef STREET_H_INCLUDED
#define STREET_H_INCLUDED

#include "global.cuh"
#include "person.cuh"

class street
{
public:
    street()
    {
    }
    ~street()
    {
        cudaFree(this->Dstreetmap);
        cudaFree(this->Dscaled_map);
        cudaFree(this->DOutputmap);
        free(this->streetmap);
        free(this->Outputmap);
    }
    void Load_map(char *infilename);
    void Set_bounds();
    void Output_map(char *outfilename);
    void Output_size(char *outfilename);

    // int width;
    // int height;
    int size = MAP_SIZE;

    int *streetmap;
    int *Dstreetmap;
    map *Dscaled_map;
    int *Dx_bounds, *Dy_bounds;
    int *x_bounds , * y_bounds;
    int *Outputmap, *DOutputmap;

private:
};

#endif
