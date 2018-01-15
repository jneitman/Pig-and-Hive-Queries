
#mapper3 and reducer3 creates recommendations based of given information of a set of items.

import sys
from itertools import combinations


input = sys.stdin.readline()
while input:
    line = str(input)
    line = "".join(line.split()) #remove all spacing ex: 1 : 2 3 5 ! 4 to 1:235!4

    KeyInitial, AllItems = line.split(":") #get the initial number to create keys (KeyInitial)
                                           #and all possible items used to create keys

    AllRecs = AllItems.replace("!","") #all possible recommendation items

    GoodRecs, BadRecs = AllItems.split("!") #separate recommended items from not recommended items

	#Start creating the combinations and recommendations based off the KeyInitial 
    for items in range(1, (len(AllRecs)+1)):
        for Key in [(KeyInitial + ''.join(p)) for p in combinations(AllRecs, items)]: #create our combos (keys)
            Value = ''.join([x for x in list(GoodRecs) if x not in list(Key)]) #create customized values for each key
            print(''.join(sorted(Key)) + "/t" + Value)

    input = sys.stdin.readline()