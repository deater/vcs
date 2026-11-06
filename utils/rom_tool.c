/* Used to create 2k rom chunks for e7 mapper development */
/* Fills them with the rom number for debug purposes */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define FILL_NUMBER	0
#define FILL_STRING	1

static void print_help(char *name) {
	fprintf(stderr,"Usage:\t%s\n\n",name);
        fprintf(stderr,"\t-n number: fill with number pattern\n");
        fprintf(stderr,"\t-s size : size of ROM\n");
        fprintf(stderr,"\t-a string  : fill with string\n");
        exit(-1);
}

int main(int argc, char **argv) {

	int size=2048;
	int which_rom=0,i;
	unsigned char *rom;
	char *pattern=NULL;
	int fill_type=FILL_NUMBER;
	int c;

	/* Check command line arguments */
	while ((c = getopt (argc, argv,"ha:n:s:"))!=-1) {
		switch (c) {
		case 'a':
			pattern=strdup(optarg);
			fill_type=FILL_STRING;
			break;
		case 'n':
			which_rom=atoi(optarg);
			fill_type=FILL_NUMBER;
			break;
		case 's':
			size=atoi(optarg);
			break;
		case 'h':
			print_help(argv[0]);
			break;
		default:
			printf("Unknown option %c\n",c);
			return -1;
		}
	}

	rom=calloc(size,sizeof(unsigned char));
	if (rom==NULL) {
		fprintf(stderr,"Error allocating memory!\n");
		return -1;
	}

	/* clear to zero */
	memset(rom,0,size);

	if (fill_type==FILL_NUMBER) {
		for(i=0;i<size;i+=2) {
			rom[i]=(which_rom<<4)|(i>>8);
			rom[i+1]=i&0xff;
		}
	}

	if (fill_type==FILL_STRING) {
		for(i=0;i<size;i++) {
			rom[i]=pattern[i%strlen(pattern)];
		}
	}

	/* write to stdout */
	write(1,rom,size);

	return 0;
}
