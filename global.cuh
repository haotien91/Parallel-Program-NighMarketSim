#include <iostream>
#include <stdio.h>
#include <cstdlib>
#include <cassert>
#include <cuda.h>
#include <cuda_runtime.h>
#include <vector_types.h>
#include <omp.h>

#define UP 0
#define DOWN 1
#define LEFT 2
#define RIGHT 3
#define POSITION(x, y, k) ((y) * (k) + (x))

typedef struct _pos
{
    int x;
    int y;
} pos;
