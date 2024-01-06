#ifndef GLOBAL_H_INCLUDED
#define GLOBAL_H_INCLUDED

#include <iostream>
#include <stdio.h>
#include <cstdlib>
#include <cassert>
#include <ctime>
#include <cuda.h>
#include <curand.h>
#include <curand_kernel.h>
#include <cuda_runtime.h>
#include <vector_types.h>
#include <omp.h>

#define OBSTACLES -2
#define EMPTY -1
#define UP 0
#define DOWN 1
#define LEFT 2
#define RIGHT 3

#define UP_GRAD 4
#define DOWN_GRAD 5
#define LEFT_GRAD 6
#define RIGHT_GRAD 7

#define MAP_SIZE 64 // 4n
#define SCALE_SIZE 2
#define PHASES 100
#define C(i, j, k) (((j) * (k)) + (i))
#define NUMOFPEOPLE 50
#define LINEOFPEOPLE (MAP_SIZE - 6)

class pos
{
public:
    __device__ pos() { return; };
    __device__ pos(int x, int y)
    {
        this->x = x;
        this->y = y;
    };
    int x;
    int y;
};

class preference
{
public:
    __device__ preference() { return; };
    __device__ preference(int heading)
    {
        this->heading = heading;
    };

    __device__ int choose();
    __device__ void set_weight(int heading);
    int heading ;
    int heading_weights[4][4]= 
    {
        {80,4,8,8},
        {4,80,8,8},
        {8,8,80,4},
        {8,8,4,80}
    };
};

class person;

class map
{
public:
    __device__ map()
    {
        memset(buffer, 0, sizeof(buffer));
        vis = 0;
    }
    int vis;
    int original;
    person *buffer[4];
};

#endif
