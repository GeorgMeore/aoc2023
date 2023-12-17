#!/usr/bin/python3 -B

#from input_test import *
from input import *

def count_arrangements(syms, sizes):
    syms_len, sizes_len = len(syms), len(sizes)
    broken = [0 for i in range(syms_len+1)]
    for nsym in range(1, syms_len+1):
        if syms[nsym-1] == '.':
            broken[nsym] = 0
        else:
            broken[nsym] = broken[nsym-1] + 1
    counts = [
        [0 for j in range(sizes_len+1)]
        for i in range(syms_len+1)
    ]
    for nsym in range(0, syms_len+1):
        if nsym > 0 and syms[nsym-1] == '#':
            break
        counts[nsym][0] = 1
    for nsym in range(1, syms_len+1):
        for nsize in range(1, sizes_len+1):
            s, n = syms[nsym-1], sizes[nsize-1]
            if s == '.' or s == '?':
                counts[nsym][nsize] += counts[nsym-1][nsize]
            if (s == '#' or s == '?') and broken[nsym] >= n:
                if n == nsym:
                    counts[nsym][nsize] += counts[0][nsize-1]
                elif syms[nsym-n-1] != '#':
                    counts[nsym][nsize] += counts[nsym-n-1][nsize-1]
    return counts[syms_len][sizes_len]

def arrangements_count_sum(records):
    total = 0
    for syms, sizes in records:
        total += count_arrangements("?".join([syms] * 5), sizes*5)
    return total

print(arrangements_count_sum(records))
