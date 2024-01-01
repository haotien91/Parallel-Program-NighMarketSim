#include "main.cuh"

int main(int argc, char **argv)
{
    char *input_filename = argv[1];
    char *output_filename = argv[2];

    // Initialize objects
    street *Playground = new street;

    // Handle Input
    Playground->Load_map(input_filename);

    // FOR loop RUN simulator
    dim3 blk(32, 32);
    dim3 grid(MAP_SIZE / 32, MAP_SIZE / 32);

    set<<<grid, blk>>>(Playground->Dstreetmap, Playground->Dscaled_map);

    // for (int i = 0; i < 64; i++)
    // {
    //     for (int j = 0; j < 64; j++)
    //     {
    //         printf("X");
    //     }
    //     printf("\n");
    // }
    // printf("\n");

    // test write in
    test_write<<<grid, blk>>>(Playground->Dstreetmap, Playground->Dscaled_map, Playground->DOutputmap);

    cudaError_t err = cudaGetLastError();
    if (err != cudaSuccess)
    {
        printf("error test_write\n");
    }

    test_out<<<grid, blk>>>(Playground->DOutputmap);

    err = cudaGetLastError();
    if (err != cudaSuccess)
    {
        printf("error test_out\n");
    }

        for (int i = 0; i < PHASES; i++)
    {
        decide<<<grid, blk>>>(Playground->Dscaled_map);

        run<<<grid, blk>>>(Playground->Dscaled_map);

        check<<<grid, blk>>>(Playground->Dscaled_map, Playground->DOutputmap);

        // For : when run finish a phase , trigger event

        printf("In phase %d\n", i);
        Playground->Output_map(output_filename);
    }

    // free memory
    printf("finished start deleting object \n");

    // std::cout << sizeof(Playground->streetmap) << std::endl;
    // std::cout << sizeof(Playground->Outputmap) << std::endl;

    // printf("Outputfile is %d\n", Playground->Outputmap[6 * 64 + 16]);

    // free(Playground->streetmap);
    // printf("streetmap\n");
    // free(Playground->Outputmap);
    // printf("Output\n");

    // delete Playground;
    printf("delete success\n");

    return;
}
