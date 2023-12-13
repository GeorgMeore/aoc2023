#!/usr/bin/python3 -B

from input import *

def min_power_sum(games):
    sum = 0
    for i, game in enumerate(games, 1):
        maxes = {"red": 0, "green": 0, "blue": 0}
        for subset in game:
            for no, color in subset:
                maxes[color] = max(maxes[color], no)
        sum += maxes["red"] * maxes["green"] * maxes["blue"]
    return sum

print(min_power_sum(games))
