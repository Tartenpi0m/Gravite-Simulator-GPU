import pygame as pyg

black = (20,20,20)
grey = (120,120,120)
grey2 = (160,160,160)
default_button_size = (100,30)
#default_font = pyg.font.SysFont("Corbel", 25) #Defining a font
default_font_size = 25

class bouton:

    def __init__(self, name, position, texte, font, size=default_button_size, color = grey, color2=grey2, color_text = black):
        
        self.name = name
        self.str = texte
        self.position = position
        self.size = size
        self.color_text = color_text
        self.color = grey
        self.color2 = grey2
        self.font = font

        self.texte = self.font.render(self.str, True, color_text)
        self.rect = [position[0], position[1], size[0], size[1]] #posx,posy,sizex,sizey
        
        self.position_texte = ( (self.size[0] - self.font.size(self.str)[0]) /2  + self.position[0],   (self.size[1] - self.font.size(self.str)[1])/2  + self.position[1]    )
        
        

    def affiche(self, screen, mouse):

        
        if self.overlap(mouse):
            pyg.draw.rect(screen, self.color2, self.rect) #Bouton
            screen.blit(self.texte, self.position_texte) #Texte Bouton
        else:
            pyg.draw.rect(screen, self.color, self.rect) #Bouton
            screen.blit(self.texte, self.position_texte) #Texte Bouton

    def overlap(self, mouse):

        if pyg.Rect(self.rect).collidepoint((mouse.happend["mousex"]), (mouse.happend["mousey"])):
            return True
        else:
            return False
