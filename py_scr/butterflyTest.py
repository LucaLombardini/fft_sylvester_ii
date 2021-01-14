#! /env/python

import butterfly

data = []

with open("../c_model/sample.txt",'r') as filein, open("butterfly_out.txt",'w') as fileout:
    for line in filein:
        data += [int(line,16)]
        if len(data) == 6:
            out = butterfly.butterfly(data)
            for val in out:
                fileout.write(format(val,"0{}x".format(butterfly.nbit//4))+"\n")
