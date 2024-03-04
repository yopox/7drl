def parse_color(color):
    r = int(color[1:3], 16) / 255
    g = int(color[3:5], 16) / 255
    b = int(color[5:7], 16) / 255
    return round(r, 3), round(g, 3), round(b, 3)

colors = '''
#2e2c3b
#3e415f
#55607d
#747d88
#41de95
#2aa4aa
#3b77a6
#249337
#56be44
#c6de78
#f3c220
#c4651c
#b54131
#61407a
#8f3da7
#ea619d
#c1e5ea
'''

colors = colors.strip().split('\n')

for color in colors:
    rgb = parse_color(color)
    print(str(color) + " -> " + str(rgb))
