all : compile exec

compile : main.o planete.o simu.o to_json.o
	gcc -Wall -o main main.o planete.o simu.o to_json.o -lm 

planete.o : planete.c 
	gcc -Wall -lm -c planete.c

to_json.o : to_json.c planete.h
	gcc -Wall -c to_json.c

simu.o : simu.c  planete.h
	gcc -Wall -lm -c simu.c 

main.o : main.c planete.h simu.h
	gcc -c main.c



exec :
	./main

clean : 	
	rm *.o -v
	rm main -v
