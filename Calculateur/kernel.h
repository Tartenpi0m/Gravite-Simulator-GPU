#ifndef KERNEL
#define KERNEL

#include "planete.h"
#include <stdio.h>

#endif //KERNEL

void calculCollision(planete ** all_planete, int N_corps);
void calculAcceleration(planete ** all_planete, int N_corps, long int G);
void updatePosition(planete ** all_planete, int N_corps);
void gestion(int nb_frame, planete ** all_planete, int N_corps, FILE * data, long int G);