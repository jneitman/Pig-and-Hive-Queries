
#The goal for mapper1 and reducer1 is to figure out x number of words containing y number of vowels.

import sys
import re

line = sys.stdin.readline() #read in line from txt 
pattern = re.compile("[^ \t\n\r\f\v]+") #find all characters except whitespace
Vpattern = re.compile("[aeiouy]") #find all vowels

while line:
    for word in pattern.findall(line): #creates a list of words
        print(str(len(Vpattern.findall(word.lower()))) + "/t" + "1") #find length (number of) vowels in current word
    line = sys.stdin.readline() #read next line						 #and add a tab with a string 1
