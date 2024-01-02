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

#define BLOCKED -2
#define EMPTY -1
#define UP 0
#define DOWN 1
#define LEFT 2
#define RIGHT 3
#define MAP_SIZE 64 // 4n
#define SCALE_SIZE 2
#define PHASES 4
#define C(i, j, k) (((j) * (k)) + (i))
#define NUMOFPEOPLE 20

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
    __device__ preference(int up, int down, int left, int right)
    {
        this->up = up;
        this->down =down ;
        this->left =left;
        this->right =right;
    };

    int up;
    int down;
    int left;
    int right;
    __device__ int choose();
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
    person *buffer[4];
};

#endif
