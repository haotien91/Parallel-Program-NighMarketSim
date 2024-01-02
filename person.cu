#include "person.cuh"

__device__ person::person(int direction, pos position, int speed, preference p)
{
    this->direction = direction;
    this->position = position;
    this->speed = speed;
    this->p = p;

    return;
}

__device__ void
person::decide(map *Dscaled_map)
{
    int choice = this->p.choose();
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
        this->direction = choice;

    return;
}

__device__ void
person::walk(map *Dscaled_map)
{
    // update
    Dscaled_map[C(this->next_position.x, this->next_position.y, MAP_SIZE)].vis = this->direction;
    Dscaled_map[C(this->next_position.x, this->next_position.y, MAP_SIZE)].buffer[this->direction] = this;
}

__device__ void
person::walk_back(map *Dscaled_map)
{
    // update back , just go don't need to check
    Dscaled_map[C(this->position.x, this->position.y, MAP_SIZE)].vis = this->direction;
    Dscaled_map[C(this->position.x, this->position.y, MAP_SIZE)].buffer[this->direction] = this;
}

__device__ bool
person::is_walkable(map *Dstreetmap, pos position_check)
{
    if (Dstreetmap[C(position_check.x, position_check.y, MAP_SIZE)].vis == -1)
        return true;
    else
        return false;
}
