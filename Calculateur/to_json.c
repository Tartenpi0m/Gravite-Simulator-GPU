#include <stdio.h>
#include "planete.h"
#include "to_json.h"

void begin_file(FILE * f) {
    fprintf(f, "{\n\t\"frame\" : [\n");
}

void begin_frame(FILE * f, long unsigned int frame) {
    fprintf(f, "\t\t{\n\t\t\t\"n\" : %lu,\n\t\t\t\"planet\" : [\n", frame);
}

void add_planet(FILE * f, planete * p) {
    fprintf(f, "\t\t\t\t{\n\t\t\t\t\t\"id\" : %d,\n\t\t\t\t\t\"r\" : %lf,\n\t\t\t\t\t\"x\" : %lf,\n\t\t\t\t\t\"y\" : %lf\n\t\t\t\t}", p->id, p->rayon, p->x[0], p->x[1]);

    return;
}

void virgule(FILE * f) {
    fprintf(f, ",\n");
}

void end_frame(FILE * f) {
    fprintf(f, "\n\t\t\t]\n\t\t}");
}

void end_file(FILE * f) {
    fprintf(f, "\t]\n}");
}

//n nulero de fram, //len
void write_frame(FILE * f, long unsigned int frame, planete ** planets_tab, int N_planete) {

    begin_frame(f,frame);
    for(int i = 0; i < N_planete-1; i++) {
        add_planet(f,planets_tab[i]);
        virgule(f);
    }
    add_planet(f,planets_tab[N_planete-1]);
    end_frame(f);

}

/*
int main() {
    planete * p = init_planete(1);
    planete * a = init_planete(2);
    planete * b = init_planete(3);
    planete * tab[] = {p,a,b};

    FILE * f;
    f = fopen("data.json", "w");
    begin_file(f);
    write_frame(f,1, tab, 3);
    virgule(f);
    write_frame(f,2, tab, 3);
    end_file(f);
    fclose(f);
    return 0;
}*/