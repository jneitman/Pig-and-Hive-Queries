
#mapper2 and reducer2 figure out how many times a unique combination of vowels occurs.

import sys

current_key = None
current_count = 0
key = None

for line in sys.stdin: #same as reducer1 but no line.strip()
					   #otherwise reducer would error
					   #and words with no vowels would be missed
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