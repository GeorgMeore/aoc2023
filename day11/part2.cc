#include <stdio.h>

/* #include "input_test.h" */
#include "input.h"

#define rows sizeof(map)/sizeof(map[0])
#define cols sizeof(map[0])

int abs(int a) {
	return a > 0 ? a : -a;
}

int main(void) {
	int row_galaxies[rows] = {0}, col_galaxies[cols] = {0};
	int point_i[rows*cols], point_j[cols*rows];
	size_t points = 0;
	for (size_t i = 0; i < rows; i++) {
		for (size_t j = 0; j < cols; j++) {
			if (map[i][j] == '#') {
				row_galaxies[i] += 1;
				col_galaxies[j] += 1;
				point_i[points] = i;
				point_j[points] = j;
				points += 1;
			}
		}
	}
	int row_costs[rows] = {0}, col_costs[cols] = {0};
	for (size_t i = 0; i < rows; i++) {
		row_costs[i] = (i > 0 ? row_costs[i-1] : -1) + (row_galaxies[i] ? 1 : 1000000);
	}
	for (size_t j = 0; j < cols; j++) {
		col_costs[j] = (j > 0 ? col_costs[j-1] : -1) + (col_galaxies[j] ? 1 : 1000000);
	}
	size_t total = 0;
	for (size_t k = 0; k < points; k++) {
		for (size_t l = 0; l < points; l++) {
			total += (
				abs(row_costs[point_i[k]] - row_costs[point_i[l]]) +
				abs(col_costs[point_j[k]] - col_costs[point_j[l]])
			);
		}
	}
	printf("%lu\n", total/2);
	return 0;
}
