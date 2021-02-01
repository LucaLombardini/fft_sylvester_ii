#ifndef __FFT__
#define __FFT__

#include "butterfly.h"
#include <stdio.h>

int _fft(unsigned int* samples_r, unsigned int* samples_i, unsigned int* out_r, unsigned int* out_i);

unsigned int _reverse_kogge_stone(unsigned int a, unsigned int b);

void _level_printer(unsigned int * sre, unsigned int * sim, unsigned int stage);

#endif
