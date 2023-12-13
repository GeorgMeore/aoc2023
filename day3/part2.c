#include <stdio.h>

#include "input.h"

int adjprod[SIZE][SIZE] = {0};
int adjcnt[SIZE][SIZE] = {0};

int isdig(char c)
{
	return c >= '0' && c <= '9';
}

int issym(char c)
{
	return c != '.' && !isdig(c);
}

void adjupdate(int i, int j, int num)
{
	if (i < 0 || j < 0 || i >= SIZE || j >= SIZE) {
		return;
	}
	adjcnt[i][j] += 1;
	adjprod[i][j] *= num;
}

int main(void)
{
	int i, j, k, total = 0;
	for (i = 0; i < SIZE; i++) {
		for (j = 0; j < SIZE; j++) {
			adjprod[i][j] = 1;
		}
	}
	for (i = 0; i < SIZE; i++) {
		for (j = 0; j < SIZE; j++) {
			int num = 0;
			for (k = j; isdig(schema[i][k]) && k < SIZE; k++) {
				num = num*10 + schema[i][k] - '0';
			}
			if (k != j) {
				adjupdate(i-1, j-1, num);
				adjupdate(i,   j-1, num);
				adjupdate(i+1, j-1, num);
				for (; j < k; j++) {
					adjupdate(i-1, j, num);
					adjupdate(i+1, j, num);
				}
				adjupdate(i-1, j, num);
				adjupdate(i,   j, num);
				adjupdate(i+1, j, num);
			}
		}
	}
	for (i = 0; i < SIZE; i++) {
		for (j = 0; j < SIZE; j++) {
			if (schema[i][j] == '*' && adjcnt[i][j] == 2) {
				total += adjprod[i][j];
			}
		}
	}
	printf("%d\n", total);
	return 0;
}
