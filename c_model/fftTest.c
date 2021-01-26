#include <stdio.h>
#include <stdlib.h>
#include "fft.h"

#ifndef BIT_LENGTH
#pragma message("BIT_LENGTH definition not found")
#define BIT_LENGTH 20
#endif

#define DATA_VECT_ELEMENT 16
#define HEX_LENGTH (BIT_LENGTH / 4)
#define OUT_FORMAT "%.5X"

int main(int argc, char** argv) {
	FILE* fp_in;
	FILE* fp_out;
	unsigned int data_re[DATA_VECT_ELEMENT], data_im[DATA_VECT_ELEMENT];
	unsigned int out_re[DATA_VECT_ELEMENT], out_im[DATA_VECT_ELEMENT];
	unsigned int index, i, j, k;
	char file_line[(DATA_VECT_ELEMENT)*HEX_LENGTH + 1];
	char tmp[HEX_LENGTH + 1];

	if (argc <= 2) {
		fp_in = fopen(argv[1],"r");
		fp_out = fopen("fft_out.txt", "w");
		if ((fp_in != NULL) && (fp_out != NULL)) {
			while (!feof(fp_in)) { 						// A LINE CONTAINS 16 ELEMENTS
				fscanf(fp_in, "%s\n", file_line); 			// A0-A7-B0-B7
				index++;						// data identifiyer: either ar, ai, br, or bi
				for (i = 0; i < DATA_VECT_ELEMENT; i++) {		// from a single file line only half vector could be filled
					for (j = 0; j < HEX_LENGTH; j++) {		// copy data temporary inside a string buffer
						tmp[j] = file_line[j + i*HEX_LENGTH];				//TEMPORARY BUFFERED SMALLER PACK
					}
					switch (index) {
						case 1:
							sscanf(tmp, "%x", &data_re[i]);				// AR(0 TO 7) & BR(0 TO 7) = X_RE(0 TO 15)
							break;
						case 2:
							sscanf(tmp, "%x", &data_im[i]);				// AI(0 TO 7) & BI(0 TO 7) = X_IM(0 TO 15)
							index = 0;
							_fft(data_re,data_im,out_re,out_im);
							for (k = 0; k < DATA_VECT_ELEMENT; k++) {		// write real part
								fprintf(fp_out, OUT_FORMAT, out_re[k]);
							}
							fprintf(fp_out, "\n");
							for (k = 0; k < DATA_VECT_ELEMENT; k++) {		// write imaginary part
								fprintf(fp_out, OUT_FORMAT, out_im[k]);
							}
							fprintf(fp_out, "\n");
							break;
						case 0:
							break;
						default:
							puts("[ ERROR ]: index outside valid range!");
					}
				}
			}
		} else {
			puts("[ ERROR ]: one or more file/s cannot be opened");
		}
	} else {
		puts("[ ERROR ]: arguments not compliant with specifications");
		return -1;
	}
	return 0;
}
