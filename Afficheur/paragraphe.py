import pygame as pyg


class paragraphe:
    #tab_line est un tableau avec à chaque case le numéro de la ligne.
    def __init__(self, tab_texte, tab_line, position, font, color, screen, interligne=10):
        self.font = font
        self.color = color
        self.screen = screen
        self.position = position
        self.interligne = interligne
        self.tab_print = tab_texte[:]
        self.n = len(tab_line)
        self.actualise(tab_texte, tab_line)
        self.caractere_height = self.font.size("abcdefghijklmnopqrstuvwxyz")[1]

    def actualise(self, tab_texte, tab_line):
        self.tab_texte = tab_texte
        self.tab_line = tab_line
        for i in range(self.n):
            self.tab_print[i] = self.font.render(self.tab_texte[i], True, self.color)
            print(i,self.tab_texte[i])

    def affiche(self):
        
        for i in range(self.n):
            pos = (self.position[0],  self.position[1] + self.tab_line[i] * (self.caractere_height + self.interligne))
            self.screen.blit(self.tab_print[i], pos)
        