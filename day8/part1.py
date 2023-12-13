#!/usr/bin/python3 -B

#from input_test1 import *
from input import *

def count_steps(trans, steps):
    state = 'AAA'
    count = 0
    while state != 'ZZZ':
        step = count % len(steps)
        state = trans[state][0 if steps[step] == 'L' else 1]
        count += 1
    return count

print(count_steps(states, steps))
