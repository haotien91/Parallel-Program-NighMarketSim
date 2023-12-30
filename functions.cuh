#ifndef FUNCTIONS_H_INCLUDED
#define FUNCTIONS_H_INCLUDED

#include "global.cuh"


__device__ map *  Scaled_map;
__device__ void scale_map(int * Dstreetmap);
__device__ void check_conflict();
__device__ void output_map();
__global__ void set(int * Dstreetmap);
__global__ void run(int * Dstreetmap);

#endif
