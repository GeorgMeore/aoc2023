#!/usr/bin/python -B

from input import *

def rows_mirrored(pattern, lower, upper):
    smudge = False
    while lower >= 0 and upper < len(pattern):
        for i in range(len(pattern[0])):
            if pattern[lower][i] != pattern[upper][i]:
                if not smudge:
                    smudge = True
                else:
                    return False
        lower -= 1
        upper += 1
    return smudge

def cols_mirrored(pattern, left, right):
    smudge = False
    while left >= 0 and right < len(pattern[0]):
        for i in range(len(pattern)):
            if pattern[i][left] != pattern[i][right]:
                if not smudge:
                    smudge = True
                else:
                    return False
        left -= 1
        right += 1
    return smudge

def summarize(pattern):
    for i in range(len(pattern) - 1):
        if rows_mirrored(pattern, i, i+1):
            return (i + 1)*100
    for j in range(len(pattern[0]) - 1):
        if cols_mirrored(pattern, j, j+1):
            return j + 1
    return -1

print(sum(map(summarize, patterns)))
