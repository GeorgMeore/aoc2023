package main

import "fmt"

var n = len(platform)

func dump() {
	for i := range platform {
		fmt.Println(string(platform[i]))
	}
	fmt.Println()
}

func tilt() {
	for i := 0; i < n; i++ {
		start := 0
		for start < n {
			end := start
			for end < n && platform[end][i] != '#' {
				if platform[end][i] == 'O' {
					platform[start][i], platform[end][i] = platform[end][i], platform[start][i]
					start += 1
				}
				end += 1
			}
			start = end + 1
		}
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

func main() {
	tilt()
	fmt.Println(calc())
}
