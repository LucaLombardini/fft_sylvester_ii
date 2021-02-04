#! /env/python

import matplotlib.pyplot as plt
import numpy

offscale = 2**20
st_neg = 2**19
full_scale = 2**18 -1

#in_dbg_re = ["0CCCD", "04B57", "01BB7", "00A32", "003C0", "00161", "00082", "00030", "00012", "00006", "00002", "00001", "00000", "00000", "00000", "00000"]
#in_dbg_im = ["00000", "00000", "00000", "00000", "00000", "00000", "00000","00000", "00000", "00000", "00000", "00000", "00000", "00000", "00000", "00000"]
#out_dbg_re = ["0143E", "0128C", "00F66", "00CE2", "00B46", "00A4E", "009BE", "00973", "0095C", "00973", "009BE", "00A4E", "00B46", "00CE2", "00F66", "0128C"]
#out_dbg_im = ["00000", "FFC0B", "FFA96", "FFAE7", "FFBDA", "FFCEE", "FFDFD", "FFF02", "00000", "000FE", "00203", "00312", "00426", "00519", "0056A", "003F5"]

IN_SAS = "../sim/fft_in_subset.hex"
OUT_SAS= "../sim/fft_out_subseti.hex"
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
    ax3.plot(freq, numpy.divide(outDataRe[8:] + outDataRe[:8],full_scale), freq, numpy.divide(refDataRe[8:] + refDataRe[:8],full_scale))
    ax3.set_title("Frequency domain, real out w.r.t ideal out")
    ax4.plot(freq, numpy.divide(outDataIm[8:] + outDataIm[:8],full_scale), freq, numpy.divide(refDataIm[8:] + refDataIm[:8],full_scale))
    ax4.set_title("Frequency domain, imag out w.r.t ideal out")
    plt.show()



with open(IN_SAS, "r") as inFile, open(OUT_SAS, "r") as outFile, open(REF_SUB, "w") as refFile:
    for lineNo, (lineIn, lineOut, lineRef) in enumerate(zip(inFile, outFile, refFile)):
        if lineNo % 2:
            inDataIm = [lineIn[i:i+n] for i in range(0, len(lineIn), 5)]
            outDataIm= [lineOut[i:i+n] for i in range(0, len(lineOut), 5)]
            refDataIm= [lineRef[i:i+n] for i in range(0, len(lineRef), 5)]

        else:
            inDataRe = [lineIn[i:i+n] for i in range(0, len(lineIn), 5)]
            outDataRe= [lineOut[i:i+n] for i in range(0, len(lineOut), 5)]
            refDataRe= [lineRef[i:i+n] for i in range(0, len(lineRef), 5)]


#in_dbg_re = [int(_,16) - offscale if int(_,16) >= st_neg else int(_,16) for _ in in_dbg_re]
#in_dbg_im = [int(_,16) - offscale if int(_,16) >= st_neg else int(_, 16) for _ in in_dbg_im]
#out_dbg_re = [int(_,16) - offscale if int(_,16) >= st_neg else int(_, 16) for _ in out_dbg_re]
#out_dbg_im = [int(_,16) - offscale if int(_,16) >= st_neg else int(_, 16) for _ in out_dbg_im]

#time = numpy.arange(16)
#freq = numpy.fft.fftfreq(time.shape[-1])
#freq = numpy.sort(freq)

#plt.plot(time, in_dbg_re, time, in_dbg_im)
#plt.show()

fig, (ax1, ax2) = plt.subplots(2)
fig.suptitle("Exp decrescente")
ax1.plot(time, numpy.divide(in_dbg_re, full_scale), time, numpy.divide(in_dbg_im,full_scale))
ax2.plot(freq, numpy.divide(out_dbg_re[8:] + out_dbg_re[:8],full_scale), freq, numpy.divide(out_dbg_im[8:] + out_dbg_im[:8],full_scale))
plt.show()
