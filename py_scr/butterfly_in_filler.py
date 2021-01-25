#! /env/python

import random

not_msb = list("0123456789ABCDEF")
msb = list("0123CDEF")

data_set = 10000
many_chars = 5
many_data = 6

with open("../sim/butterfly_in.hex","w") as fileout:
	for set in range(data_set): # how many butterflies to do
		for j in range(many_data): # how many input values
			tmp = ""
			for i in range(many_chars): # how many bit-blocks
				if i:
					tmp += random.choice(not_msb)
				else:
					tmp = random.choice(msb)
			fileout.writelines(tmp)
