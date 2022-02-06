#ifndef PLANET
#define PLANET

typedef struct planete planete;
struct planete {

    int id;
    double rayon;
    double x[2];
    double v[2];
    double a[2];
    double masse;

};
#endif //PLANET

void init_planete(planete * ma_planete, int id, int MR, int rayon_max, int rayon_min,int v_init);
void init_trou_noir(planete * ma_planete);

planete * init_all_planete(int N_planete, int N_trou_noir, int MR, int rayon_max, int rayon_min,int v_init);

void free_all_planete(planete * tab, int N_planete);