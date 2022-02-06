all : compile exec

compile : maingpu.o planete.o simu.o to_json.o kernel.o
	nvcc -Xptxas -v -lineinfo -rdc=true  -arch sm_61 -o maingpu maingpu.o planete.o simu.o to_json.o kernel.o -lm -I/usr/local/cuda/include -I. -L/usr/local/cuda/lib64 -lcudart -lcurand -lcudadevrt

planete.o : planete.c 
	g++ -lm -c planete.c

to_json.o : to_json.c planete.h
	g++ -c to_json.c

simu.o : simu.cu  planete.h
	nvcc -Xptxas -v -lineinfo  -rdc=true -arch sm_61 -dc simu.cu -lm

kernel.o : kernel.cu simu.cuh to_json.h planete.h
	nvcc -Xptxas -v -lineinfo -rdc=true -arch sm_61 -dc kernel.cu

maingpu.o : maingpu.cu planete.h kernel.cuh book.h
	nvcc -Xptxas -v -lineinfo -rdc=true -arch sm_61 -c maingpu.cu



exec :
	./maingpu

clean : 	
	rm *.o -v
	rm maingpu -v
