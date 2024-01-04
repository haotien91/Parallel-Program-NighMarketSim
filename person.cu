#include "person.cuh"

__device__ person::person(int direction, pos position, int speed, preference p)
{
  
    this->direction = direction;
    this->position = position;
    this->next_position = position;
    this->speed = speed;
    this->p = p;
    this->oob = false;

    return;
}

__device__ int
person::decide(map *Dscaled_map,int * Dx_bounds,int * Dy_bounds)
{
    int choice = this->p.choose(Dx_bounds,Dy_bounds);
    switch (choice)
    {
    case UP:
        //  this->next_position.x = this->position.x;
        this->next_position.y = this->position.y - this->speed;
        break;
    case DOWN:
        //   this->next_position.x = this->position.x;
        this->next_position.y = this->position.y + this->speed;
        break;
    case LEFT:
        this->next_position.x = this->position.x - this->speed;
        //     this->next_position.y = this->position.y;
        break;
    case RIGHT:
        this->next_position.x = this->position.x + this->speed;
        //     this->next_position.y = this->position.y;
        break;
    }

    // whether person is out of bound?
    int walkable = is_walkable(Dscaled_map, this->next_position);
    if(walkable == REMOVE)
    {
        return REMOVE;
    }
    if (walkable == UNWALKABLE)
    {
        this->next_position.x = this->position.x;
        this->next_position.y = this->position.y;
    }
    if(walkable == WALKABLE)
    {
        // below line should not happen :
        // if(choice == UP)printf("%d %d %d %d %d %d\n", this->next_position.x,this->position.x, this->next_position.y,this->position.y,C(this->next_position.x,this->next_position.y,MAP_SIZE),Dscaled_map[C(this->next_position.x,this->next_position.y,MAP_SIZE)].vis);
        this->direction = choice;
    }
    return ON_BOARD;
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

__device__ int
person::is_walkable(map *Dscaled_map, pos position_check)
{
    if (this->next_position.x < 0 || this->next_position.x >= MAP_SIZE || this->next_position.y < 0 || this->next_position.y >= MAP_SIZE)
    {
        return REMOVE;
    }
    if (Dscaled_map[C(position_check.x, position_check.y, MAP_SIZE)].vis == -1)
        return WALKABLE;
    else
        return UNWALKABLE;
}
