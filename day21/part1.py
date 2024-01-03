#!/usr/bin/python3 -B

from input import garden_map

def count_plots(garden_map, steps):
    m, n = len(garden_map), len(garden_map[0])
    tiles = {(m//2, n//2)}
    for i in range(steps):
        tiles = {
            (k, l)
            for (i, j) in tiles
            for (k, l) in [(i+1, j), (i-1, j), (i, j-1), (i, j+1)]
            if k >= 0 and k < m and l >= 0 and l < n
            if garden_map[k][l] != '#'
        }
    return len(tiles)

print(count_plots(garden_map, 64))
