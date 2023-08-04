all:	zero2.bin

zero2.bin:	empty.txt
	cp empty.txt zero2.bin
	truncate -s 512 zero2.bin

clean:	
	rm -f zero2.bin *~
