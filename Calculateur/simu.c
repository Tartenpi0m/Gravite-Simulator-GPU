#include "planete.h"
#include "simu.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double min(double a, double b) {
    if(a < b) {
        return a;
    } else {
        return b;
    }
}

double distance(planete * a, planete * b) {
    return sqrt(pow(fabs(a->x[0] - b->x[0]),2) + pow(fabs(a->x[1] - b->x[1]),2));
}

//Regroupe 2 planetes en une (moyenne des position, moyenne des vitesses, addition des volumes (aires))
void regroupe(planete * a, planete* b) {

    a->v[0] = (a->v[0] +b->v[0]) / 2;
    a->v[1] = (a->v[1] + b->v[1]) / 2; 

    double ratio = a->masse/b->masse;
    double coefa = 2*(ratio/(ratio+1));
    a->x[0] = (coefa*a->x[0] + (2-coefa)*b->x[0])/2;
    a->x[1] = (coefa*a->x[1] + (2-coefa)*b->x[1])/2;
    a->rayon = sqrt(pow(a->rayon,2)+pow(b->rayon,2));

    b->id = -1;
    b->rayon = 0;
    b->v[0] = 0;
    b->v[1] = 0;
    b->x[0] = 0;
    b->x[1] = 0;
    b->masse = 0;
}

short detect_collision(planete * a, planete * b) {

    //Si collison
    if( distance(a,b) < a->rayon + b->rayon) {
        return 1; //return True
    } else {
        return 0;
    }
}

double force_G(long int G, planete * a, planete * b, int coord) {
    double d_h = (a->x[0] - b->x[0]);
    double d_v = (a->x[1] - b->x[1]);
    double d = distance(a, b);
    double force = G*pow(10,-2)*(b->masse/(d*d));
    double teta = acos(fabs(d_h/d));

    double x;
    if(coord == 0) {
        x = cos(teta)*force;
        if(d_h < 0) {
            return x;
        } else {
            return -x;
        }
    } else {
        x = sin(teta)*force; 
        if(d_v > 0) {
            return -x;
        }  else {
            return x;
        }
    }
    
    

    

    
}