def parse_color(color):
    r = int(color[1:3], 16) / 255
    g = int(color[3:5], 16) / 255
    b = int(color[5:7], 16) / 255
    return round(r, 3), round(g, 3), round(b, 3)

colors = '''
#1d1818
#353232
#524d4d
#f3f3f3
#ea3a3a
#3a96ea
#693d3d
#67693d
#45693d
#3d4c69
#503d69
#d24646
#d28f46
#ccd246
#52d246
#46d283
#46c0d2
#4652d2
#a746d2
#d246cc
#d24683
'''

colors = colors.strip().split('\n')

for color in colors:
    rgb = parse_color(color)
    print(str(color) + " -> " + str(rgb))
