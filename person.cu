#include "person.cuh"

person::person(int direction,pos position,int speed)
{
    direction = direction; 
    position = position;
    speed = speed; 
    out_of_bound = false;

    return ;
}

void 
person::walk(street s)
{
    return ;
}

bool
person::is_walkable(street s)
{
    return true;
}