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
    for(int i = 0 ; i < PHASES ; i++)
    {
        run<<<1,1>>>();
        output(output_filename);
    }

    return;
}
