#ifndef __FFTUTIL__
#include "fftutil.h"
#endif

int _butterfly(int* A_r_in, int* A_i_in, int* B_r_in, int* B_i_in, int* w_re, int* w_i, int* A_r_out, int* A_i_out, int* B_r_out, int* B_i_out) {
	long int m1, m2, m3, m4, m5, m6;
	long int s1, s2, s3, s4, s5, s6;
	m1 = (long int) B_r_in * w_r;
	m2 = (long int) B_i_in * w_i;
	m3 = (long int) B_r_in * w_i;
	m4 = (long int) B_i_in * w_r;
	m5 = (long int) 2 * A_r_in;
	m6 = (long int) 2 * A_i_in;
	s1 = (long int) A_r_in + m1;
	s2 = (long int) s1 - m2;
	s3 = (long int) A_i_in + m3;
	s4 = (long int) s3 + m4;
	s5 = (long int) m5 - s2;
	s6 = (long int) m6 - s4;

	A_r_out = _round_and_scale(s2);
	A_i_out = _round_and_scale(s4);
	B_r_out = _round_and_scale(s5);
	B_i_out = _round_and_scale(s6);
	return 0;
}

int _round_and_scale(long int number) {
	long int _rMask = (1 << BIT_LENGTH-1);	// first bit to be truncated
	long int _sMask = ~(_rMask - 1);	// mask of all 0s before r
	long int _pMask = (1 << BIT_LENGTH);	// mask to tell if even or odd
	if ((number & _rMask == _rMask) && (number & _pMask == _pMask) && (number | _sMaks == _sMask)) {
		return (int) ((number >> BIT_LENGTH) + 1);
	} else {
		return (int) (number >> BIT_LENGTH);
	}
	
}
