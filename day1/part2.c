#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "input.h"

#define LENGTH(arr) sizeof(arr)/sizeof(arr[0])

#define STARTSWITH(s, needle) !strncmp(s, needle, sizeof(needle) - 1)

int getdigit(const char *s)
{
	if (*s >= '1' && *s <= '9') return *s - '0';
	if (STARTSWITH(s, "one"))   return 1;
	if (STARTSWITH(s, "two"))   return 2;
	if (STARTSWITH(s, "three")) return 3;
	if (STARTSWITH(s, "four"))  return 4;
	if (STARTSWITH(s, "five"))  return 5;
	if (STARTSWITH(s, "six"))   return 6;
	if (STARTSWITH(s, "seven")) return 7;
	if (STARTSWITH(s, "eight")) return 8;
	if (STARTSWITH(s, "nine"))  return 9;
	return -1;
}

int main(void)
{
	size_t i, sum = 0;
	for(i = 0; i < LENGTH(lines); i++) {
		char *pos = lines[i];
		int first = -1, last = -1;
		for (; *pos; pos++) {
			int d = getdigit(pos);
			if (d != -1) {
				last = d;
				if (first == -1)
					first = d;
			}
		}
		if (first > 0)
			sum += first*10 + last;
	};
	printf("%lu\n", sum);
	return 0;
}
