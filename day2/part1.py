#!/usr/bin/python3 -B

from input import *

def possible_id_sum(games):
    sum = 0
    for i, game in enumerate(games, 1):
        maxes = {"red": 0, "green": 0, "blue": 0}
        for subset in game:
            for no, color in subset:
                maxes[color] = max(maxes[color], no)
        if maxes["red"] <= 12 and maxes["green"] <= 13 and maxes["blue"] <= 14:
            sum += i
    return sum

print(possible_id_sum(games))
