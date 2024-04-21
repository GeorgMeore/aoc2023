package main

import "fmt"

func main() {
	adj := make(map[string][]string)
	for _, row := range connections {
		curr := row[0]
		for _, neig := range row[1:] {
			adj[curr] = append(adj[curr], neig)
			adj[neig] = append(adj[neig], curr)
		}
	}
	seen := make(map[string]bool)
	prod := 1
	for vert := range adj {
		if !seen[vert] {
			size := 0
			seen[vert] = true
			for todo := []string{vert}; len(todo) > 0; todo = todo[1:] {
				curr := todo[0]
				for _, neig := range adj[curr] {
					skip := false
					for _, conn := range excluded {
						skip = skip || (curr == conn[0] && neig == conn[1])
						skip = skip || (curr == conn[1] && neig == conn[0])
					}
					if !seen[neig] && !skip {
						seen[neig] = true
						todo = append(todo, neig)
					}
				}
				size += 1
			}
			prod *= size
		}
	}
	fmt.Println(prod)
}
