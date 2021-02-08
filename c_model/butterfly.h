/* Author:	Luca Lombardini
 * Academic_y:	2020/2021
 * Purpose:	(Master Degree) Digital Integrated Systems' Final Project
 * Contacts:	s277972@studenti.polito.it
 * 		lombamari2@gmail.com
 */
#ifndef __BUTTERFLY__
#define __BUTTERFLY__

int _butterfly(unsigned int* A_r_in, unsigned int* A_i_in, unsigned int* B_r_in, unsigned int* B_i_in, unsigned int* w_r, unsigned int* w_i, unsigned int* A_r_out, unsigned int* A_i_out, unsigned int* B_r_out, unsigned int* B_i_out);

signed long int _signer(unsigned long int number);

unsigned int _round_and_scale(signed long int number);

#endif
