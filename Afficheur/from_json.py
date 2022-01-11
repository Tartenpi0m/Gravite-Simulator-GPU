import json
import pygame

with open('data/data.json') as json_data:
    data_dict = json.load(json_data)

num_frame, num_planete = 0,1
#print(data_dict["frame"][num_frame]["planet"][num_planete])

#print(data_dict)
frame_list = enumerate(data_dict["frame"])

while 1: #Frame boucle
    planete_list = next(frame_list, "end")[1]
    if planete_list == "n":
        break
    else:
        planete_list = enumerate(planete_list["planet"])
        
    while 1:
        planete = next(planete_list, "end")[1]
        if planete == "n":
            break
        print(planete)
        input()

    #print("\n\n\n", next(frame, "end")[1],"\n\n\n")


""" for frame in data_dict["frame"]:
    for planet in frame["planet"]:
        print(planet["id"]) """