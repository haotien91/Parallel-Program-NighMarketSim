#include "main.cuh"

int main(int argc, char **argv)
{
    char *input_filename = argv[1];
    char *output_filename = argv[2];

    // Initialize objects
    street Playground();

    // Handle Input

    // FOR loop RUN simulator

    // append output to output file

    FILE *FH = fopen(output_filename, "w");
    // fwrite
    fclose(FH);

    return;
}
