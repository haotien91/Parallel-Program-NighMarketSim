#include "global.cuh"

__device__ void preference::set_weights(int * Dx_bounds, int * Dy_bounds,pos position)
{
    // // find left, right bound 
    int left,right,up,down;
    for(int i = 0 ; i < MAP_SIZE/SCALE_SIZE ; i++)
    {
        if (position.x <= Dx_bounds[position.y][i] && Dx_bounds[position.y][i] != -1)
        {
            right = Dx_bounds[position.y][i];
            if(i ==0)left = -100000000;
            else left = Dx_bounds[position.y][i-1];


            break;
        }
        if(Dx_bounds[position.y][i] == -1 )
        {
            right = 100000000;
            if(i ==0)left = -100000000;
            else left = Dx_bounds[position.y][i-1];
            //set to map bound
            break;
        }
    }
    

    // // find left, right bound 
    for(int i = 0 ; i < MAP_SIZE/SCALE_SIZE ; i++)
    {
        if (position.y <= Dy_bounds[position.x][i] && Dx_bounds[position.x][i] != -1)
        {
            down = Dx_bounds[position.x][i];
            if(i ==0)up = -100000000;
            else up = Dx_bounds[position.y][i-1];

            break;
        }
        if(Dy_bounds[position.x][i] == -1 )
        {
            down = 100000000;
            if(i ==0)up = -100000000;
            else up = Dx_bounds[position.y][i-1];
            //set to map bound
            break;
        }
    }
    int vecs = {position.y - up,down - position.y,position.x - left,right - position.x};
   
    vecs[BACK] = 0 ;

    // get max vecs 
    int  max_val = 0 ,max_ind;
    for(int i = 0 ; i< 4; i++)
    {
        if(max_val <= vecs[i])
        {
            max_val =vecs[i];
            max_ind = i;
        }
    }
    
    float turn_prob = 0 ;
    // if diff , get turn prob 
    if(max_ind != this->heading)
    {

        turn_prob = 10 + ( 10 > float(vecs[heading]) ? (10 - float(vecs[heading])) : 0  );
    }
    curandState state;
    curand_init(clock64(), C(position.x,position.y,MAP_SIZE) , 0, &state);
    float myrandf = curand_uniform(&state);

    myrandf *= (100);
    if(my_randf < turn_prob)
    {
        //turn 
        return max_ind;
    }
    else return heading;
}
__device__ int preference::choose(int * Dx_bounds, int * Dy_bounds)
{
    pos position((blockIdx.x * blockDim.x + threadIdx.x) , (blockIdx.y * blockDim.y + threadIdx.y) );
    // Define weighted probabilities for each direction

    int new_heading = set_weights(Dx_bounds,Dy_bounds,position);

    
    
    weights = this->heading_weights[new_heading];

    

    // Calculate total weight
    int totalWeight = 0;
    for (int i = 0 ; i< 4; i++)
    {
        totalWeight += weights[i];
    }

    // Generate a random number between 1 and total weight
    //  std::random_device rd;
    //   std::mt19937 gen(rd());
    //   std::uniform_int_distribution<> dis(1, totalWeight);

    // assume have already set up curand and generated state for each thread...
    // assume ranges vary by thread index
    curandState state;
    curand_init(clock64(), C(position.x,position.y,MAP_SIZE) , 0, &state);
    float myrandf = curand_uniform(&state);
    myrandf *= (100);
    myrandf += UP;

    int randomNum = (int)truncf(myrandf);
    ; // NEED TO CHANGE

    // Choose a direction based on weighted probabilities
    if (randomNum <= weights[0])
    {
        return UP; // Up
    }
    else if (randomNum <= weights[0] + weights[1])
    {
        return DOWN; // Down
    }
    else if (randomNum <= weights[0] + weights[1] + weights[2])
    {
        return LEFT; // Left
    }
    else
    {
        return RIGHT; // Right
    }
}
