#include <stdio.h>
#include <stdlib.h>
#include "fft.h"


int main(int argc, char** argv) {
	unsigned int result;
	unsigned int op1, op2;
	
	if (argc == 3) {
		op1 = atoi(argv[1]);
		op2 = atoi(argv[2]);
		result = _reverse_kogge_stone(op1,op2);
		printf("%u\n", result);
	} else {
		puts("[ ERROR ]: arguments not compliant with specifications");
		return -1;
	}
	return 0;
}
