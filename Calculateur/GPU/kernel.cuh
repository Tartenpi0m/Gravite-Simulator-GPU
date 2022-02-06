#ifndef KERNEL
#define KERNEL

#include "planete.h"
#include <stdio.h>

#endif //KERNEL


__global__ void kernel_calculCollision(int indice, planete une_planete, planete * all_planete, int N_corps);
void calculCollision(planete * all_planete, int N_corps);
__global__ void kernel_calculAcceleration(int indice, planete * all_planete, int N_corps, long int G);
void calculAcceleration(planete * all_planete, int N_corps, long int G);
__global__ void kernel_updatePosition(planete * all_planete, int N_corps);
void gestion(int nb_frame, planete * all_planete, int N_corps, FILE * data, long int G);