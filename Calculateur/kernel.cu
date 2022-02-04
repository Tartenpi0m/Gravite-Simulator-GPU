#include <stdio.h>
#include "planete.h"
#include "simu.cuh"
#include "to_json.h"
#include "book.h"

__global__ void kernel_calculCollision(planete ** all_planete, int N_corps) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int j = blockIdx.x * blockDim.x + threadIdx.y;
    
    if (i<N_corps && j<N_corps){
        printf("%d,%d\n",i,j);
        if(all_planete[i]->id != -1) {
            if(all_planete[j]->id != -1) {
                if(detect_collision(all_planete[i], all_planete[j])) {
                    regroupe(all_planete[i], all_planete[j]);
                }
            }
        }
    }
}

void calculCollision(planete ** all_planete, int N_corps) {

    for(int i = 0; i < N_corps; i++) {
        for(int j = 0; j < N_corps; j++) {
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
}


void calculAcceleration(planete ** all_planete, int N_corps, long int G) {

    for(int i = 0; i < N_corps; i++) {
            all_planete[i]->a[0] = 0;
            all_planete[i]->a[1] = 0;
            for(int j = 0; j < N_corps; j++) {
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
}

__global__ void kernel_updatePosition(planete ** all_planete, int N_corps) {

    int i = threadIdx.x + blockIdx.x*blockDim.x;
    all_planete[0]->id = 5;
    /* if(i < N_corps) {
        if(all_planete[i]->id >=1) {

            //Ajoute les accélérations aux vitesses
            all_planete[i]->v[0] += 0.00000000001*all_planete[i]->a[0]; //0.000000000001
            all_planete[i]->v[1] += 0.00000000001*all_planete[i]->a[1];

            //Ajoute les vitesses aux positions
            all_planete[i]->x[0] += all_planete[i]->v[0];
            all_planete[i]->x[1] += all_planete[i]->v[1];
        }
    } */
}


void gestion(int nb_frame, planete ** all_planete, int N_corps, FILE * data, long int G) {

    int frame = 0;
    
    /* int * N_corps_cuda;
    cudaMalloc((void **) &N_corps_cuda, sizeof(int));
    cudaMemcpy(N_corps_cuda, &N_corps, sizeof(int), cudaMemcpyHostToDevice); */

    planete ** all_planete_cuda;
    HANDLE_ERROR(cudaMalloc((void ***) &all_planete_cuda, sizeof(planete*)*N_corps));
    for(int i = 0; i < N_corps; i++) {
        HANDLE_ERROR(cudaMalloc((void **) &all_planete_cuda[i], sizeof(planete)));
    } 


    int n_blocks_calculCollision= (int) (N_corps*N_corps) / 1024 + 1;
    dim3 thread_per_blocks(32,32);

    int n_blocks_update_position = (int) N_corps / 1024 +1;
    printf("\n//%d // %d\n", n_blocks_calculCollision, n_blocks_update_position);
    //planete tab_planete[N_corps]; 
    
    while(frame < nb_frame) {
        //printf("Check collison");

        //HANDLE_ERROR(cudaMemcpy(all_planete_cuda, all_planete, sizeof(planete*)*N_corps, cudaMemcpyHostToDevice));
        //kernel_calculCollision<<<n_blocks_calculCollision,thread_per_blocks>>>(all_planete_cuda, N_corps);
        //HANDLE_ERROR(cudaMemcpy(all_planete, all_planete_cuda, sizeof(planete*)*N_corps, cudaMemcpyDeviceToHost));
        //cudaDeviceSynchronize();
        calculCollision(all_planete, N_corps);
        calculAcceleration(all_planete, N_corps, G);

        HANDLE_ERROR(cudaMemcpy(all_planete_cuda, all_planete, sizeof(planete*)*N_corps, cudaMemcpyHostToDevice));
        for(int i = 0; i < N_corps; i++) {
            HANDLE_ERROR(cudaMemcpy(all_planete_cuda[i], all_planete[i], sizeof(planete), cudaMemcpyHostToDevice));
        } 
        
        kernel_updatePosition<<<n_blocks_update_position,1024>>>(all_planete_cuda, N_corps);
        
        HANDLE_ERROR(cudaMemcpy(all_planete, all_planete_cuda, sizeof(planete*)*N_corps, cudaMemcpyDeviceToHost)); 
        for(int i = 0; i < N_corps; i++) {
            HANDLE_ERROR(cudaMemcpy(all_planete[i], all_planete_cuda[i], sizeof(planete), cudaMemcpyDeviceToHost));
        } 
        


        printf(" x2:%lf\n", all_planete[0]->x[0]);

        write_frame(data,frame, all_planete, N_corps);
        if(frame < nb_frame-1) {
            virgule(data);
        }

        frame++;
    }

    cudaFree((void*) all_planete_cuda);

}