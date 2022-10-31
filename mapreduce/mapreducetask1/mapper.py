#!/usr/bin/env python

import sys
from random import randint

for line in sys.stdin:
    try:
        article_id = line.strip()
    except ValueError as e:
        continue
    print "%d\t%s" % (randint(0, 10000), article_id)
