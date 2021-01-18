#! /env/python

import sys
import csv

HEADER="""LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE work.definespack.all;

PACKAGE cupack IS
"""

BASE='\tCONSTANT {}\t: std_logic_vector({}-1 DOWNTO 0)\t:= "{}";\n'

BASE_K = '\tCONSTANT {}\t: positive\t:= "{}";\n'

FOOTER="END cupack;"

FILENAME = "cu_tracker"

FILEOUT = "../src/cupack.vhd"

bit_len_map = {4:"base_addr", 5:"lsb_addr", 6:"cc_lsb_addr", 23:"command_len"}

with open(FILEOUT, 'w') as f_out, open(FILENAME,'r') as tracker:	# file which will contain the defines and the one containing the filenames of the file containing the mappings
	f_out.write(HEADER)
	for key, value in bit_len_map.items():	# add integer constants
				f_out.write(BASE_K.format(value, key))
	for input_filename in tracker:				# for every file in the tracker read the map composed of tag and bits, and assign them into the package
		with open(input_filename.rstrip('\n'), 'r') as filein:
			csvbuf = csv.reader(filein)
			for line_no, line_list in enumerate(csvbuf):
				if line_no:	# the first line is just a header with info for humans
					tag = line_list[0]
					bit_string = ''.join( [ _ for _ in line_list[1:] if _ != '-' ] )	# do not pick - in the bitstring
					f_out.write(BASE.format(tag, bit_len_map[len(bit_string)], bit_string))		# add a label definition
		
	f_out.write(FOOTER)
