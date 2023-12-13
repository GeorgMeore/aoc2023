#include <stdio.h>

#include "input.h"

#define LENGHT(arr) sizeof(arr)/sizeof(arr[0])

size_t translate(size_t table[][3], size_t len, size_t src)
{
	size_t i;
	for (i = 0; i < len; i++) {
		if (src >= table[i][1]) {
			size_t diff = src - table[i][1];
			if (diff < table[i][2]) {
				return table[i][0] + diff;
			}
		}
	}
	return src;
}

#define TRANSLATE(from, to) translate(from##_to_##to, LENGHT(from##_to_##to), from)

int seed_to_location(int seed)
{
	size_t soil        = TRANSLATE(seed, soil);
	size_t fertilizer  = TRANSLATE(soil, fertilizer);
	size_t water       = TRANSLATE(fertilizer, water);
	size_t light       = TRANSLATE(water, light);
	size_t temperature = TRANSLATE(light, temperature);
	size_t humidity    = TRANSLATE(temperature, humidity);
	return TRANSLATE(humidity, location);
}

int main(void)
{
	size_t i, min;
	min = seed_to_location(seeds[0]);
	for (i = 1; i < LENGHT(seeds); i++) {
		size_t location = seed_to_location(seeds[i]);
		if (location < min)
			min = location;
	}
	printf("%lu\n", min);
	return 0;
}
