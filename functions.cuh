#ifndef FUNCTIONS_H_INCLUDED
#define FUNCTIONS_H_INCLUDED

#include "global.cuh"
#include "person.cuh"


__device__ void scale_map(int * Dstreetmap,map * Dscaled_map,pos position);
__device__ void output_map(map * Dscaled_map,int* DOutputmap,pos position);
__global__ void check(map * Dscaled_map,int* DOutput_map);
__global__ void decide(map * Dscaled_map);
__global__ void set(int * Dstreetmap,map * Dscaled_map);
__global__ void run(map * Dscaled_map);


#endif
