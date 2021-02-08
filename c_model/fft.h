/* Author:	Luca Lombardini
 * Academic_y:	2020/2021
 * Purpose:	(Master Degree) Digital Integrated Systems' Final Project
 * Contacts:	s277972@studenti.polito.it
 * 		lombamari2@gmail.com
 */
#ifndef __FFT__
#define __FFT__

#include "butterfly.h"
#include <stdio.h>

int _fft(unsigned int* samples_r, unsigned int* samples_i, unsigned int* out_r, unsigned int* out_i);

unsigned int _reverse_kogge_stone(unsigned int a, unsigned int b);

void _level_printer(unsigned int * sre, unsigned int * sim, unsigned int stage);

#endif
