#! /env/python

with open("default_input.hex","w") as fileout:
	for i in range(2**20):
		fileout.write(format(i,"05x") + "\n" )
