#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "loadpng.h"

/* from http://graphics.stanford.edu/~seander/bithacks.html */
//static unsigned char reverse_byte(unsigned char b) {
//	return (b * 0x0202020202ULL & 0x010884422010ULL) % 1023;
//}

static void print_help(char *name) {
	fprintf(stderr,"Usage:\t%s INFILE OUTFILE\n\n",name);
	exit(-1);
}

/* Convert a 320x192 PNG to a 40x192 playfield with one color per line */

int main(int argc, char **argv) {

	int row=0;
	int col=0;
	int sprite0[192],sprite1[192],sprite2[192];
	int sprite3[192],sprite4[192],sprite5[192];
	int c,debug=0;

	char input_filename[BUFSIZ],output_filename[BUFSIZ];
	unsigned char *image;
	int xsize,ysize;
	FILE *outfile;


	/* Check command line arguments */
	while ((c = getopt (argc, argv,"248dhv"))!=-1) {
		switch (c) {
		case 'd':
			fprintf(stderr,"DEBUG enabled\n");
			debug=1;
			break;
		case 'h':
			print_help(argv[0]);
			break;
		case 'v':
			print_help(argv[0]);
			break;
		}
	}

	if (optind==argc) {
		fprintf(stderr,"ERROR!  Must specify input file\n\n");
		return -1;
	}
	/* get argument 1, which is image name */
        strncpy(input_filename,argv[optind],BUFSIZ-1);

	/* Move to next argument */
	optind++;

	if (optind==argc) {
		fprintf(stderr,"ERROR!  Must specify output file!\n\n");
		return -1;
	}

	/* Grab output filename */
	strncpy(output_filename,argv[optind],BUFSIZ-1);


	outfile=fopen(output_filename,"w");
	if (outfile==NULL) {
		fprintf(stderr,"Error!  Could not open %s\n",output_filename);
		exit(-1);
	}

	if (loadpng(input_filename,&image,&xsize,&ysize,PNG_WHOLETHING,2)<0) {
		fprintf(stderr,"Error loading png!\n");
		exit(-1);
	}

	if (debug) fprintf(stderr,"Loaded image %d by %d\n",xsize,ysize);

	if (ysize>192) {
		fprintf(stderr,"Y too big!\n");
		return -1;
	}

	/* Yes I know this is inefficient */

	/* generate sprite0 table */
	for(row=0;row<ysize;row++) {
		sprite0[row]=0;
		sprite1[row]=0;
		sprite2[row]=0;
		sprite3[row]=0;
		sprite4[row]=0;
		sprite5[row]=0;
		for(col=0;col<8;col++) {
			sprite0[row]<<=1;
			sprite1[row]<<=1;
			sprite2[row]<<=1;
			sprite3[row]<<=1;
			sprite4[row]<<=1;
			sprite5[row]<<=1;
			if (image[row*xsize+(col+0)]!=0) sprite0[row]|=1;
			if (image[row*xsize+(col+8)]!=0) sprite1[row]|=1;
			if (image[row*xsize+(col+16)]!=0) sprite2[row]|=1;
			if (image[row*xsize+(col+24)]!=0) sprite3[row]|=1;
			if (image[row*xsize+(col+32)]!=0) sprite4[row]|=1;
			if (image[row*xsize+(col+40)]!=0) sprite5[row]|=1;
		}
	}


	fprintf(outfile,"\nsprite0:\n");
	for(row=ysize-1;row>=0;row--) {
		fprintf(outfile,"\t.byte $%02X\n",sprite0[row]);
	}

	fprintf(outfile,"\nsprite1:\n");
	for(row=ysize-1;row>=0;row--) {
		fprintf(outfile,"\t.byte $%02X\n",sprite1[row]);
	}

	fprintf(outfile,"\nsprite2:\n");
	for(row=ysize-1;row>=0;row--) {
		fprintf(outfile,"\t.byte $%02X\n",sprite2[row]);
	}

	fprintf(outfile,"\nsprite3:\n");
	for(row=ysize-1;row>=0;row--) {
		fprintf(outfile,"\t.byte $%02X\n",sprite3[row]);
	}

	fprintf(outfile,"\nsprite4:\n");
	for(row=ysize-1;row>=0;row--) {
		fprintf(outfile,"\t.byte $%02X\n",sprite4[row]);
	}

	fprintf(outfile,"\nsprite5:\n");
	for(row=ysize-1;row>=0;row--) {
		fprintf(outfile,"\t.byte $%02X\n",sprite5[row]);
	}

	fclose(outfile);

	return 0;
}
