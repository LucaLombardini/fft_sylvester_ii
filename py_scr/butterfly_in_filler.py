#! /env/python

# Author:       Luca Lombardini
# Academic_y:   2020/2021
# Purpose:      (Master Degree) Digital Integrated Systems' Final Project
# Contacts:     s277972@studenti.polito.it
#               lombamari2@gmail.com

import random

not_msb = list("0123456789ABCDEF")
msb = list("0123CDEF")

data_set = 1000
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
			fileout.write(tmp + "\n")

