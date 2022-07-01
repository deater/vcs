
CFLAGS = -g -Wall -O2

all:	png2pf

###

loadpng.o:	loadpng.c loadpng.h
	$(CC) $(CFLAGS) -c loadpng.c

###

png2pf:		png2pf.o loadpng.o
	$(CC) $(LFLAGS) -o png2pf png2pf.o loadpng.o -lpng

png2pf.o:		png2pf.c loadpng.h
	$(CC) $(CFLAGS) -c png2pf.c


###

clean:		
		rm -f *~ *.o png2pf


