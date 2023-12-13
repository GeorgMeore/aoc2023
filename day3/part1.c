#include <stdio.h>

#include "input.h"

int marked[SIZE][SIZE] = {0};

int isdig(char c)
{
	return c >= '0' && c <= '9';
}

int issym(char c)
{
	return c != '.' && !isdig(c);
}

void markneighbours(int i, int j, int v)
{
	for (int k = i - 1; k <= i + 1; k++) {
		for (int l = j - 1; l <= j + 1; l++) {
			if (k >= 0 && l >= 0 && k < SIZE && l < SIZE) {
				marked[k][l] = marked[k][l] || v;
			}
		}
	}
}

int main(void)
{
	for (int i = 0; i < SIZE; i++) {
		for (int j = 0; j < SIZE; j++) {
			markneighbours(i, j, issym(schema[i][j]));
		}
	}
	int total = 0;
	for (int i = 0; i < SIZE; i++) {
		for (int j = 0; j < SIZE; j++) {
			int num = 0, incl = 0;
			while (isdig(schema[i][j]) && j < SIZE) {
				num = num*10 + schema[i][j] - '0';
				incl = incl || marked[i][j];
				j++;
			}
			if (incl) {
				total += num;
			}
		}
	}
	printf("%d\n", total);
	return 0;
}
