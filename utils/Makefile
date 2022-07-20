CC = gcc
CFLAGS = -g -Wall -O2

all:	png2pf png2sprite

###

loadpng.o:	loadpng.c loadpng.h
	$(CC) $(CFLAGS) -c loadpng.c

###

png2pf:		png2pf.o loadpng.o
	$(CC) $(LFLAGS) -o png2pf png2pf.o loadpng.o -lpng

png2pf.o:		png2pf.c loadpng.h
	$(CC) $(CFLAGS) -c png2pf.c

###

png2sprite:		png2sprite.o loadpng.o
	$(CC) $(LFLAGS) -o png2sprite png2sprite.o loadpng.o -lpng

png2sprite.o:		png2sprite.c loadpng.h
	$(CC) $(CFLAGS) -c png2sprite.c


###

clean:		
		rm -f *~ *.o png2pf png2sprite


