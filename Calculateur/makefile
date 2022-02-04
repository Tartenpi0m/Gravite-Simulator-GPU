all : compile exec

compile : main.o planete.o simu.o to_json.o kernel.o
	nvcc -lineinfo -rdc=true --generate-line-info -o main main.o planete.o simu.o to_json.o kernel.o -lm -I/usr/local/cuda/include -I. -L/usr/local/cuda/lib64 -lcudart -lcurand -lcudadevrt

planete.o : planete.c 
	g++ -lm -c planete.c

to_json.o : to_json.c planete.h
	g++ -c to_json.c

simu.o : simu.cu  planete.h
	nvcc -dc -lineinfo  -rdc=true simu.cu -lm

kernel.o : kernel.cu simu.cuh to_json.h planete.h
	nvcc -lineinfo -rdc=true --generate-line-info -dc kernel.cu

main.o : main.c planete.h simu.h kernel.cuh book.h
	g++ -c main.c



exec :
	./main

clean : 	
	rm *.o -v
	rm main -v
