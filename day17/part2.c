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

/* #define debug(args...) */
#define debug(args...) printf(args)

void setupmins()
{
	int i, j, k, l;
	for (i = 0; i < NDIRECTIONS; i++)
	for (j = 0; j < NSTATES; j++)
	for (k = 0; k < SIZEX; k++)
	for (l = 0; l < SIZEY; l++)
		mins[i][j][k][l] = MAX;
}

int mincost()
{
	int i, j, min = MAX;
	for (i = 0; i < NDIRECTIONS; i++)
	for (j = 0; j < NSTATES; j++)
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
	Path paths[SIZEX*SIZEY*NDIRECTIONS*NSTATES];
} Pathset;

Pathset first, second;

void reset(Pathset *ps)
{
	ps->count = 0;
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

void trace(int x, int y, int d, int loss, int step)
{
	debug(
		"x=%d, y=%d, d=%c, loss=%d, step=%d\n",
		x, y,
		d == LEFT ? 'L' : d == RIGHT ? 'R' : d == UP ? 'U' : 'D',
		loss, step
	);
}

void addpath(Pathset *ps, int x, int y, int d, int loss, int step)
{
	int i;
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

#define swap(x, y, type) { type tmp = x; x = y; y = tmp; }

/* this thing is painfully slow - perhaps a hash table
 * should be used for pathsets */
void bfs(void)
{
	Pathset *curr = &first, *next = &second;
	setupmins();
	addpath(curr, 0, 4, RIGHT, 0, 6);
	addpath(curr, 4, 0, DOWN, 0, 6);
	while (curr->count) {
		int i;
		reset(next);
		for (i = 0; i < curr->count; i++) {
			addnexts(next, &curr->paths[i]);
		}
		swap(curr, next, Pathset*);
	}
	printf("%d\n", mincost());
}

void dfsexplore(int x, int y, int d, int loss, int step)
{
	if (x<0 || x>=SIZEX || y<0 || y>=SIZEY)
		return;
	trace(x, y, d, loss, step);
	loss += stepcost(x, y, d, step);
	if (mins[d][step][x][y] <= loss)
		return;
	mins[d][step][x][y] = loss;
	if (loss > 9*(SIZEX + SIZEY) || loss >= mincost())
		return;
	if (d == LEFT || d == RIGHT) {
		dfsexplore(x - 4, y, UP,   loss, 6);
		dfsexplore(x + 4, y, DOWN, loss, 6);
		if (d == LEFT && step)
			dfsexplore(x, y - 1, LEFT, loss, step - 1);
		if (d == RIGHT && step)
			dfsexplore(x, y + 1, RIGHT, loss, step - 1);
	} else {
		dfsexplore(x, y - 4, LEFT,  loss, 6);
		dfsexplore(x, y + 4, RIGHT, loss, 6);
		if (d == UP && step)
			dfsexplore(x - 1, y, UP, loss, step - 1);
		if (d == DOWN && step)
			dfsexplore(x + 1, y, DOWN, loss, step - 1);
	}
}

/* this is significantly faster */
void dfs(void)
{
	setupmins();
	dfsexplore(0, 4, RIGHT, 0, 6);
	dfsexplore(4, 0, DOWN, 0, 6);
	printf("%d\n", mincost());
}

int main(void)
{
	dfs();
	return 0;
}
