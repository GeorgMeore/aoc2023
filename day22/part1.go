package main

import "fmt"

type brick [2][3]int

func points(b brick) [][2]int {
	ps := [][2]int{}
	if b[0][0] == b[1][0] {
		for y := b[0][1]; y <= b[1][1]; y++ {
			ps = append(ps, [2]int{b[0][0], y})
		}
	} else {
		for x := b[0][0]; x <= b[1][0]; x++ {
			ps = append(ps, [2]int{x, b[0][1]})
		}
	}
	return ps
}

func contains[E comparable](s []E, v E) bool {
	for i := range s {
		if s[i] == v {
			return true
		}
	}
	return false
}

func settle(bricks []brick) ([][]int, [][]int) {
	supporters := make([][]int, len(bricks))
	dependants := make([][]int, len(bricks))
	zbuff := make(map[[2]int][2]int)
	for i, b := range bricks {
		ps := points(b)
		zmax := 0
		for _, p := range ps {
			v, ok := zbuff[p]
			if ok {
				z, j := v[0], v[1]
				if z > zmax {
					zmax = z
					supporters[i] = nil
				}
				if z == zmax && !contains(supporters[i], j) {
					supporters[i] = append(supporters[i], j)
				}
			}
		}
		for _, p := range ps {
			zbuff[p] = [2]int{zmax + b[1][2] - b[0][2] + 1, i}
		}
		for _, j := range supporters[i] {
			dependants[j] = append(dependants[j], i)
		}
	}
	return supporters, dependants
}

// bubble sort will do
func zsort(bricks []brick) {
	for i := 1; i < len(bricks); i++ {
		for j := 0; j < len(bricks)-i; j++ {
			if bricks[j][0][2] > bricks[j+1][0][2] {
				bricks[j], bricks[j+1] = bricks[j+1], bricks[j]
			}
		}
	}
}

func main() {
	zsort(bricks)
	supporters, _ := settle(bricks)
	essential := make([]bool, len(bricks))
	total := len(bricks)
	for _, s := range supporters {
		if len(s) == 1 && !essential[s[0]] {
			essential[s[0]] = true
			total -= 1
		}
	}
	fmt.Println(total)
}
