#include <stdio.h>
#include "planete.h"
#include "simu.h"
#include "to_json.h"
#include <sys/time.h>

void calculCollision(planete * all_planete, int N_corps) {

    for(int i = 0; i < N_corps; i++) {
        for(int j = 0; j < N_corps; j++) {
            if(i != j) {
                if(all_planete[i].id != -1) {
                    if(all_planete[j].id != -1) {
                        if(detect_collision(&all_planete[i], &all_planete[j])) {
                            regroupe(&all_planete[i], &all_planete[j]);
                        }
                    }
                } else {
                    break;
                }
            }    
        }
    }
}


void calculAcceleration(planete * all_planete, int N_corps, long int G) {

    for(int i = 0; i < N_corps; i++) {
            all_planete[i].a[0] = 0;
            all_planete[i].a[1] = 0;
            for(int j = 0; j < N_corps; j++) {
                if(i!=j) {
                    if(all_planete[i].id != -1) {
                        if(all_planete[j].id != -1) {
                            all_planete[i].a[0] += force_G(G, &all_planete[i], &all_planete[j],0);
                            all_planete[i].a[1] += force_G(G, &all_planete[i], &all_planete[j],1);
                        }
                    } else {
                        break;
                    }
                }
            }
        }
}

void updatePosition(planete * all_planete, int N_corps) {

    for(int i = 0; i < N_corps; i++) {

            if(all_planete[i].id >=1) {

                //Ajoute les accélérations aux vitesses
                all_planete[i].v[0] += 0.00000000001*all_planete[i].a[0]; //0.000000000001
                all_planete[i].v[1] += 0.00000000001*all_planete[i].a[1];

                //Ajoute les vitesses aux positions
                all_planete[i].x[0] += all_planete[i].v[0];
                all_planete[i].x[1] += all_planete[i].v[1];
            }
        }
}


void gestion(int nb_frame, planete * all_planete, int N_corps, FILE * data, long int G) {

    int frame = 0;
    //cudamalloc

    struct timeval start;
    struct timeval end;
    float temps = 0;

    while(frame < nb_frame) {

        gettimeofday(&start, NULL); //temps

        ////CALCUL////
        calculCollision(all_planete, N_corps);
        calculAcceleration(all_planete, N_corps, G);
        updatePosition(all_planete, N_corps);

        gettimeofday(&end, NULL); //temps
        temps += (end.tv_sec - start.tv_sec) + 1e-6*(end.tv_usec - start.tv_usec);
        

        ////JSON////
        write_frame(data,frame, all_planete, N_corps);
        if(frame < nb_frame-1) {
            virgule(data);
        }

        frame++;
    }

     printf("\nTIME : %f s\n\n\n", temps);

}