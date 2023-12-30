#ifndef PERSON_H_INCLUDED
#define PERSON_H_INCLUDED

#include "global.cuh"
#include "street.cuh"

class person
{
public:
    person(int direction, pos position, int speed,preference p);

    int direction;
    int position;
    int speed;
    bool out_of_bound;
    preference p;

    __device__ void walk(int * Dstreetmap);

    __device__ bool is_walkable(int * Dstreetmap);

private:
};

#endif 