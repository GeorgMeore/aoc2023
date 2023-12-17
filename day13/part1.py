#!/usr/bin/python -B

from input import *

def rows_mirrored(pattern, lower, upper):
    while lower >= 0 and upper < len(pattern):
        for i in range(len(pattern[0])):
            if pattern[lower][i] != pattern[upper][i]:
                return False
        lower -= 1
        upper += 1
    return True

def cols_mirrored(pattern, left, right):
    while left >= 0 and right < len(pattern[0]):
        for i in range(len(pattern)):
            if pattern[i][left] != pattern[i][right]:
                return False
        left -= 1
        right += 1
    return True

def summarize(pattern):
    for i in range(len(pattern) - 1):
        if rows_mirrored(pattern, i, i+1):
            return (i + 1)*100
    for j in range(len(pattern[0]) - 1):
        if cols_mirrored(pattern, j, j+1):
            return j + 1
    return -1

print(sum(map(summarize, patterns)))
