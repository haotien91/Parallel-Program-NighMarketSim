#include "person.cuh"

person::person(int direction,pos position,int speed)
{
    direction = direction; 
    position = position;
    speed = speed; 
    out_of_bound = false;

    return ;
}

__device__ void 
person::walk(int * Dstreetmap)
{
    return ;
}

__device__ bool
person::is_walkable(int * Dstreetmap)
{
    return true;
}