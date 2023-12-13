#include <stdio.h>

#include "input.h"

#define LENGTH(arr) sizeof(arr)/sizeof(arr[0])

int main(void)
{
	size_t i, sum = 0;
	for (i = 0; i < LENGTH(lines); i++) {
		int first = -1, last = -1;
		char *c;
		for (c = lines[i]; *c; c++) {
			if (*c >= '0' && *c <= '9') {
				last = *c - '0';
				if (first == -1)
					first = last;
			}
		}
		sum += first*10 + last;
		first = last = -1;
	}
	printf("%lu\n", sum);
	return 0;
}
