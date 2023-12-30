#ifndef GLOBAL_H_INCLUDED
#define GLOBAL_H_INCLUDED


#include <iostream>
#include <stdio.h>
#include <cstdlib>
#include <cassert>
#include <cuda.h>
#include <random>
#include <cuda_runtime.h>
#include <vector_types.h>
#include <omp.h>


#define UP 0
#define DOWN 1
#define LEFT 2
#define RIGHT 3
#define MAP_SIZE 64 // 4n
#define SCALE_SIZE 2
#define PHASES 10
#define C(x, y, k) ((y) * (k) + (x))



struct pos
{
    int x;
    int y;
};

struct preference
{
    int up ; 
    int down;
    int left;
    int right;
    __device__ int choose();
};

class person;

class map
{
    public:
        map();
        bool vis ; 
        person * buffer[4];
};



#endif