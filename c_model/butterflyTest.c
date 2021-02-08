/* Author:	Luca Lombardini
 * Academic_y:	2020/2021
 * Purpose:	(Master Degree) Digital Integrated Systems' Final Project
 * Contacts:	s277972@studenti.polito.it
 * 		lombamari2@gmail.com
 */
#include <stdio.h>
#include <stdlib.h>
#include "butterfly.h"

#ifndef BIT_LENGTH
#pragma message("BIT_LENGTH definition not found")
#define BIT_LENGTH 20
#endif

#define DATA_VECT_ELEMENT 6
#define HEX_LENGTH (BIT_LENGTH / 4)
#define OUT_FORMAT "%.5X\n"

int main(int argc, char** argv) {
	FILE* fp_in;
	FILE* fp_out;
	unsigned int data_v[DATA_VECT_ELEMENT];	//ar, ai, br, bi, wr, wi
	unsigned int out_v[DATA_VECT_ELEMENT-2];
	unsigned int index;
	if (argc <= 2) {
		if (argc == 1) {
			fp_in = fopen("sample.txt", "r");
		} else {
			fp_in = fopen(argv[1], "r");
		}
		
		fp_out = fopen("butterfly_out.txt", "w");
		if ((fp_in != NULL) && (fp_out != NULL)) {
			index = 0;
			while (!feof(fp_in)) {
				fscanf(fp_in, "%x\n", &data_v[index]);
				index++;
				if (index == DATA_VECT_ELEMENT) {
					_butterfly(data_v, data_v+1, data_v+2, data_v+3, data_v+4, data_v+5, out_v, out_v+1, out_v+2, out_v+3);
					for(index = 0; index < DATA_VECT_ELEMENT-2; index++) {
						fprintf(fp_out, OUT_FORMAT, out_v[index]);
					}
					index = 0;
				}
			}
		} else {
			puts("[ ERROR ]: input file cannot be opened");
			return -2;
		}
	} else {
		puts("[ ERROR ]: arguments not compliant with specifications");
		return -1;
	}
	return 0;
}
