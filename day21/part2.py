#!/usr/bin/python3 -B

from input import garden_map

# I used this for printing the map
def print_map(garden_map, tiles):
    m, n = len(garden_map), len(garden_map[0])
    chars = [
        [
            garden_map[i][j] if (i + x*m, j + y*n) not in tiles else 'O'
            for y in (-2, -1, 0, 1, 2)
            for j in range(n)
        ]
        for x in (-2, -1, 0, 1, 2)
        for i in range(m)
    ]
    print("\n", "\n".join("".join(row) for row in chars), "\n", sep="")

def simulate(garden_map, steps):
    m, n = len(garden_map), len(garden_map[0])
    tiles = {(m//2, n//2)}
    for i in range(steps):
        tiles = {
            (k, l)
            for (i, j) in tiles
            for (k, l) in [(i+1, j), (i-1, j), (i, j-1), (i, j+1)]
            if garden_map[k%m][l%n] != '#'
        }
    return tiles

def count_filter_by_rect(tiles, x1, y1, x2, y2):
    return len([
        (i, j) for (i, j) in tiles
        if i >= x1 and i <= x2 and j >= y1 and j <= y2
    ])

# Calculate the size of a thing like that:
#        #
#       # #
#      # # #
#       # #
#        #
def rhombus_size(n):
    return n*n

# This problem is hard in a very very stupid way
def count_plots(garden_map, steps):
    size  = len(garden_map)
    assert size%2 == 1 and steps%size == size//2
    tiles = simulate(garden_map, size*2 + size//2)

    # My idea was to do the bruteforce calculation for a sufficiently
    # large number of steps and then cut the resulting plots map into chunks,
    # from which you could reconstruct the bigger thing.
    # It worked but there are a lot of implicit assumptions
    # (e.g. that all internal squares are stabilized).
    first        = count_filter_by_rect(tiles, 0,         0,         size-1,  size-1)
    second       = count_filter_by_rect(tiles, 0,         size,      size-1,  size*2-1)
    top_chunk    = count_filter_by_rect(tiles, 2*size,    0,         3*size,  size-1)
    bot_chunk    = count_filter_by_rect(tiles, -2*size-1, 0,         -size-1, size-1)
    tl_thingy    = count_filter_by_rect(tiles, size,      -size,     3*size,  -1)
    tr_thingy    = count_filter_by_rect(tiles, size,      size,      size*3,  size*2-1)
    bl_thingy    = count_filter_by_rect(tiles, -size*2,   -size,     -1,      -1)
    br_thingy    = count_filter_by_rect(tiles, -size*2,   size,      -1,      size*2-1)
    left_corner  = count_filter_by_rect(tiles, -size,     -2*size-1, 2*size,  -size-1)
    right_corner = count_filter_by_rect(tiles, -size,     2*size,    2*size,  3*size)

    count = steps // size
    total = (
        left_corner + right_corner +
        top_chunk + bot_chunk +
        tl_thingy*(count - 1) + tr_thingy*(count - 1) +
        bl_thingy*(count - 1) + br_thingy*(count - 1) +
        rhombus_size(count - 1)*first + rhombus_size(count)*second
    )
    return total

print(count_plots(garden_map, 26501365))
