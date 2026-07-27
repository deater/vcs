#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char **argv) {

	int which_rom=0,i;
	unsigned char rom[2048];

	memset(rom,0,2048);

	if (argc>1) {
		which_rom=atoi(argv[1]);
	}

	for(i=0;i<2048;i+=2) {

		rom[i]=(which_rom<<4)|(i>>8);
		rom[i+1]=i&0xff;
	}

	/* write to stdout */
	write(1,rom,2048);


	return 0;
}
