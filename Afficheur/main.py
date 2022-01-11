import pygame
import threading
import time
import json

import paragraphe
import bouton
import event
import sys


phase = "parametrage"
menu_fps = 4
sim_fps = 20
fps = menu_fps
open_new_file = True #True si le visualisateur arrive à la fin d'un json et doit ouvrir un autre fichier
num_fichier = 0
frame_list = [False,False]

#paramètre
N_planete = 50 #nombre de planetes
frame = 1000 #Nombre de frame à calculer
G = 50 #Constante de gravitation
MR = 10 #Rapport de puissance masse rayon
rayon_max = 5
rayon_min = 1
v_init = 5

#paramètre conversion km to px
value_km = 1000
width_px = 1700
height_px = 1000
ratio = value_km / width_px

black = (20,20,20)
grey = (100,100,100)
red = (200,20,20)
default_button_size = (100, 30)

###INITIALISATION PYGAME ET INTERFACE########

#init
pygame.init()
clock = pygame.time.Clock()

#screen
menu_size = width, height = 800, 300
menu_screen = pygame.display.set_mode(menu_size)

#font
font = pygame.font.SysFont("Corbel", 25) #Defining a font

#item
line = [i for i in range(7)]
d_bouton = 400
d_h_bouton = 14
bouton_list = []  
bouton_list.append(bouton.bouton("valider", (width-default_button_size[0]-20, height-default_button_size[1]-20), texte="Valider", font=font))
bouton_list.append(bouton.bouton("+_planete", (d_bouton,(line[0])*28+d_h_bouton), texte="+", font=font, size=(20,20)))
bouton_list.append(bouton.bouton("-_planete", (d_bouton-30,(line[0])*28+d_h_bouton), texte="-", font=font, size=(20,20)))
bouton_list.append(bouton.bouton("+_frame", (d_bouton,(line[1])*28+d_h_bouton), texte="+", font=font, size=(20,20)))
bouton_list.append(bouton.bouton("-_frame", (d_bouton-30,(line[1])*28+d_h_bouton), texte="-", font=font, size=(20,20)))
bouton_list.append(bouton.bouton("+_G", (d_bouton,(line[2])*28+d_h_bouton), texte="+", font=font, size=(20,20)))
bouton_list.append(bouton.bouton("-_G", (d_bouton-30,(line[2])*28+d_h_bouton), texte="-", font=font, size=(20,20)))
bouton_list.append(bouton.bouton("+_MR", (d_bouton,(line[3])*28+d_h_bouton), texte="+", font=font, size=(20,20)))
bouton_list.append(bouton.bouton("-_MR", (d_bouton-30,(line[3])*28+d_h_bouton), texte="-", font=font, size=(20,20)))
bouton_list.append(bouton.bouton("+_rayon_max", (d_bouton,(line[4])*28+d_h_bouton), texte="+", font=font, size=(20,20)))
bouton_list.append(bouton.bouton("-_rayon_max", (d_bouton-30,(line[4])*28+d_h_bouton), texte="-", font=font, size=(20,20)))
bouton_list.append(bouton.bouton("+_rayon_min", (d_bouton,(line[5])*28+d_h_bouton), texte="+", font=font, size=(20,20)))
bouton_list.append(bouton.bouton("-_rayon_min", (d_bouton-30,(line[5])*28+d_h_bouton), texte="-", font=font, size=(20,20)))
bouton_list.append(bouton.bouton("+_v_init", (d_bouton,(line[6])*28+d_h_bouton), texte="+", font=font, size=(20,20)))
bouton_list.append(bouton.bouton("-_v_init", (d_bouton-30,(line[6])*28+d_h_bouton), texte="-", font=font, size=(20,20)))


tab_texte = ["Nombre de planetes : " + str(N_planete), "Nombre de frames : " + str(frame)
,"Force d'apesanteur : " + str(G), "Rapport de puissance masse/rayon : "+ str(MR),
"Rayon max des planètes :" + str(rayon_max), "Rayon min des planètes : " + str(rayon_min),
"Vitesse initiale max des planètes : " + str(v_init)]
texte = paragraphe.paragraphe(tab_texte, line, (10,10), font, grey, menu_screen)

#controller
souris = event.event()
souris.happend["mousex"], souris.happend["mousey"] = pygame.mouse.get_pos() 
for un_bouton in bouton_list:
    souris.happend[un_bouton.name] = False




#Thread qui attend la fin du calcule de C
def wait_end():

    global phase
    s = "lol"
    f = open("data/c_to_py")
    while(s != "end"):
        s = f.read()
    if s == "end":
        phase = "visualisation"
    return


###########"BOUCLE PRINCIPALE###########""
while 1:

    
    for event in pygame.event.get(): #Recupération des events
        if event.type == pygame.QUIT:  
                pygame.quit()
        if event.type == pygame.MOUSEMOTION:
            souris.happend["mousex"], souris.happend["mousey"] = pygame.mouse.get_pos() 
        if event.type == pygame.MOUSEBUTTONDOWN:
            for un_bouton in bouton_list:
                if un_bouton.overlap(souris):
                    souris.happend[un_bouton.name] = True

    menu_screen.fill(black)

    if phase == "parametrage": # Boucle du menu
        #Execution des events
        if souris.happend[bouton_list[1].name] == True:
            if N_planete >= 500:
                N_planete += 500
            elif N_planete >= 50:
                N_planete += 50
            elif N_planete >= 10:
                N_planete += 10
            else:
                N_planete += 1
            souris.happend[bouton_list[1].name] = False

        if souris.happend[bouton_list[2].name] == True:
            if N_planete <= 0:
                N_planete += 0
            elif N_planete <=10:
                N_planete -= 1
            elif N_planete <=50:
                N_planete -= 10
            elif N_planete <=500:
                N_planete -= 50
            else:
                N_planete -= 500
            souris.happend[bouton_list[2].name] = False
        
        if souris.happend[bouton_list[3].name] == True:
            frame += 250
            souris.happend[bouton_list[3].name] = False

        if souris.happend[bouton_list[4].name] == True:
            frame -= 250
            souris.happend[bouton_list[4].name] = False

        if souris.happend[bouton_list[5].name] == True:
            G *= 2
            G = round(G)
            souris.happend[bouton_list[5].name] = False
        
        if souris.happend[bouton_list[6].name] == True:
            G /= 2
            G = round(G)
            souris.happend[bouton_list[6].name] = False
        
        if souris.happend[bouton_list[7].name] == True:
            MR += 1
            souris.happend[bouton_list[7].name] = False
        
        if souris.happend[bouton_list[8].name] == True:
            if MR >=2:
                MR -=1
            souris.happend[bouton_list[8].name] = False

        if souris.happend[bouton_list[9].name] == True:
            rayon_max +=1
            souris.happend[bouton_list[9].name] = False

        if souris.happend[bouton_list[10].name] == True:
            if rayon_max >=3:
                rayon_max -=1
            souris.happend[bouton_list[10].name] = False
        
        if souris.happend[bouton_list[11].name] == True:
            rayon_min +=1
            souris.happend[bouton_list[11].name] = False

        if souris.happend[bouton_list[12].name] == True:
            if rayon_min >= 2:
                rayon_min -=1
            souris.happend[bouton_list[12].name] = False
        
        if souris.happend[bouton_list[13].name] == True:
            v_init +=1
            souris.happend[bouton_list[13].name] = False

        if souris.happend[bouton_list[14].name] == True:
            if v_init >= 2:
                v_init -=1
            souris.happend[bouton_list[14].name] = False







        tab_texte = ["Nombre de planetes : " + str(N_planete), "Nombre de frames : " + str(frame)
,"Force d'apesanteur : " + str(G), "Rapport de puissance masse/rayon : "+ str(MR),
"Rayon max des planètes :" + str(rayon_max), "Rayon min des planètes : " + str(rayon_min),
"Vitesse initiale max des planètes : " + str(v_init)]
        texte.actualise(tab_texte, line)


        #Affichage
        for un_bouton in bouton_list:
            un_bouton.affiche(menu_screen, souris)
        texte.affiche()

        #####CLICK SUR VALIDER############
        if souris.happend[bouton_list[0].name] == True: 

            #Initialisation du second menu
            phase, temps = "calcule", 0
            param_tab = [] #tableau comportant les paramètres d'initialisation à envoye à C
            param_tab.append(N_planete)
            param_tab.append(frame)
            param_tab.append(G)
            param_tab.append(MR)
            param_tab.append(rayon_max)
            param_tab.append(rayon_min)
            param_tab.append(v_init)
            param_tab.append("start") #dernier element du tableau pour indiquer a C de lancer les calculs
            menu_screen.fill(black)
            temps_texte = paragraphe.paragraphe(["Temps ecoulé : " + str(round(temps,1)) +"s"], [0],(width/2-100, height/2), font, grey, menu_screen)   
            pygame.display.update()


            flag = threading.Thread(target=wait_end)
            
            #ENVOIE DES PARAMETRE A C
            f = open("data/py_to_c", 'w') # ouverture du fifo
            for element in param_tab:  # Envoyer les variables par le fifo (Nombre de planete )
                print("Write :", element)
                f.write(str(element)  +'\0')
                f.flush()
                time.sleep(0.1)
            f.close()

            print("pystarted")
            #ATTENDRE QUE C SOIT PRET
            s = "lol"
            f = open("./data/c_to_py", 'r') #bloquant
            while(s != "started"):
                s = f.read() # Attendre le signal pret a commencer du programme C (non bloquant)
            print(s)
            f.close()


            #DEBUT DU COMPTE DU TEMPS
            if(s == "started"):

                flag.start()
                
                #Affichage du compte du temps
                while phase == "calcule":
                    temps_texte.actualise(["Temps ecoulé : " + str(round(temps,1))], [0])
                    temps += 0.1
                    menu_screen.fill(black)
                    temps_texte.affiche() 
                    pygame.display.update([width/2-100, height/2, 149,18])
                    clock.tick(10) #10fps

                    #si C finis les calculs, LANCER LA VISUALISATION
                    if(phase == "visualisation"):
                        flag.join() #fin du thread qui compte le temps
                        print("Lancer la VISUALISATION")
                        break

            souris.happend["valider"] = False
            
    if phase == "visualisation": #Boucle de la simulation

        if fps == menu_fps: #Initialisation
            num_frame = 1
            #Chargement du 1er fichier
            num_fichier+=1
            with open('data/data' + str(num_fichier) +'.json') as json_data:
                data_dict = json.load(json_data)
            frame_list[(num_fichier-1)%2] = enumerate(data_dict["frame"])

            menu_size = width_px, height_px
            menu_screen = pygame.display.set_mode(menu_size)
            fps = sim_fps

        if open_new_file: #si on nouveau fichier (peut devenir un thread si necessaire)
            open_new_file = False
            num_fichier+=1
            try:
                with open('data/data' + str(num_fichier) +'.json') as json_data:
                        data_dict = json.load(json_data)
                        print("Changement file")
            except FileNotFoundError:
                print("EXIT")
                sys.exit()

            frame_list[(num_fichier-1)%2] = enumerate(data_dict["frame"])
                
        planete_list = next(frame_list[num_fichier%2], "end")[1]
     
        if planete_list == "n": #si dernière frame du fichier
            open_new_file = True 
            continue
        else:
            print("Nouvelle frame : ", num_frame)
            num_frame += 1
            planete_list = enumerate(planete_list["planet"])
            
        while 1:
            planete = next(planete_list, "end")[1]
            if planete == 'n':
                break

            r = planete['r']/ratio
            x = planete['x']/ratio
            y = planete['y']/ratio

            #affiche un round rouge planete
            pygame.draw.circle(menu_screen, red, (x,y), r)
        
    if phase == "visualisation": print("Update")
    pygame.display.update()
    clock.tick(fps) #10fps
