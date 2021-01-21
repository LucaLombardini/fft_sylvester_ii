#ifndef __BUTTERFLY__
#include "butterfly.h"
#endif

/* ALLIGNMENT MOTIVATION
 *
 * mx = |m39|m38|.|m37|...|m0|
 *
 * ab = |b19|.|b18|...|b0|	-> The allignment must be based on dec. point!
 * 
 * |m39|m38|.|m37|...|m19| |m18|...|m0|  _\ |m39|m38|.|m37|...|m19|...|m0|
 *                   |b19|.|b18|...|b0|   / |b19|b19|.|b18|...|b0|
 *                   						|____\ delta=19
 * Note: sign extention automatically performed since a/b coeff. are casted to 
 * 	signed
 */

int _butterfly(unsigned int* A_r_in, unsigned int* A_i_in, unsigned int* B_r_in, unsigned int* B_i_in, unsigned int* w_r, unsigned int* w_i, unsigned int* A_r_out, unsigned int* A_i_out, unsigned int* B_r_out, unsigned int* B_i_out) {
	signed long int m1, m2, m3, m4, m5, m6;
	signed long int s1, s2, s3, s4, s5, s6;
	signed long int _a_r, _a_i, _b_r, _b_i, _w_r, _w_i;

	_a_r = _signer(*A_r_in);
	_a_i = _signer(*A_i_in);
	_b_r = _signer(*B_r_in);
	_b_i = _signer(*B_i_in);
	_w_r = _signer(*w_r);
	_w_i = _signer(*w_i);
	
	m1 = _b_r * _w_r;
	m2 = _b_i * _w_i;
	m3 = _b_r * _w_i;
	m4 = _b_i * _w_r;
	m5 = ((2 * _a_r) << (BIT_LENGTH-1));// 2AR ALLIGNMENT
	m6 = ((2 * _a_i) << (BIT_LENGTH-1));// 2AI ALLIGNMENT
	s1 = ((_a_r << (BIT_LENGTH-1)) + m1);// AR ALLIGNMENT
	s2 = s1 - m2;
	s3 = ((_a_i << (BIT_LENGTH-1)) + m3);// AI ALLIGNMENT
	s4 = s3 + m4;
	s5 = m5 - s2;
	s6 = m6 - s4;

	*A_r_out = _round_and_scale(s2);
	*A_i_out = _round_and_scale(s4);
	*B_r_out = _round_and_scale(s5);
	*B_i_out = _round_and_scale(s6);
	return 0;
}

/* SIGN MOTIVATION
 * Signed integer multiply and integer multiply instruction work differently!
 *
 */

signed long int _signer(unsigned long int number) {
	unsigned long int _sign = (1 << (BIT_LENGTH-1));
	unsigned long int _negs = ~((1 << (BIT_LENGTH)) - 1);
	if ((number & _sign) == _sign) {
		return (signed long int) (number | _negs);
	} else {
		return (signed long int) number;
	}
}


/* ROUNDING MOTIVATION
 *
 * mx = |m39|m38|.|m37|...|m20|m19|...|m0|
 * 
 * out= |b19|.|b18|...|b0|	-> The trunc. and scale must be based on sizes!
 * 
 *         |m39| |m38|.|m37|...|m20||m19||m18|...|m0|
 *         |b19|.|b18| |b17|...|b0 |
 *
 * rMask = | 0 |...............| 0 || 1 || 0 |...| 0 |
 * sMask = | 1 |....................| 1 || 0 |...| 0 |
 * pMask = | 0 |..........| 0 || 1 || 0 |........| 0 |
 * 
 * - when to round up? 	when the number is at the center while odd or has less 
 * 			error going up !
 *
 * WARNING: SIGN EXTENSION TO BE IMPLEMENTED BY HAND!
 */

unsigned int _round_and_scale(signed long int number) {
	unsigned long int _signdel = ((1 << (BIT_LENGTH)) - 1);// mask to throw away the sign for the print on file
	unsigned long int _rMask = (1 << (BIT_LENGTH-1));// first bit to be truncated
	unsigned long int _sMask = ~(_rMask - 1);	// mask of all 0s before r
	unsigned long int _pMask = (1 << BIT_LENGTH);	// mask to tell if even or odd
	if (((number & _rMask) == _rMask) && (((number & _pMask) == _pMask) || ((number | _sMask) != _sMask))) {
		//if (number > 0) {
			return (unsigned int) ((( number >> BIT_LENGTH) + 1) & _signdel);
		//} else {
		//	return (unsigned int) ((( number >> BIT_LENGTH) & _signdel) -1);
		//}
	} else {
		return (unsigned int) ((number >> BIT_LENGTH) & _signdel);
	}
	
}
