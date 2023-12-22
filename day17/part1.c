#include <stdio.h>

#include "input.h"

#define LEFT  0
#define RIGHT 1
#define UP    2
#define DOWN  3

#define NDIRECTIONS 4
#define NSTATES     3

int mins[NDIRECTIONS][NSTATES][SIZEX][SIZEY];

#define MAX -1U>>1

void setupmins(void)
{
	int i, j, k, l;
	for (i = 0; i < NDIRECTIONS; i++)
	for (j = 0; j < NSTATES; j++)
	for (k = 0; k < SIZEX; k++)
	for (l = 0; l < SIZEY; l++)
		mins[i][j][k][l] = MAX;
}

int mincost(void)
{
	int i, j, min = MAX;
	for (i = 0; i < NDIRECTIONS; i++)
	for (j = 0; j < NSTATES; j++)
		if (mins[i][j][SIZEX-1][SIZEY-1] < min)
			min = mins[i][j][SIZEX-1][SIZEY-1];
	return min;
}

/* dfs is significantly faster than bfs without hashing */
void dfsexplore(int x, int y, int d, int loss, int step)
{
	if (x<0 || x>=SIZEX || y<0 || y>=SIZEY)
		return;
	loss += map[x][y];
	if (mins[d][step][x][y] <= loss)
		return;
	mins[d][step][x][y] = loss;
	if (loss > 9*(SIZEX + SIZEY) || loss >= mincost())
		return;
	if (d == LEFT || d == RIGHT) {
		dfsexplore(x - 1, y, UP,   loss, 2);
		dfsexplore(x + 1, y, DOWN, loss, 2);
		if (d == LEFT && step)
			dfsexplore(x, y - 1, LEFT, loss, step - 1);
		if (d == RIGHT && step)
			dfsexplore(x, y + 1, RIGHT, loss, step - 1);
	} else {
		dfsexplore(x, y - 1, LEFT,  loss, 2);
		dfsexplore(x, y + 1, RIGHT, loss, 2);
		if (d == UP && step)
			dfsexplore(x - 1, y, UP, loss, step - 1);
		if (d == DOWN && step)
			dfsexplore(x + 1, y, DOWN, loss, step - 1);
	}
}

int main(void)
{
	setupmins();
	dfsexplore(0, 1, RIGHT, 0, 2);
	dfsexplore(1, 0, DOWN, 0, 2);
	printf("%d\n", mincost());
	return 0;
}
