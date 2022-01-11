#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "planete.h"

#define x_init_max 1000 //1 000 000 Mm 


planete * init_planete(int id, int MR, int rayon_max, int rayon_min,int v_init) {

    
    planete * ma_planete = malloc(sizeof(planete));

    //Vitesse entre 5 500 et 55 000 m/s
    ma_planete->id = id;
    ma_planete->a[0] = 0;
    ma_planete->a[1] = 0;
    ma_planete->v[0] = rand() % v_init  - (v_init/2);
    ma_planete->v[1] = rand() % v_init - (v_init/2);
    ma_planete->x[0] = rand() % x_init_max;
    ma_planete->x[1] = rand() % x_init_max;
    ma_planete->rayon = (rand()  % (rayon_max-rayon_min)) + rayon_min;
    ma_planete->masse = 4.18*pow(ma_planete->rayon,MR)*5000; //4/3 * pi = 4.18   5000=masse_volumique kg/m3

    return ma_planete;
}


planete ** init_all_planete(int N_planete, int MR, int rayon_max, int rayon_min,int v_init) {
    
    planete ** tab = malloc(sizeof(planete*)*N_planete);
    for(int i = 0; i < N_planete; i++) {
        tab[i] = malloc(sizeof(planete*));
    }

    for(int i = 0; i < N_planete; i++) {
        tab[i] = init_planete(i, MR, rayon_max, rayon_min, v_init);
    }

    return tab;
}


void free_all_planete(planete ** tab, int N_planete) {

    for(int i = 0; i < N_planete; i++) {
        free(tab[i]);
    }

    free(tab);
}