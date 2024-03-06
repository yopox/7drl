def parse_color(color):
    r = int(color[1:3], 16) / 255
    g = int(color[3:5], 16) / 255
    b = int(color[5:7], 16) / 255
    return round(r, 3), round(g, 3), round(b, 3)

colors = '''
#f3f3f3
#737070
#524d4d
#353232
#1d1818
#ea3a3a
#3a96ea
#6479de
#deb964
#64de6f
#7964de
#de6464
#b1470f
#b10f72
#9c0fb1
'''

colors = colors.strip().split('\n')

for color in colors:
    rgb = parse_color(color)
    print(str(color) + " -> " + str(rgb))
