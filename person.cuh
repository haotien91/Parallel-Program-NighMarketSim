#ifndef PERSON_H_INCLUDED
#define PERSON_H_INCLUDED

#include "global.cuh"
#include "street.cuh"

#define REMOVE 0
#define ON_BOARD 1

class person
{
public:
    __device__ person(int direction, pos position, int speed, preference p);

    int direction;
    pos position;
    int speed;
    preference p;
    pos next_position;

    __device__ int decide(map *Dscaled_map);
    __device__ void walk(map *Dscaled_map);
    __device__ void walk_back(map *Dscaled_map);

    __device__ bool is_walkable(map *Dscaled_map, pos position);

private:
};

#endif
