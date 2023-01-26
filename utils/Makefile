CC = gcc
CFLAGS = -g -Wall -O2

all:	png2pf png2overlay png2sprite png2compact

###

loadpng.o:	loadpng.c loadpng.h
	$(CC) $(CFLAGS) -c loadpng.c

###

png2pf:		png2pf.o loadpng.o
	$(CC) $(LFLAGS) -o png2pf png2pf.o loadpng.o -lpng

png2pf.o:		png2pf.c loadpng.h
	$(CC) $(CFLAGS) -c png2pf.c

###

png2compact:		png2compact.o loadpng.o
	$(CC) $(LFLAGS) -o png2compact png2compact.o loadpng.o -lpng

png2compact.o:		png2compact.c loadpng.h
	$(CC) $(CFLAGS) -c png2compact.c


###

png2overlay:		png2overlay.o loadpng.o
	$(CC) $(LFLAGS) -o png2overlay png2overlay.o loadpng.o -lpng

png2overlay.o:		png2overlay.c loadpng.h
	$(CC) $(CFLAGS) -c png2overlay.c

###

png2sprite:		png2sprite.o loadpng.o
	$(CC) $(LFLAGS) -o png2sprite png2sprite.o loadpng.o -lpng

png2sprite.o:		png2sprite.c loadpng.h
	$(CC) $(CFLAGS) -c png2sprite.c


###

clean:		
		rm -f *~ *.o png2pf png2overlay png2sprite png2compact


