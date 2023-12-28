#ifndef STREET_H_INCLUDED
#define STREET_H_INCLUDED

#include "global.cuh"

class street
{
public:
    street()
    {
        printf("Street Initialized\n");
        
        streetmap = new int [MAP_SIZE/SCALE_SIZE * MAP_SIZE/SCALE_SIZE];// create a map
    }
    void Load_map(char *infile);
    void Output_map(char *outfile);

    int *streetmap;
    int *Dstreetmap;
    int *Outputmap;

private:
};

#endif 
