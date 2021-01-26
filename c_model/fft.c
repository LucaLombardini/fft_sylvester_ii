#ifndef __FFT__
#include "fft.h"

#ifndef N_SAMPLES
#pragma message("N_SAMPLES definition not found")
#define N_SAMPLES 16
#endif

int _fft(unsigned int* samples_r, unsigned int* samples_i, unsigned int* out_r, unsigned int* out_i) {
	unsigned int tmp_re[N_SAMPLES];
	unsigned int tmp_im[N_SAMPLES];
	unsigned int *v_in_re, *v_in_im, *v_out_re, *v_out_im;
	unsigned int i, stage, group, max_subgroups, sub_limit;
	unsigned int a_index, b_index, w_index;
	unsigned int coeff_r[N_SAMPLES/2] = {	524287,
						484379,
						370728,
						200636,
						0,
						847940,
						677848,
						564197};
	unsigned int coeff_i[N_SAMPLES/2] = {	0,
						847940,
						677848,
						564197,
						524288,
						564197,
						677848,
						847940};

	max_subgroups = 1;	// tracks how many subgoups in a stage
				// also used to avoid log2 calculus.
	v_in_re = samples_r;	// points to the input arrays just at the
	v_in_im = samples_i;	// beginning
	v_out_re = tmp_re;
	v_out_im = tmp_im;
	for(stage = 0; max_subgroups != N_SAMPLES; stage++) {
		sub_limit = N_SAMPLES / (max_subgroups * 2);
		w_index = 0;
		for(group = 0; group < max_subgroups; group++) {
			for(i = 0; i < sub_limit; i++) {
				a_index = 2 * sub_limit * group + i;
				b_index = _reverse_kogge_stone(a_index, sub_limit); 
				_butterfly(	v_in_re + a_index,
						v_in_im + a_index,
						v_in_re + b_index,
						v_in_im + b_index,
						coeff_r + w_index,
						coeff_i + w_index,
						v_out_re + a_index,
						v_out_im + a_index,
						v_out_re + b_index,
						v_out_im + b_index);
			}
			w_index = _reverse_kogge_stone(w_index, N_SAMPLES/4);
		}
		max_subgroups *= 2; // next stage has double groups than now
		v_in_re = tmp_re;
		v_in_im = tmp_im;
	}
	// reordering
	a_index = 0; // just reuse
	for(i = 0; i < N_SAMPLES; i++) {
		out_r[i] = v_out_re[a_index];
		out_i[i] = v_out_im[a_index];
		a_index = _reverse_kogge_stone(a_index, N_SAMPLES/2);
	}
	return 0;
}

unsigned int _reverse_kogge_stone(unsigned int a, unsigned int b) {
	// bitwise p and g bit vectors
	unsigned int generate;
	unsigned int propagate;
	unsigned int k;

	generate = a & b;
	propagate = a ^ b;

	// kogge-stone adder has log2(in's bitwidth) levels -> iterations
	for (k = 1; k <= 8*sizeof(generate)/2; k *= 2) {
		generate |= (generate >> k) & propagate;
		propagate &= (propagate >> k);
	}
	return (a ^ b ^ (generate >> 1));
}

#endif
