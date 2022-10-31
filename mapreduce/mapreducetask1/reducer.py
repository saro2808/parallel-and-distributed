#!/usr/bin/env python3

import sys
from random import randint

current_key = None
key_index_in_line = 0
lines_count = 0
limit = randint(1, 5)
for line in sys.stdin:
    try:
        key = line.strip().split('\t', 1)[1]
    except ValueError as e:
        continue
    if key_index_in_line < limit - 1:
        key_index_in_line += 1
        print(key + ',', end='')
    else:
        key_index_in_line = 0
        limit = randint(1, 5)
        print(key, sep='')
