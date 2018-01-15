
#mapper2 and reducer2 figure out how many times a unique combination of vowels occurs.

import sys
import re

line = sys.stdin.readline() #like in mapper1
pattern = re.compile("[^ \t\n\r\f\v]+")
Vpattern = re.compile("[aeiouy]")

while line:
    for word in pattern.findall(line):
	
		#below is the start of new code for mapper2
        Vgroup = str(''.join(sorted(Vpattern.findall(word.lower()))))
        if Vgroup == "": #if no vowels are present, create a blank space to represent words with no vowels
            print(" " + "/t" + "1")
        else: #else print group of vowels with a tab and string 1
            print(Vgroup + "/t" + "1") 
    line = sys.stdin.readline()