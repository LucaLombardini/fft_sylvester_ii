#! /env/python

# Author:       Luca Lombardini
# Academic_y:   2020/2021
# Purpose:      (Master Degree) Digital Integrated Systems' Final Project
# Contacts:     s277972@studenti.polito.it
#               lombamari2@gmail.com

import csv

dict_map = {}

#print("[ INFO ]: loading the control word mapping into memory")

REF_CTRL = "../project_files/ctrlwrds.csv"
FILE_TO_CHECK = "../sim/ctrl_wrd_out.bin"
with open(REF_CTRL, 'r') as ref_file:
	csv_buf = csv.reader(ref_file)
	for line_no, state_wrd in enumerate(csv_buf):
		if line_no:
			dict_map[''.join(state_wrd[1:])] = state_wrd[0]
			
#print("[ INFO ]: writing states")

with open(FILE_TO_CHECK, 'r') as chkfile:
	for line in chkfile:
		try:
			print(dict_map[line.rstrip("\n")])
		except KeyError:
			print("UNKNOWN_STATE")
