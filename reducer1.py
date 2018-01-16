
#The goal for mapper1 and reducer1 is to figure out x number of words containing y number of vowels.

import sys

current_key = None
current_count = 0
key = None

for line in sys.stdin:
    line = line.strip()
    key, count = line.split('/t', 1)
    count = int(count)
    if current_key == key:
        current_count += count
    else:
        if current_key:
            print('%s : %s' % (current_key, current_count))
        current_count = count
        current_key = key
if current_key == key:
    print('%s : %s' % (current_key, current_count))
