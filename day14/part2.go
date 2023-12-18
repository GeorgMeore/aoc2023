package main

import "fmt"

var n = len(platform)

const ncycles = 1000000000

func dump() {
	for i := range platform {
		fmt.Println(string(platform[i]))
	}
	fmt.Println()
}

func rrot() {
	for s := 0; s < n/2; s++ {
		for i := s; i < n-s-1; i++ {
			tl := &platform[s][i]
			tr := &platform[i][n-1-s]
			bl := &platform[n-1-i][s]
			br := &platform[n-1-s][n-1-i]
			*tl, *tr = *tr, *tl
			*tl, *bl = *bl, *tl
			*bl, *br = *br, *bl
		}
	}
}

func tilt() {
	for i := 0; i < n; i++ {
		start := 0
		for start < n {
			end := start
			for end < n && platform[end][i] != '#' {
				if platform[end][i] == 'O' {
					empty := &platform[start][i]
					stone := &platform[end][i]
					*empty, *stone = *stone, *empty
					start += 1
				}
				end += 1
			}
			start = end + 1
		}
	}
}

func cycle() {
	for i := 0; i < 4; i++ {
		tilt()
		rrot()
	}
}

func calc() int {
	total := 0
	for i := 0; i < n; i++ {
		for j := 0; j < n; j++ {
			if platform[i][j] == 'O' {
				total += n - i
			}
		}
	}
	return total
}

func tostr() string {
	s := ""
	for i := 0; i < n; i++ {
		s += string(platform[i])
	}
	return s
}

func main() {
	visited := make(map[string]int)
	results := make(map[int]int)
	for c := 0; c < ncycles; c++ {
		s := tostr()
		prev, ok := visited[s]
		if ok {
			fmt.Println(results[prev + (ncycles - prev) % (c - prev)])
			return
		}
		results[c] = calc()
		visited[s] = c
		cycle()
	}
	fmt.Println(results[len(results)-1])
}
