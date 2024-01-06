#include "global.cuh"


__device__ void preference::set_weight(int vis_val)
{
  
    int new_heading  = vis_val - 4 ;  

    this->heading = new_heading;
    return ;
}
__device__ int preference::choose()
{
    pos position((blockIdx.x * blockDim.x + threadIdx.x) , (blockIdx.y * blockDim.y + threadIdx.y) );
    // Define weighted probabilities for each direction
    int * weights = this->heading_weights[this->heading]; // Adjust these values for different weights

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
    if (randomNum < weights[0])
    {
        return UP; // Up
    }
    else if (randomNum < weights[0] + weights[1])
    {
        return DOWN; // Down
    }
    else if (randomNum < weights[0] + weights[1] + weights[2])
    {
        return LEFT; // Left
    }
    else
    {
        return RIGHT; // Right
    }
}
