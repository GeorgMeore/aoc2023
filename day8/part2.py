#!/usr/bin/python3 -B

#from input_test2 import *
from input import *

def is_start_state(state):
    return state[-1] == 'A'

def is_end_state(state):
    return state[-1] == 'Z'

def analyze_state(state, trans, steps):
    count = 0
    ends = []
    visited = {}
    while True:
        step = count % len(steps)
        if (state, step) in visited:
            start = visited[(state, step)]
            period = count - start
            pre = [pos for pos in ends if pos < start]
            post = [(pos - start) % period for pos in ends if pos > start]
            return pre, post, start, period
        visited[(state, step)] = count
        if is_end_state(state):
            ends.append(count)
        state = trans[state][0 if steps[step] == 'L' else 1]
        count += 1

def gcd(a, b):
    while a != 0:
        a, b = b % a, a
    return b

def lcm(a, b):
    return (a * b) // gcd(a, b)

def is_a_solution(stats, i):
    for pre, post, start, period in stats:
        if i >= start and (i - start) % period not in post:
            return False
        if i < start and i not in pre:
            return False
    return True

def combine(r1, r2):
    # This algorithm uses the fact that in my case
    # the data formed a very specific "runners"
    # i.e. no pre-loop end hits and only one in-loop hit.
    # A general solution is much more complex.
    i = r1[2] + r1[1][0]
    while True:
        if is_a_solution([r1, r2], i):
            return ([], [0], i, lcm(r1[3], r2[3]))
        i += r1[3]

def count_steps(trans, steps):
    start = [
        state for state in trans.keys()
        if is_start_state(state)
    ]
    runners = [
        analyze_state(state, trans, steps)
        for state in start
    ]
    while len(runners) > 1:
        first = runners.pop()
        second = runners.pop()
        runners.append(combine(first, second))
    return runners[0][2] + runners[0][1][0]

print(count_steps(states, steps))
