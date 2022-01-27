#ifndef SIMU
#define SIMU

#include   "planete.h" 

double min(double a, double b);
double distance(planete * a, planete * b);
void regroupe(planete * a, planete* b);
short detect_collision(planete * a, planete * b);
double force_G(long int G, planete * a, planete * b, int coord);

#endif //SIMU