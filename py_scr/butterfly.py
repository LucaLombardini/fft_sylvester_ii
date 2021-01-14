#! /env/python

nbit = 20

def _roundScale(number,bit_length):
	if number >= 2**(bit_length-1):
		number = number - (2**nbit)
		return round(2**bit_length + (number / 2**bit_length))
	else:
		return round(number / 2**bit_length) 

# data = [a_r, a_i, b_r, b_i], coeff = [w_r, w_i]
def butterfly_int(data):
	a_r_in = data[0]
	a_i_in = data[1]
	b_r_in = data[2]
	b_i_in = data[3]
	w_r = data[4]
	w_i = data[5]
	a_r_out = a_r_in + b_r_in * w_r - b_i_in * w_i
	a_i_out = a_i_in + b_r_in * w_i + b_i_in * w_r
	b_r_out = 2 * a_r_in - a_r_out
	b_i_out = 2 * a_i_in - a_i_out
	return _roundScale(a_r_out,nbit), _roundScale(a_i_out,nbit), _roundScale(b_r_out,nbit), _roundScale(b_i_out,nbit)
	

def butterfly_fp(data):
	a_r_in = data[0]
	a_i_in = data[1]
	b_r_in = data[2]
	b_i_in = data[3]
	w_r = data[4]
	w_i = data[5]
	a_r_out = a_r_in + b_r_in * w_r - b_i_in * w_i
	a_i_out = a_i_in + b_r_in * w_i + b_i_in * w_r
	b_r_out = 2 * a_r_in - a_r_out
	b_i_out = 2 * a_i_in - a_i_out
