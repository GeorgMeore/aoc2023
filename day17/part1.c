#include <stdio.h>

#include "input_test.h"

#define LEFT  0
#define RIGHT 1
#define UP    2
#define DOWN  3

int mins[4][3][SIZEX][SIZEY];

#define MAX -1U>>1

void setupmins()
{
	int i, j, k, l;
	for (i = 0; i < 4; i++)
	for (j = 0; j < 3; j++)
	for (k = 0; k < SIZEX; k++)
	for (l = 0; l < SIZEY; l++)
		mins[i][j][k][l] = MAX;
}

int mincost()
{
	int i, j, min = MAX;
	for (i = 0; i < 4; i++)
	for (j = 0; j < 3; j++)
		if (mins[i][j][SIZEX-1][SIZEY-1] < min)
			min = mins[i][j][SIZEX-1][SIZEY-1];
	return min;
}

typedef struct {
	int x;
	int y;
	int d;
	int loss;
	int step;
} Path;

void setpath(Path *p, int x, int y, int d, int loss, int step)
{
	p->x = x;
	p->y = y;
	p->d = d;
	p->loss = loss;
	p->step = step;
}

typedef struct {
	int  count;
	Path paths[SIZEX*SIZEY*3*4];
} Pathset;

Pathset first, second;

void reset(Pathset *ps)
{
	ps->count = 0;
}

void addpath(Pathset *ps, int x, int y, int d, int loss, int step)
{
	int i;
	Path *p;
	if (x<0 || x>=SIZEX || y<0 || y>=SIZEY)
		return;
	loss += map[x][y];
	if (mins[d][step][x][y] <= loss)
		return;
	mins[d][step][x][y] = loss;
	if (loss > 9*(SIZEX + SIZEY) || loss >= mincost())
		return;
	for (i = 0, p = ps->paths; i < ps->count; p++, i++) {
		if (p->x==x && p->y==y && p->d==d && p->step==step) {
			setpath(p, x, y, d, loss, step);
			return;
		}
	}
	setpath(p, x, y, d, loss, step);
	ps->count += 1;
}

void addnexts(Pathset *ps, Path *p)
{
	if (p->d == LEFT || p->d == RIGHT) {
		addpath(ps, p->x - 1, p->y, UP,   p->loss, 2);
		addpath(ps, p->x + 1, p->y, DOWN, p->loss, 2);
		if (p->d == LEFT && p->step)
			addpath(ps, p->x, p->y - 1, LEFT, p->loss, p->step - 1);
		if (p->d == RIGHT && p->step)
			addpath(ps, p->x, p->y + 1, RIGHT, p->loss, p->step - 1);
	} else {
		addpath(ps, p->x, p->y - 1, LEFT,  p->loss, 2);
		addpath(ps, p->x, p->y + 1, RIGHT, p->loss, 2);
		if (p->d == UP && p->step)
			addpath(ps, p->x - 1, p->y, UP, p->loss, p->step - 1);
		if (p->d == DOWN && p->step)
			addpath(ps, p->x + 1, p->y, DOWN, p->loss, p->step - 1);
	}
}

#define swap(x, y, type) { type tmp = x; x = y; y = tmp; }

int main(void)
{
	Pathset *curr = &first, *next = &second;
	setupmins();
	addpath(curr, 0, 1, RIGHT, 0, 2);
	addpath(curr, 1, 0, DOWN, 0, 2);
	while (curr->count) {
		int i;
		reset(next);
		for (i = 0; i < curr->count; i++) {
			addnexts(next, &curr->paths[i]);
		}
		swap(curr, next, Pathset*);
	}
	printf("%d\n", mincost());
	return 0;
}
