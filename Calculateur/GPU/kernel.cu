#include <stdio.h>
#include "planete.h"
#include "simu.cuh"
#include "to_json.h"
#include "kernel.cuh"
#include "book.h"

__global__ void kernel_calculCollision(int indice, planete une_planete, planete * all_planete, int N_corps) {


    int i = threadIdx.x + blockIdx.x*blockDim.x;
    if(i< N_corps && indice < i) {

        if(detect_collision(&une_planete, &all_planete[i])) {
            //printf("%d,%d\n",i,j);
            regroupe(&all_planete[i], &all_planete[indice]);
        }
    }

    /* int i = blockIdx.x * blockDim.x + threadIdx.x;
    int j = blockIdx.x * blockDim.x + threadIdx.y;
    
    if (i<N_corps && j<N_corps && i < j ){
        if(all_planete[i].id != -1) {
            if(all_planete[j].id != -1) {
                if(detect_collision(&all_planete[i], &all_planete[j])) {
                    printf("%d,%d\n",i,j);
                    regroupe(&all_planete[i], &all_planete[j]);
                }
            }
        }
    } */
}

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

__global__ void kernel_calculAcceleration(int indice, planete * all_planete, int N_corps, long int G) {

    int i = threadIdx.x + blockIdx.x*blockDim.x;

    if(i < N_corps) {
        if(i != indice && all_planete[i].id != -1 && all_planete[indice].id != -1) {  
            all_planete[i].a[0] += force_G(G, &all_planete[i], &all_planete[indice], 0);
            all_planete[i].a[1] += force_G(G, &all_planete[i], &all_planete[indice], 1); 
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

__global__ void kernel_updatePosition(planete * all_planete, int N_corps) {

    int i = threadIdx.x + blockIdx.x*blockDim.x;
     if(i < N_corps) {
        if(all_planete[i].id >=1) {

            //Ajoute les accélérations aux vitesses
            all_planete[i].v[0] += 0.00000000001*all_planete[i].a[0]; //0.000000000001
            all_planete[i].v[1] += 0.00000000001*all_planete[i].a[1];

            //Ajoute les vitesses aux positions
            all_planete[i].x[0] += all_planete[i].v[0];
            all_planete[i].x[1] += all_planete[i].v[1];

            all_planete[i].a[0] = 0;
            all_planete[i].a[1] = 0;

            
        }
    } 
}

void gestion(int nb_frame, planete * all_planete, int N_corps, FILE * data, long int G) {

    int frame = 0;

    planete * all_planete_cuda;
    HANDLE_ERROR(cudaMalloc((void **) &all_planete_cuda, sizeof(planete)*N_corps));


    int n_blocks = (int) N_corps / 1024 + 1;
    int n_blocks2 = (int) N_corps / 200 + 1;

    printf("\n\n\n%d, %d\n\n\n", n_blocks, n_blocks2);
    
    HANDLE_ERROR(cudaMemcpy(all_planete_cuda, all_planete, sizeof(planete)*N_corps, cudaMemcpyHostToDevice));
    while(frame < nb_frame) {

        printf("frame : %d\n", frame);
        
        for(int i = 0; i < N_corps; i++) {
            kernel_calculCollision<<<n_blocks,1024>>>(i, all_planete[i], all_planete_cuda, N_corps);      
        } 

        for(int indice = 0; indice < N_corps; indice++) {
            kernel_calculAcceleration<<<n_blocks2,200>>>(indice, all_planete_cuda, N_corps, G);
        }

        kernel_updatePosition<<<n_blocks,1024>>>(all_planete_cuda, N_corps);      


        cudaDeviceSynchronize();
        HANDLE_ERROR(cudaMemcpy(all_planete, all_planete_cuda, sizeof(planete)*N_corps, cudaMemcpyDeviceToHost)); 
        
        write_frame(data,frame, all_planete, N_corps);
        if(frame < nb_frame-1) {
            virgule(data);
        }
        frame++;
    }

    cudaFree((void*) all_planete_cuda);


}