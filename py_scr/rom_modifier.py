#! /env/python

import sys
import csv
import os
	
TRACKER_FILE = "rom_tracker"

OUT_FILENAME = "{}.vhd"

ROM_LINE = "\t\tWHEN {} => DATA <= {};\n"
i=0

with open(TRACKER_FILE, 'r') as tracker:
	for input_filename in tracker:	# loop for each filename contained inside the tracker file
		IN_FILENAME = "../src/" + input_filename.split('.')[-2].split('/')[-1] + ".vhd"
		with open(input_filename.rstrip('\n'),'r') as csv_file, open(IN_FILENAME,'r') as src_file, open("tmp",'w') as tmp_dest:
			ignore = False
			csv_buf = csv.reader(csv_file)
			for code_line in src_file:
				if "WHEN" in code_line:	# modify only the rom out assignment based on input address
					if "OTHERS" in code_line:	# except for the default case, this one needs to be kept
						tmp_dest.write(code_line)
					elif ignore == False:
						ignore = True	# now on, all the previous cases are obsolete
						for line_no, score in enumerate(csv_buf):	# score is a list, with a header useful for humans
							if line_no:
								tmp_dest.write( ROM_LINE.format( score[0], ' & '.join([ _ for _ in score[1:] if _ != '-']) )) # to support WHEN CASE_x => DATA <= cc & NEXT_ADDR & parity & ctrlwrd
				else:
					tmp_dest.write(code_line)
		os.rename("tmp",IN_FILENAME)		# finally point to the original source file
		i+=1
