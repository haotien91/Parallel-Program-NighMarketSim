#include "global.cuh"

__device__ int preference::set_weights(int * Dx_bounds, int * Dy_bounds,pos position)
{
    // // find left, right bound 
    int inp_size = MAP_SIZE/SCALE_SIZE;
    int left,right,up,down;
    int scale_y = position.y / SCALE_SIZE;
    for(int i = 0 ; i < inp_size ; i++)
    {
        
        if (position.x <= Dx_bounds[C(i,scale_y,inp_size)] && Dx_bounds[C(i,scale_y,inp_size)] != -1)
        {
            right = Dx_bounds[C(i,scale_y,inp_size)];
            if(i ==0 )left = -100000000;
            else left = Dx_bounds[C(i-1,scale_y,inp_size)];


            break;
        }
        if(Dx_bounds[C(i,scale_y,inp_size)]  == -1 )
        {
            right = 100000000;
            if(i ==0)left = -100000000;
            else left = Dx_bounds[C(i-1,scale_y,inp_size)];
            //set to map bound
            break;
        }
    }
    

    int scale_x = position.x /  SCALE_SIZE;
    for(int i = 0 ; i < inp_size ; i++)
    {
        if (position.y <= Dy_bounds[C(i,scale_x,inp_size)] && Dy_bounds[C(i,scale_x,inp_size)] != -1)
        {
            down = Dy_bounds[C(i,scale_x,inp_size)];
            if(i ==0)up = -100000000;
            else up = Dy_bounds[C(i-1,scale_x,inp_size)];

            break;
        }
        if(Dy_bounds[C(i,scale_x,inp_size)] == -1 )
        {
            down = 100000000;
            if(i ==0)up = -100000000;
            else up = Dy_bounds[C(i-1,scale_x,inp_size)];
            //set to map bound
            break;
        }
    }

    int vecs[] = {position.y - up,down - position.y,position.x - left,right - position.x};
    int opp[] = {DOWN,UP,RIGHT,LEFT};
    vecs[BACK] = 0 ;
    vecs[opp[heading]]= 0;
    

    // get max vecs 
    int  max_val = 0 ,max_ind;
    for(int i = 0 ; i< 4; i++)
    {
        if(max_val <= vecs[i])
        {
            max_val = vecs[i];
            max_ind = i;
        }
    }
    
    float turn_prob = 0 ;
    // if diff , get turn prob 
    if(max_ind != this->heading)
    {
     //   printf("%d %d %d %d\n",position.x, position.y ,vecs[max_ind],vecs[heading]);
     //   turn_prob = ( 10 + ( 10 > vecs[heading]) ? (10 - vecs[heading])*10 : 0  );
      turn_prob = ( 25 + ( MAP_SIZE/3 > vecs[heading]) ? (MAP_SIZE/3 - vecs[heading])*10 : 0  );
    }
    curandState state;
    curand_init(clock64(), C(position.x,position.y,MAP_SIZE) , 0, &state);
    float myrandf = curand_uniform(&state);

    myrandf *= (100);
 //   printf("%d %d %d %d %d %d\n",position.x , position.y , up , down ,left, right);
    if(myrandf < turn_prob)
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
    this->heading = new_heading;
    int *  weights = this->heading_weights[new_heading];

    

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
