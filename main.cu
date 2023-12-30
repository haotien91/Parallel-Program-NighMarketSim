#include "main.cuh"

int main(int argc, char **argv)
{
    char *input_filename = argv[1];
    char *output_filename = argv[2];

    // Initialize objects
    street Playground;

    // Handle Input
    Playground.Load_map(input_filename);

    // FOR loop RUN simulator
    dim3 blk(32,32);
    dim3 grid(MAP_SIZE/32,MAP_SIZE/32)
    
    set<<<grid,blk>>>(Playground.Dstreetmap,Playground.Dscaled_map);

    for(int i = 0 ; i < PHASES ; i++)
    {
        decide<<<gird,blk>>>(Playground.Dscaled_map);
        run<<<grid,blk>>>(Playground.Dscaled_map);
        check<<<grid,blk>>>(Playground.Dscaled_map,Playground.DOutput_map);

        // For : when run finish a phase , trigger event
        Playground.Output_map(output_filename);
    }
   
    // free memory
    delete Playground;

    return;
}
