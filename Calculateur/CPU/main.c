#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <time.h>

#include "planete.h"
#include "to_json.h"
#include "kernel.h"



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
    int N_planete = (int) param[0];
    //int N_trou_noir = 2;// (int) param[1];
    //int nb_frame = param[1]
    int nb_frame = (int) param[1];
    long int G = param[2];
    int MR = param[3];
    int rayon_max = param[4];
    int rayon_min = param[5];
    int v_init = param[6];
    int N_trou_noir = param[7];

    int N_corps = N_planete + N_trou_noir;

    printf("%ld %d", G,MR);
    //Initialiser les planètes
    planete * all_planete = init_all_planete(N_planete, N_trou_noir, MR, rayon_max, rayon_min, v_init);

    //ENVOIE DU SIGNAL "debut des calculs"
    char y[8] = {'s','t','a','r','t','e','d'};
    f = open("data/c_to_py", O_WRONLY);
    write(f, y, sizeof(char)*7);
    close(f);


    //Frame
    FILE * data;
    data = fopen("data/data1.json", "w");
    begin_file(data);

    printf("Debut du calcul pour %d frames\n", nb_frame);
    
    gestion(nb_frame, all_planete, N_corps, data, G);

    end_file(data);
    fclose(data);

    free_all_planete(all_planete, N_corps);


    sleep(1);    
    //ENVOIE DU SIGNAL "fin de calcul"
    char z[8] = {'e', 'n', 'd'}; 
    f = open("data/c_to_py", O_WRONLY);
    write(f, z, sizeof(char)*3);
    close(f);

    return 0;
}