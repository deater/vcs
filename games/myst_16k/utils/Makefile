CFLAGS = -Wall -O2 -g
LFLAGS =
CC = gcc

all:	calc_address

###

calc_address:	calc_address.o
	$(CC) -o calc_address calc_address.o $(LFLAGS)

calc_address.o:	calc_address.c
	$(CC) $(CFLAGS) -c calc_address.c

###

clean:	
	rm -f *~ *.o calc_address

