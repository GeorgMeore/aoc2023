#include <stdio.h>

#include "input.h"

#define NTABLES 7

#define trace(args...) printf(args)

#define LENGHT(arr) sizeof(arr)/sizeof(arr[0])

size_t translate(size_t table[][3], size_t len, size_t src, size_t *ip)
{
	size_t i, diff;
	for (i = 0; ; i++) {
		if (i >= len || src < table[i][1]) {
			*ip = i*2;
			return src;
		}
		diff = src - table[i][1];
		if (diff < table[i][2]) {
			*ip = i*2 + 1;
			return table[i][0] + diff;
		}
	}
}

#define TRANSLATE(from, to, ip) translate(from##_to_##to, LENGHT(from##_to_##to), from, ip)

size_t seed_to_location(size_t seed, size_t path[NTABLES])
{
	size_t soil        = TRANSLATE(seed,        soil,        &path[0]);
	size_t fertilizer  = TRANSLATE(soil,        fertilizer,  &path[1]);
	size_t water       = TRANSLATE(fertilizer,  water,       &path[2]);
	size_t light       = TRANSLATE(water,       light,       &path[3]);
	size_t temperature = TRANSLATE(light,       temperature, &path[4]);
	size_t humidity    = TRANSLATE(temperature, humidity,    &path[5]);
	size_t location    = TRANSLATE(humidity,    location,    &path[6]);
	return location;
}

int samepath(size_t p1[NTABLES], size_t p2[NTABLES])
{
	size_t i;
	for (i = 0; i < NTABLES; i++)
		if (p1[i] != p2[i])
			return 0;
	return 1;
}

size_t min_seed_range_location(size_t start, size_t count)
{
	size_t first, firstpath[NTABLES], last, lastpath[NTABLES];
	first = seed_to_location(start, firstpath);
	last = seed_to_location(start+count-1, lastpath);
	if (samepath(firstpath, lastpath))
		return first;
	first = min_seed_range_location(start, count/2);
	last = min_seed_range_location(start + count/2, count - count/2);
	if (first < last)
		return first;
	return last;
}

int main(void)
{
	size_t i, location, min = -1;
	for (i = 0; i < LENGHT(seeds); i += 2) {
		location = min_seed_range_location(seeds[i], seeds[i+1]);
		if (location < min)
			min = location;
	}
	printf("%lu\n", min);
	return 0;
}
