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
    set<<<1,1>>>(Playground.Dstreetmap);
    run<<<1,1>>>(Playground.Dstreetmap);
    // For : when run finish a phase , trigger event
    Playground.Output_map(output_filename);
   

    // shutdown run 
    
    // free memory

    return;
}
