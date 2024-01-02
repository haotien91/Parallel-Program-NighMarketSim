#include "person.cuh"

__device__ person::person(int direction, pos position, int speed, preference p)
{
    this->direction = direction;
    this->position = position;
    this->next_position = position ; 
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


    if (!is_walkable(Dscaled_map, this->next_position))
    {
        this->next_position.x = this->position.x;
        this->next_position.y = this->position.y;
    }
    else
    {
        // below line should not happen : 
        //if(choice == UP)printf("%d %d %d %d %d %d\n", this->next_position.x,this->position.x, this->next_position.y,this->position.y,C(this->next_position.x,this->next_position.y,MAP_SIZE),Dscaled_map[C(this->next_position.x,this->next_position.y,MAP_SIZE)].vis);
        this->direction = choice;
    }
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
person::is_walkable(map *Dscaled_map, pos position_check)
{
    if(C(position_check.x, position_check.y, MAP_SIZE) < 0 || C(position_check.x, position_check.y, MAP_SIZE) >= MAP_SIZE * MAP_SIZE )return false;
    if (Dscaled_map[C(position_check.x, position_check.y, MAP_SIZE)].vis == -1)
        return true;
    else
        return false;
}
