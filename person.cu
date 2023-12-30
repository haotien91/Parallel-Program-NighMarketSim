#include "person.cuh"

person::person(int direction, pos position, int speed, preference p)
{
    direction = direction;
    position = position;
    speed = speed;
    out_of_bound = false;
    p = p;

    return;
}

__device__ void
person::decide(map *Dscaled_map)
{
    int choice = p.choose();
    switch (choice)
    {
    case UP:
        new_position.y = position.y - speed;
        break;
    case DOWN:
        new_position.y = position.y + speed;
        break;
    case LEFT:
        new_position.x = position.x - speed;
        break;
    case RIGHT:
        new_position.x = position.x + speed;
        break;
    }

    if (!is_walkable(Dscaled_map, position))
        new_position = position;
    else
        direction = choice;

    return;
}

__device__ void
person::walk(map *Dscaled_map)
{
    // update
    Dscaled_map[C(next_position.x, next_position.y, MAP_SIZE)].vis = direction;
    Dscaled_map[C(next_position.x, next_position.y, MAP_SIZE)].buffer[direction] = this;
}

__device__ void
person::walk_back(map *Dscaled_map)
{
    // update back , just go don't need to check
    Dscaled_map[C(position.x, position.y, MAP_SIZE)].vis = direction;
    Dscaled_map[C(position.x, position.y, MAP_SIZE)].buffer[direction] = this;
}

__device__ bool
person::is_walkable(map *Dstreetmap, pos position)
{
    if (Dstreetmap[C(position.x, position.y, MAP_SIZE)].vis == -1)
        return true;
    else
        return false;
}
