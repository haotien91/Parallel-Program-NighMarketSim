#ifndef GLOBAL_H_INCLUDED
#define GLOBAL_H_INCLUDED


#include <iostream>
#include <stdio.h>
#include <cstdlib>
#include <cassert>
#include <ctime>
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
#define C(i,j,k) (((j)*(k))+(i))
#define NUMOFPEOPLE 20



struct pos
{
    pos(int x,int y)
    {
        x = x ;
        y = y ;
    }
    int x;
    int y;
};

struct preference
{
    preference(int up,int down,int left,int right)
    {
        up = up ;
        down = down ; 
        left = left ; 
        right = right;
    }
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
        int vis ; 
        person * buffer[4];
};



#endif