#ifndef FUNCTIONS_H_INCLUDED
#define FUNCTIONS_H_INCLUDED

#include "global.cuh"
#include "street.cuh"

__device__ int *  Scaled_map;
__device__ void scale_map(int * Dstreetmap);
__global__ void set(int * Dstreetmap);
__global__ void run();

#endif
