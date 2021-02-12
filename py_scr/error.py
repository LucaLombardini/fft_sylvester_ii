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

OUT_SAS= "../sim/fft_out_vectors.hex"
REF_SUB= "../sim/fft_out_reference.hex"

outDataIm= []
refDataIm= []
outDataRe= []
refDataRe= []
sumErroRe= [0 for _ in range(16)]
sumErroIm= [0 for _ in range(16)]

def updError(): 
    global outDataIm
    global refDataIm
    global outDataRe
    global refDataRe
    global sumErroRe
    global sumErroIm
    # translate back to signed number
    outDataIm =[int(_,16) - offscale if int(_,16) >= st_neg else int(_,16) for _ in outDataIm]
    refDataIm =[int(_,16) - offscale if int(_,16) >= st_neg else int(_,16) for _ in refDataIm]
    outDataRe =[int(_,16) - offscale if int(_,16) >= st_neg else int(_,16) for _ in outDataRe]
    refDataRe =[int(_,16) - offscale if int(_,16) >= st_neg else int(_,16) for _ in refDataRe]
    # update error
    sumErroRe = numpy.add(sumErroRe, numpy.abs(numpy.subtract(outDataRe[8:] + outDataRe[:8], refDataRe[8:] + refDataRe[:8])))
    sumErroIm = numpy.add(sumErroIm, numpy.abs(numpy.subtract(outDataIm[8:] + outDataIm[:8], refDataIm[8:] + refDataIm[:8])))

def makePlot():
    global simulations
    global sumErroRe
    global sumErroIm
    time = numpy.arange(16)
    freq = numpy.fft.fftfreq(time.shape[-1])
    freq = numpy.sort(freq)
    tmp = [1 for _ in range(16)]
    # make graphs
    fig, (ax1, ax2) = plt.subplots(2)
    #fig.suptitle() set tag from list to be defined
    ax1.plot(freq, numpy.divide(sumErroRe, simulations), freq, tmp)
    ax1.set_title("Frequency domain, real out average error")
    ax2.plot(freq, numpy.divide(sumErroIm, simulations), freq, tmp)
    ax2.set_title("Frequency domain, imag out average error")
    plt.show()


simulations = 0

with open(OUT_SAS, "r") as outFile, open(REF_SUB, "r") as refFile:
    for lineNo, (lineOut, lineRef) in enumerate(zip(outFile, refFile)):
        if lineNo % 2:
            outDataIm= [lineOut[i:i+5] for i in range(0, len(lineOut) -1, 5)]
            refDataIm= [lineRef[i:i+5] for i in range(0, len(lineRef) -1, 5)]
            updError()
        else:
            outDataRe= [lineOut[i:i+5] for i in range(0, len(lineOut) -1, 5)]
            refDataRe= [lineRef[i:i+5] for i in range(0, len(lineRef) -1, 5)]
            simulations += 1

makePlot()
