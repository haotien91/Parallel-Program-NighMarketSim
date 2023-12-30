#include "global.cuh"

__device__ int preference::choose()
{
    // Define weighted probabilities for each direction
    int weights[] = {up, down, left, right}; // Adjust these values for different weights

    // Calculate total weight
    int totalWeight = 0;
    for (int weight : weights)
    {
        totalWeight += weight;
    }

    // Generate a random number between 1 and total weight
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(1, totalWeight);
    int randomNum = dis(gen);

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