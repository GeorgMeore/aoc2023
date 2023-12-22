#include <stdio.h>

#include "input.h"

#define LEFT  0
#define RIGHT 1
#define UP    2
#define DOWN  3

#define NDIRECTIONS 4
#define NSTATES     7

int mins[NDIRECTIONS][NSTATES][SIZEX][SIZEY];

#define MAX -1U>>1

#if 1
#	define debug(args...)
#else
#	define debug(args...) printf(args)
#endif

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

typedef struct {
	int present;
	int x;
	int y;
	int d;
	int loss;
	int step;
} Path;

void setpath(Path *p, int x, int y, int d, int loss, int step)
{
	p->present = 1;
	p->x = x;
	p->y = y;
	p->d = d;
	p->loss = loss;
	p->step = step;
}

size_t phash(int x, int y, int d, int step)
{
	return x*5576257 + y*6798049 + d*11 + step*9;
}

typedef struct {
	int  count;
	int  indexes[SIZEX*SIZEY*NDIRECTIONS*NSTATES];
	Path paths[SIZEX*SIZEY*NDIRECTIONS*NSTATES];
} Pathset;

Pathset first, second;

#define LENGTH(arr) (sizeof(arr)/sizeof(arr[0]))

void reset(Pathset *ps)
{
	size_t i;
	ps->count = 0;
	for (i = 0; i < LENGTH(ps->paths); i++)
		ps->paths[i].present = 0;
}

Path *findpath(Pathset *ps, int x, int y, int d, int step)
{
	size_t hash = phash(x, y, d, step);
	size_t i = hash % LENGTH(ps->paths);
	while (ps->paths[i].present) {
		if (ps->paths[i].x==x && ps->paths[i].y==y && ps->paths[i].d==d && ps->paths[i].step==step) {
			return &ps->paths[i];
		}
		i = (i + 1) % LENGTH(ps->paths);
	}
	ps->indexes[ps->count] = i;
	ps->count += 1;
	return &ps->paths[i];
}

Path *getith(Pathset *ps, int i)
{
	return &ps->paths[ps->indexes[i]];
}

int stepcost(int x, int y, int d, int step)
{
	if (step < 6)
		return map[x][y];
	else if (d == LEFT)
		return map[x][y]+map[x][y+1]+map[x][y+2]+map[x][y+3];
	else if (d == RIGHT)
		return map[x][y]+map[x][y-1]+map[x][y-2]+map[x][y-3];
	else if (d == UP)
		return map[x][y]+map[x+1][y]+map[x+2][y]+map[x+3][y];
	else
		return map[x][y]+map[x-1][y]+map[x-2][y]+map[x-3][y];
}

#define trace(x, y, d, loss, step) \
	debug( \
		"x=%d, y=%d, d=%c, loss=%d, step=%d\n",                   \
		x, y,                                                     \
		d == LEFT ? 'L' : d == RIGHT ? 'R' : d == UP ? 'U' : 'D', \
		loss, step                                                \
	)

void addpath(Pathset *ps, int x, int y, int d, int loss, int step)
{
	Path *p;
	if (x<0 || x>=SIZEX || y<0 || y>=SIZEY)
		return;
	loss += stepcost(x, y, d, step);
	if (mins[d][step][x][y] <= loss)
		return;
	mins[d][step][x][y] = loss;
	if (loss > 9*(SIZEX + SIZEY) || loss >= mincost())
		return;
	trace(x, y, d, loss, step);
	p = findpath(ps, x, y, d, step);
	setpath(p, x, y, d, loss, step);
}

void addnexts(Pathset *ps, Path *p)
{
	if (p->d == LEFT || p->d == RIGHT) {
		addpath(ps, p->x - 4, p->y, UP,   p->loss, 6);
		addpath(ps, p->x + 4, p->y, DOWN, p->loss, 6);
		if (p->d == LEFT && p->step)
			addpath(ps, p->x, p->y - 1, LEFT, p->loss, p->step - 1);
		if (p->d == RIGHT && p->step)
			addpath(ps, p->x, p->y + 1, RIGHT, p->loss, p->step - 1);
	} else {
		addpath(ps, p->x, p->y - 4, LEFT,  p->loss, 6);
		addpath(ps, p->x, p->y + 4, RIGHT, p->loss, 6);
		if (p->d == UP && p->step)
			addpath(ps, p->x - 1, p->y, UP, p->loss, p->step - 1);
		if (p->d == DOWN && p->step)
			addpath(ps, p->x + 1, p->y, DOWN, p->loss, p->step - 1);
	}
}

#define SWAP(x, y, type) { type tmp = x; x = y; y = tmp; }

/* bfs without hashing runs painfully slow */
int main(void)
{
	Pathset *curr = &first, *next = &second;
	setupmins();
	addpath(curr, 0, 4, RIGHT, 0, 6);
	addpath(curr, 4, 0, DOWN, 0, 6);
	while (curr->count) {
		int i;
		reset(next);
		for (i = 0; i < curr->count; i++) {
			addnexts(next, getith(curr, i));
		}
		SWAP(curr, next, Pathset*);
	}
	printf("%d\n", mincost());
	return 0;
}
