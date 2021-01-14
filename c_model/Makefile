CC=gcc
CFLAGS=-Wall -Wextra

help:
	echo "Compile fft source file"

fft: fft.c
	$(CC) -DBIT_LENGTH=$(bit_length) $(CFLAGS) fft.c -o fft

butteflyTest: butterfly.h butterfly.c butterflyTest.c
	$(CC) -DBIT_LENGTH=$(bit_length) $(CFLAGS) butterfly.c butterfly.h butterflyTest.c -o butterflyTest

debug: butterfly.h butterfly.c butterflyTest.c
	$(CC) -DBIT_LENGTH=$(bit_length) $(CFLAGS) -g butterfly.c butterfly.h butterflyTest.c -o butterflyTest
