CC=gcc
CFLAGS=-Wall -Wextra

help:
	echo "Compile fft source file"

fftTest: butterfly.h butterfly.c fft.h fft.c fftTest.c
	$(CC) -DBIT_LENGTH=$(bit_length) -DN_SAMPLES=$(n_samples) $(CFLAGS) -g butterfly.h butterfly.c fft.h fft.c fftTest.c -o fftTest

butteflyTest: butterfly.h butterfly.c butterflyTest.c
	$(CC) -DBIT_LENGTH=$(bit_length) $(CFLAGS) butterfly.c butterfly.h butterflyTest.c -o butterflyTest

debug: butterfly.h butterfly.c butterflyTest.c
	$(CC) -DBIT_LENGTH=$(bit_length) $(CFLAGS) -g butterfly.c butterfly.h butterflyTest.c -o butterflyTest

reverseTest: fft.h fft.c butterfly.h butterfly.c reverseTest.c 
	$(CC) -DBIT_LENGTH=$(bit_length) $(CFLAGS) fft.c fft.h butterfly.c butterfly.h reverseTest.c -o reverseTest
