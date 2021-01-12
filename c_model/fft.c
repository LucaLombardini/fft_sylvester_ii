#include <stdlib.h>
#include <stdio.h>
#include "fftutil.h"

#define INPUT_FILENAME "samples.txt"
#define OUTPUT_FILENAME "fft_out.txt"
#define N_SAMPLES 16
#define PARALLELS 20

int main(void) {
	FILE *fp_in, *fp_out;
	int32_t inputRe[N_SAMPLES], inputIm[N_SAMPLES], outputRe[N_SAMPLES], outputIm[N_SAMPLES];
	char binaryValue[PARALLELS];
	int i;
	
	// collect data samples from file
	fp_in = fopen(INPUT_FILENAME, "r");
	if (fp_in == NULL) {
		if (puts("[ ERROR ]: input samples file could not be opened !") == EOF) {
			return -1;
		}
	} else {
		// read file
	}
	
	/* write data output to file
	 * format: Re0 Re1 Re2 ... Re15
	 *	   Im0 Im1 Im2 ... Im15
	*/
	fp_out = fopen(OUTPUT_FILENAME, "w");
	for(i = 0; i < N_SAMPLES; i++) {
		fprintf(fp_out, "%s", __int2Bin(outputRe[i]));
		if (i != N_SAMPLES-1) {
			fprintf(fp_out, "%s", " ");
		} else {
			fprintf(fp_out, "%s", "\n");
		}
	}
	for(i = 0; i < N_SAMPLES; i++) {
		fprintf(fp_out, "%s", __int2Bin(outputIm[i]));
		if (i != N_SAMPLES-1) {
			fprintf(fp_out, "%s", " ");
		} else {
			fprintf(fp_out, "%s", "\n");
		}
	}
	
	return 0;
}
