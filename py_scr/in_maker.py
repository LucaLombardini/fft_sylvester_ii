#! /env/python

# Author:       Luca Lombardini
# Academic_y:   2020/2021
# Purpose:      (Master Degree) Digital Integrated Systems' Final Project
# Contacts:     s277972@studenti.polito.it
#               lombamari2@gmail.com

#import math
import numpy

full_scale = 2**18 -1
offscale = 2**20

###############################################################################
#   Functions to be used to create test vectors

def first_ord_lpf(fs, in_vect, k, b):
    unistep = [True if _ >= b else False for _ in in_vect]
    tmp = numpy.multiply(numpy.exp(numpy.subtract(b, in_vect)),unistep)
    scale = fs / max(tmp)
    return numpy.multiply((fs*k), tmp)

def diracs_delta(fs, in_vect, k, b):
    return [ (fs * k) if _ == b else 0 for _ in in_vect]

def constant(fs, in_vect, k, b):
    return [(fs * k) for _ in in_vect]

def step(fs, in_vect, k, b):
    unistep = [True if _ >= b else False for _ in in_vect]
    return [(fs * k) * _ for _ in unistep]

def cosine(fs, in_vect, k, b): # cosine with time shift and dummy phase
    w = (2 * numpy.pi / 16)*3
    arg = numpy.subtract(numpy.multiply(w,numpy.subtract(in_vect,b)),(0.05*b))
    return numpy.multiply((fs*k),numpy.cos(arg))

def door(fs, in_vect, k, b):
    window = [ True if _ >= (b-(b/2)) and _ < (b+(b/2)) else False for _ in in_vect]
    return numpy.multiply((fs*k), window)

def sinc_f(fs, in_vect, k, b):
    val = numpy.divide(numpy.subtract(in_vect,b),0.6)
    tmp = numpy.sinc(val)
    scale = fs/max(tmp)
    return numpy.multiply(scale, tmp)

funcs = [first_ord_lpf, diracs_delta, constant, step, cosine, door, sinc_f]
###############################################################################
#   Test vector creation

samples = list(range(0,16))

with open("../sim/fft_in_vectors.hex", "w") as filein, open("../sim/fft_out_reference.hex","w") as fileref:
    for f in funcs:
        for k in numpy.arange(0.2,1.2,0.2):
            for b in samples:
                to_print = [round(_) for _ in f(full_scale, samples, k, b)]
                for num in numpy.real(to_print):
                    buf = offscale + num if num < 0 else num
                    filein.write(format(buf,"05X"))
                filein.write("\n")
                for num in numpy.imag(to_print):
                    buf = offscale + num if num < 0 else num
                    filein.write(format(buf,"05X"))
                filein.write("\n")
                # do an fft just to have imag part as input
                to_print = numpy.rint(numpy.divide(numpy.fft.fft(to_print),16))
                for num in numpy.real(to_print):
                    buf = offscale + num if num < 0 else num
                    filein.write(format(round(buf),"05X"))
                    fileref.write(format(round(buf),"05X"))
                filein.write("\n")
                fileref.write("\n")
                for num in numpy.imag(to_print):
                    buf = offscale + num if num < 0 else num
                    filein.write(format(round(buf),"05X"))
                    fileref.write(format(round(buf),"05X"))
                filein.write("\n")
                fileref.write("\n")
                to_print = numpy.rint(numpy.divide(numpy.fft.fft(to_print),16))
                for num in numpy.real(to_print):
                    buf = offscale + num if num < 0 else num
                    fileref.write(format(round(buf),"05X"))
                fileref.write("\n")
                for num in numpy.imag(to_print):
                    buf = offscale + num if num < 0 else num
                    fileref.write(format(round(buf),"05X"))
                fileref.write("\n")
                

with open("../sim/fft_in_subset.hex", "w") as filein, open("../sim/fft_out_subset_ref.hex","w") as fileref:
    for f in funcs:
        for b in (0, 8):
            # exp decr. max ampl.
            to_print = [round(_) for _ in f(full_scale, samples, 1, b)]
            for num in numpy.real(to_print):
                buf = offscale + num if num < 0 else num
                filein.write(format(buf,"05X"))
            filein.write("\n")
            for num in numpy.imag(to_print):
                buf = offscale + num if num < 0 else num
                filein.write(format(buf,"05X"))
            filein.write("\n")
            # do an fft just to have imag part as input
            to_print = numpy.rint(numpy.divide(numpy.fft.fft(to_print),16))
            for num in numpy.real(to_print):
                buf = offscale + num if num < 0 else num
                filein.write(format(round(buf),"05X"))
                fileref.write(format(round(buf),"05X"))
            filein.write("\n")
            fileref.write("\n")
            for num in numpy.imag(to_print):
                buf = offscale + num if num < 0 else num
                filein.write(format(round(buf),"05X"))
                fileref.write(format(round(buf),"05X"))
            filein.write("\n")
            fileref.write("\n")
            to_print = numpy.rint(numpy.divide(numpy.fft.fft(to_print),16))
            for num in numpy.real(to_print):
                buf = offscale + num if num < 0 else num
                fileref.write(format(round(buf),"05X"))
            fileref.write("\n")
            for num in numpy.imag(to_print):
                buf = offscale + num if num < 0 else num
                fileref.write(format(round(buf),"05X"))
            fileref.write("\n")
