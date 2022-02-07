#include <stdio.h>
#include "planete.h"
#include "simu.cuh"
#include "to_json.h"
#include "kernel.cuh"
#include "book.h"
#include <sys/time.h>

__global__ void kernel_calculCollision(int indice, planete une_planete, planete * all_planete, int N_corps) {


    int i = threadIdx.x + blockIdx.x*blockDim.x;
    if(i< N_corps && indice > i) {

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


__global__ void kernel_calculAcceleration(int indice, planete * all_planete, int N_corps, long int G) {

    int i = threadIdx.x + blockIdx.x*blockDim.x;

    if(i < N_corps) {
        if(i != indice && all_planete[i].id != -1 && all_planete[indice].id != -1) {  
            double x = force_G(G, &all_planete[i], &all_planete[indice], 0);
            double y = force_G(G, &all_planete[i], &all_planete[indice], 1);

            if(isnan(all_planete[i].a[0]) || isnan(all_planete[i].a[1])) {
                all_planete[i].a[0] = 0.0;
                all_planete[i].a[1] = 0.0;
            }   
            
            all_planete[i].a[0] += force_G(G, &all_planete[i], &all_planete[indice], 0);
            all_planete[i].a[1] += force_G(G, &all_planete[i], &all_planete[indice], 1); 
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

__global__ void kkk(planete * all_planete, int size) {

    int i = threadIdx.x + blockIdx.x*blockDim.x;
    if(i < size) {
        if(isnan(all_planete[i].x[0])) {
            printf("\nNaN\n");
            all_planete[i].id = -1;
        }
    }
}


__host__ void gestion(int nb_frame, planete * all_planete, int N_corps, FILE * data, long int G) {

    int frame = 0;

    planete * all_planete_cuda;
    HANDLE_ERROR(cudaMalloc((void **) &all_planete_cuda, sizeof(planete)*N_corps));


    int n_blocks = (int) N_corps / 1024 + 1;
    int n_blocks2 = (int) N_corps / 800 + 1;

    printf("\n\n\n%d, %d\n\n\n", n_blocks, n_blocks2);

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    float temps_frame;
    float temps_totale = 0;
    
    struct timeval start2;
    struct timeval end;
    float temps_Memcpy = 0;


    HANDLE_ERROR(cudaMemcpy(all_planete_cuda, all_planete, sizeof(planete)*N_corps, cudaMemcpyHostToDevice));
    while(frame < nb_frame) {

        printf("frame : %d\n", frame);


        ////////////////KERNEL////////////////////////
        cudaEventRecord(start);
        for(int i = 0; i < N_corps; i++) {
            kernel_calculCollision<<<n_blocks,1024>>>(i, all_planete[i], all_planete_cuda, N_corps);      
        } 

        for(int indice = 0; indice < N_corps; indice++) {
            kernel_calculAcceleration<<<n_blocks2,800>>>(indice, all_planete_cuda, N_corps, G);
        }

        kernel_updatePosition<<<n_blocks,1024>>>(all_planete_cuda, N_corps);      
        cudaEventRecord(stop);

        //kkk<<<n_blocks, 1024>>>(all_planete_cuda, N_corps);
        cudaDeviceSynchronize();
        cudaEventElapsedTime(&temps_frame, start, stop);
        temps_totale += temps_frame;



        ////////////MEMCPY//////////////////////
        gettimeofday(&start2, NULL);
        HANDLE_ERROR(cudaMemcpy(all_planete, all_planete_cuda, sizeof(planete)*N_corps, cudaMemcpyDeviceToHost)); 
        gettimeofday(&end, NULL);
        temps_Memcpy += (end.tv_sec - start2.tv_sec) + 1e-6*(end.tv_usec - start2.tv_usec);
    

        ///////////JSON/////////////////
        write_frame(data,frame, all_planete, N_corps);
        if(frame < nb_frame-1) {
            virgule(data);
        }


        frame++;
    }



    cudaFree((void*) all_planete_cuda);



    printf("\n\n\n KERNEL TIME : %lf s\n",  temps_totale/1000);
    printf("\n MEMCPY TIME : %f s\n\n\n", temps_Memcpy);


}