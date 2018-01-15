
#mapper3 and reducer3 creates recommendations based of given information of a set of items.

import sys

current_key = None
current_rec = None
key = None

for line in sys.stdin:
    key, rec = line.split('/t', 1)
    if current_key == key:
        current_rec = ''.join(sorted(set(rec) & set(current_rec.strip()))) #reduces recommendations by 
																		   #excluding any non-shared values with & fxn
    else:
        if current_key:
            print(" ".join(current_key) + " : " + " ".join(current_rec.strip()))
        current_rec = rec #used for very fist line
        current_key = key #used for very fist line
if current_key == key:
    print(" ".join(current_key) + " : " + " ".join(current_rec))