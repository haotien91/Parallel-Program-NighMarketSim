#include"main.cuh"
int main(int argc, char** argv)
{
    char * input_filename = argv[1];
    char * output_filename = argv[2];
    
    FILE * FH = fopen(input_filename,"r");
   
    // fread
    
    fclose(FH);

    // Handle Input 

    // Initialize objects

    // FOR loop RUN simulator

    // append output to output file


    FH = fopen(output_filename,"w");
    // fwrite
    fclose(FH);


    return ;

}



