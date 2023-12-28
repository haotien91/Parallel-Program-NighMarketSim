NVFLAGS  := -std=c++11 -O3 -Xptxas="-v" -arch=sm_61  -Xcompiler -fopenmp  
LDFLAGS  := -lm

CXX = g++
CXXFLAGS = -O3 
CXXFLAGS +=-fopenmp

OUT:= Run
MAIN:= functions.o  IO.o main.o person.o street.o

%.o:%.cu %.cuh
	nvcc $(NVFLAGS) $(LDFLAGS) -c $< -o $@

all: $(MAIN)
	nvcc $(NVFLAGS) $(LDFLAGS) $(MAIN) -o $(OUT) 

clean:
	rm -f $(OUT) $(MAIN)
	