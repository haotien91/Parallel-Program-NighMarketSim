#include "main.cuh"

int main(int argc, char **argv)
{
    char *input_filename = argv[1];
    char *output_filename = argv[2];

    // Initialize objects
    street *Playground = new street;

    // Handle Input
    Playground->Load_map(input_filename);
    Playground->Set_bounds();
    Playground->Output_size(output_filename);

    // FOR loop RUN simulator
    dim3 blk(32, 32);
    dim3 grid(MAP_SIZE / 32, MAP_SIZE / 32);

    set<<<grid, blk>>>(Playground->Dstreetmap, Playground->Dscaled_map);

    // test write in

    for (int i = 0; i < PHASES; i++)
    {
      //  printf("In phase %d\n", i);
        decide<<<grid, blk>>>(Playground->Dscaled_map,Playground->Dx_bounds,Playground->Dy_bounds);
      //  test_write<<<grid, blk>>>(Playground->Dstreetmap, Playground->Dscaled_map, Playground->DOutputmap);// print Dscalemap

        run<<<grid, blk>>>(Playground->Dscaled_map);
      //  test_write<<<grid, blk>>>(Playground->Dstreetmap, Playground->Dscaled_map, Playground->DOutputmap);// print Dscalemap

        check<<<grid, blk>>>(Playground->Dscaled_map, Playground->DOutputmap);
       // test_write<<<grid, blk>>>(Playground->Dstreetmap, Playground->Dscaled_map, Playground->DOutputmap); // print Dscalemap

        // For : when run finish a phase , trigger event

        Playground->Output_map(output_filename);
        /*
                for(int i = 0 ; i < MAP_SIZE ; i++)
                {
                    for(int j = 0 ; j < MAP_SIZE ; j++)
                    {
                        printf("%d ", (Playground->Outputmap)[C(j,i,MAP_SIZE)]);
                    }
                    printf("\n");
                }
        */
    }
    //  free(Playground->Outputmap);

    // free memory
    printf("finished start deleting object \n");

    // std::cout << sizeof(Playground->streetmap) << std::endl;
    // std::cout << sizeof(Playground->Outputmap) << std::endl;

    // printf("Outputfile is %d\n", Playground->Outputmap[6 * 64 + 16]);

    // free(Playground->streetmap);
    // printf("streetmap\n");
    // free(Playground->Outputmap);
    // printf("Output\n");

    delete Playground;
    printf("delete success\n");

    return;
}
