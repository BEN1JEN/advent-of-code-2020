#include <stdio.h>
#include <stdint.h>
#include <math.h>

uint64_t busses[] = {13,0,0,0,0,0,0,37,0,0,0,0,0,461,0,0,0,0,0,0,0,0,0,0,0,0,0,17,0,0,0,0,19,0,0,0,0,0,0,0,0,0,29,0,739,0,0,0,0,0,0,0,0,0,41,0,0,0,0,0,0,0,0,0,0,0,0,23};

int main() {
	uint64_t offset = 49152428274328-54, increase=62932475746153;
	uint64_t time = 0, bus = 0;
	while (1) {
		if (busses[bus]) {
			if (time%busses[bus] == 0) {
				bus++;
				if (bus > 28) {
					printf("%llu, %llu\n", time, bus);
				}
				time++;
			} else {
				bus = 0;
				time = ((time+1+offset)/increase+1)*increase-offset;
			}
		} else {
			bus++;
			time++;
		}
	}
	return 0;
}
