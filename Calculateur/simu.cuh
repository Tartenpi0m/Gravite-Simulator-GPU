#ifndef SIMU
#define SIMU

#include   "planete.h" 

__device__ double mini(double a, double b);
__host__ __device__ double distance(planete * a, planete * b);
__host__ __device__ void regroupe(planete * a, planete* b);
__host__ __device__ short detect_collision(planete * a, planete * b);
double force_G(long int G, planete * a, planete * b, int coord);

#endif //SIMU