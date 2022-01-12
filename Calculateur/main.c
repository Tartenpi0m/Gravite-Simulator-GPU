#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <time.h>

#include "planete.h"
#include "simu.h"
#include "to_json.h"



int main() {
    srand(time(NULL));
    //RECEPTION DES PARAMETRE (envoyé par python)
    char x[50];
    long int param[7];
    int i = 0;
    int f = open("data/py_to_c", O_RDONLY); //bloquant jusqu'à l'ouverture du fifo dans py
    while(1) {
        if(read(f, x, sizeof(char)*50)) {
            printf("result : %s\n", x);
            if(x[0] == 's') {
                break;
            } else {
                param[i] = atoi(x);
            }
            i++;
        }
    } 
    close(f);
    int N_planete = (int) param[0] + 1;
    //int nb_frame = param[1]
    int nb_frame = (int) param[1];
    long int G = param[2];
    int MR = param[3];
    int rayon_max = param[4];
    int rayon_min = param[5];
    int v_init = param[6];

    printf("%ld %d", G,MR);
    //Initialiser les planètes
    planete ** all_planete = init_all_planete(N_planete, MR, rayon_max, rayon_min, v_init);

    //ENVOIE DU SIGNAL "debut des calculs"
    char y[8] = {'s','t','a','r','t','e','d'};
    f = open("data/c_to_py", O_WRONLY);
    write(f, y, sizeof(char)*7);
    close(f);


    //Frame
    int frame = 0;
    FILE * data;
    data = fopen("data/data1.json", "w");
    begin_file(data);

    printf("Debut du calcul pour %d frames\n", nb_frame);
    while(frame < nb_frame) {

        printf("frame : %d\n", frame); fflush(stdout);

       // printf("Collision\n");
        //Verifie toutes les collisions
        for(int i = 0; i < N_planete; i++) {
            for(int j = 0; j < N_planete; j++) {
                if(i != j) {
                    if(all_planete[i]->id != -1) {
                        if(all_planete[j]->id != -1) {
                            if(detect_collision(all_planete[i], all_planete[j])) {
                                regroupe(all_planete[i], all_planete[j]);
                            }
                        }
                    } else {
                        break;
                    }
                }    
            }
        }

        //Calcule les accélérations
       // printf("Acceleration\n"); fflush(stdout);
        for(int i = 0; i < N_planete; i++) {
            all_planete[i]->a[0] = 0;
            all_planete[i]->a[1] = 0;
            for(int j = 0; j < N_planete; j++) {
                if(i!=j) {
                    if(all_planete[i]->id != -1) {
                        if(all_planete[j]->id != -1) {
                            all_planete[i]->a[0] += force_G(G, all_planete[i], all_planete[j],0);
                            all_planete[i]->a[1] += force_G(G, all_planete[i], all_planete[j],1);
                        }
                    } else {
                        break;
                    }
                }
            }
        }

        for(int i = 0; i < N_planete; i++) {

            if(all_planete[i]->id >=1) {

                //Ajoute les accélérations aux vitesses
                all_planete[i]->v[0] += 0.00000000001*all_planete[i]->a[0]; //0.000000000001
                all_planete[i]->v[1] += 0.00000000001*all_planete[i]->a[1];

                //Ajoute les vitesses aux positions
                all_planete[i]->x[0] += all_planete[i]->v[0];
                all_planete[i]->x[1] += all_planete[i]->v[1];
            }
        }

        
        write_frame(data,frame, all_planete, N_planete);
        if(frame < nb_frame-1) {
            virgule(data);
        }

        frame++;

        //AJOUTER un thread quiverifie toutes les seconde que le fichier json courant
        //n'a pas depasser une certaine taille. Si oui, il change une variable globale,
        //se termine et est relancé pour surveiller le fichier suivant
    }
        end_file(data);

        fclose(data);

    free_all_planete(all_planete, N_planete);


    sleep(1);    
    //ENVOIE DU SIGNAL "fin de calcul"
    char z[8] = {'e', 'n', 'd'}; 
    f = open("data/c_to_py", O_WRONLY);
    write(f, z, sizeof(char)*3);
    close(f);

    return 0;
}