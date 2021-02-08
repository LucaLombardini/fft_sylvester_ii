#! /env/python

# Author:       Luca Lombardini
# Academic_y:   2020/2021
# Purpose:      (Master Degree) Digital Integrated Systems' Final Project
# Contacts:     s277972@studenti.polito.it
#               lombamari2@gmail.com

import matplotlib.pyplot as plt
import numpy

offscale = 2**20
st_neg = 2**19
full_scale = 2**18 -1

IN_SAS = "../sim/fft_in_subset.hex"
OUT_SAS= "../sim/fft_out_subset.hex"
REF_SUB= "../sim/fft_out_subset_ref.hex"

inDataIm = []
outDataIm= []
refDataIm= []
inDataRe = []
outDataRe= []
refDataRe= []

def makePlot():
    global inDataIm 
    global outDataIm
    global refDataIm
    global inDataRe 
    global outDataRe
    global refDataRe
    time = numpy.arange(16)
    freq = numpy.fft.fftfreq(time.shape[-1])
    freq = numpy.sort(freq)

    # translate back to signed number
    inDataIm  =[int(_,16) - offscale if int(_,16) >= st_neg else int(_,16) for _ in inDataIm]
    outDataIm =[int(_,16) - offscale if int(_,16) >= st_neg else int(_,16) for _ in outDataIm]
    refDataIm =[int(_,16) - offscale if int(_,16) >= st_neg else int(_,16) for _ in refDataIm]
    inDataRe  =[int(_,16) - offscale if int(_,16) >= st_neg else int(_,16) for _ in inDataRe]
    outDataRe =[int(_,16) - offscale if int(_,16) >= st_neg else int(_,16) for _ in outDataRe]
    refDataRe =[int(_,16) - offscale if int(_,16) >= st_neg else int(_,16) for _ in refDataRe]

    # make graphs
    fig, (ax1, ax2, ax3, ax4) = plt.subplots(4)
    #fig.suptitle() set tag from list to be defined
    ax1.plot(time, numpy.divide(inDataRe, full_scale), time, numpy.divide(inDataIm,full_scale))
    ax1.set_title("Time domain input")
    ax2.plot(freq, numpy.divide(outDataRe[8:] + outDataRe[:8],full_scale), freq, numpy.divide(outDataIm[8:] + outDataIm[:8],full_scale))
    ax2.set_title("Frequency domain output")
    tmp = numpy.abs(numpy.subtract(outDataRe[8:] + outDataRe[:8], refDataRe[8:] + refDataRe[:8]))
    ax3.plot(freq, tmp)
    ax3.set_title("Frequency domain, real out error")
    tmp = numpy.abs(numpy.subtract(outDataIm[8:] + outDataIm[:8], refDataIm[8:] + refDataIm[:8]))
    ax4.plot(freq, tmp)
    ax4.set_title("Frequency domain, imag out error")
    plt.show()



with open(IN_SAS, "r") as inFile, open(OUT_SAS, "r") as outFile, open(REF_SUB, "r") as refFile:
    for lineNo, (lineIn, lineOut, lineRef) in enumerate(zip(inFile, outFile, refFile)):
        if lineNo % 2:
            inDataIm = [lineIn[i:i+5] for i in range(0, len(lineIn) -1, 5)]
            outDataIm= [lineOut[i:i+5] for i in range(0, len(lineOut) -1, 5)]
            refDataIm= [lineRef[i:i+5] for i in range(0, len(lineRef) -1, 5)]
            makePlot()
        else:
            inDataRe = [lineIn[i:i+5] for i in range(0, len(lineIn) -1, 5)]
            outDataRe= [lineOut[i:i+5] for i in range(0, len(lineOut) -1, 5)]
            refDataRe= [lineRef[i:i+5] for i in range(0, len(lineRef) -1, 5)]
