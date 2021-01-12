CC=gcc
CFLAGS=-Wall -Wextra

help:
	echo "Compile fft source file"

fft: fft.c
	$(CC) -DCOEFF_BITS=$(coeff_bits) $(CFLAGS) fft.c -o fft
	
