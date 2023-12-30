#include "person.cuh"

person::person(int direction,pos position,int speed,preference p)
{
    direction = direction; 
    position = position;
    speed = speed; 
    out_of_bound = false;
    p = p;

    return ;
}

__device__ void 
person::walk(int * Dstreetmap)
{
    int choice = p.choose();
    pos old_position = position;
    switch(choice)
    {
        case UP:
            position.y += speed;
            break;
        case DOWN:
            position.y -= speed;
            break;
        case LEFT:
            position.x -= speed;
            break;
        case RIGHT:
            position.y += speed;
            break;
    }

    if(!is_walkable(Dstreetmap,position))position = old_position;
    else
    {
        // update global memory
    }
    
    return ;
}

__device__ bool
person::is_walkable(int * Dstreetmap,pos position)
{
    if (Dstreetmap[C(position.x,position.y,MAP_SIZE)] != 0)return true;
    else return false;
}

