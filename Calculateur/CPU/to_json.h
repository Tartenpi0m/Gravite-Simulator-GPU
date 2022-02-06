#ifndef JSON
#define JSON

#include "planete.h"

#endif //JSON

void begin_file(FILE * f);
void begin_frame(FILE * f, long unsigned int frame);
void add_planet(FILE * f, planete * p);
void virgule(FILE * f);
void end_frame(FILE * f);
void end_file(FILE * f);
void write_frame(FILE * f, long unsigned int frame, planete * planets_tab, int N_planete);
