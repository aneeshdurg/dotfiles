#! /usr/bin/python3 
from random import randint
import os
_, columns = os.popen('stty size', 'r').read().split()
columns = int(columns)

def fitColumn(final, s):
    if len(s) < columns:
        final.append(s)
    else:
        c = columns
        while c>=0 and s[c] != ' ':
            c-=1
        if c < 0:
            final.append(s)
        else:
            #print('SPLIT', s[:c],'|', s[c:])
            final.append(s[:c])
            fitColumn(final, s[c:])

quotes = [
    "Just as there's no such thing as a bug-free program, there's no program that can't be debugged.\n\t-Ghost in the Shell (1995)",
    "Everyone, deep in their hearts, is waiting for the end of the world to come.\n\t-Haruki Murakami, 1Q84 ",
    "It is not that the meaning cannot be explained. But there are certain meanings that are lost forever the moment they are explained in words.\n\t-Haruki Murakami, 1Q84",
    "Only the inanimate may be so alive.\n\t-David Mitchell, Cloud Atlas",
    'The mind is not like raindrops. It does not fall from the skies, it does not lose itself among other things.\n\t-Haruki Murakami, Hard Boiled Wonderland And The End Of The World',
    "Distilled for the eradication of seemingly incurable sadness.\n\t-Cillian Murphy, Peaky Blinders",
    "Come here you worthless pup. Come here and take your medicine!\n\t-Stephen King, The Shining",
    "Arguing with anonymous strangers on the Internet is a sucker's game because they almost always turn out to be—or to be indistinguishable from—self-righteous sixteen-year-olds possessing infinite amounts of free time.\n\t-Neal Stephenson, Cryptonomicon",
    "But everyone also lives in the world inside their own head. An \x1B[3minscape\x1B[0m, a world of thought.\n\t-Joe Hill, NOS4A2"
    ]

r = randint(0, len(quotes)-1)
selected = quotes[r].split('\n')
final = []
for s in selected:
    fitColumn(final, s)

for f in final:
    print(f)#print(quotes[r]+'\n')
