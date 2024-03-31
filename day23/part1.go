package main

import "fmt"

type direction struct {
	di, dj int
	c      byte
}

var directions = []direction{
	{1, 0, 'v'},  // down
	{-1, 0, '^'}, // up
	{0, 1, '>'},  // right
	{0, -1, '<'}, // left
}

func maxpath(trailmap [][]byte, visited [][]bool, i, j int) int {
	if i == len(trailmap)-1 && j == len(trailmap[i])-2 {
		return 0
	}
	visited[i][j] = true
	m := -1
	for _, d := range directions {
		k, l := i+d.di, j+d.dj
		cango := (k >= 0 && k < len(trailmap) &&
			l >= 0 && l < len(trailmap[k]) &&
			(trailmap[k][l] == '.' || trailmap[k][l] == d.c) &&
			!visited[k][l])
		if cango {
			m = max(m, maxpath(trailmap, visited, k, l))
		}
	}
	visited[i][j] = false
	if m == -1 {
		return m
	}
	return m + 1
}

func main() {
	visited := make([][]bool, len(trailmap))
	for i := range visited {
		visited[i] = make([]bool, len(trailmap[i]))
	}
	fmt.Println(maxpath(trailmap, visited, 0, 1))
}
