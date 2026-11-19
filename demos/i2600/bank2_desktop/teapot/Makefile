CC = gcc
CFLAGS = -O2 -Wall
LFLAGS = -lGL -lGLU -lglut

all:	teapot

###

teapot:	teapot.o
	$(CC) -o teapot teapot.o $(LFLAGS)

teapot.o:	teapot.c
	$(CC) $(CFLAGS) -c teapot.c

###

clean:	
	rm -f *~ *.o *.lst teapot

