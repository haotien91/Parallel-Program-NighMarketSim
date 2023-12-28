#ifndef PERSON_H_INCLUDED
#define PERSON_H_INCLUDED

#include "global.cuh"
#include "street.cuh"

class person
{
public:
    person(int direction, pos position, int speed);

    int direction;
    int position;
    int speed;
    bool out_of_bound;

    void walk(street s);

    bool is_walkable(street s);

private:
};

#endif 