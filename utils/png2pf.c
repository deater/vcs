#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "loadpng.h"

/* from http://graphics.stanford.edu/~seander/bithacks.html */
static unsigned char reverse_byte(unsigned char b) {
	return (b * 0x0202020202ULL & 0x010884422010ULL) % 1023;
}

/* Convert a 320x192 PNG to a 40x192 playfield with one color per line */

int main(int argc, char **argv) {

	int row=0;
	int col=0;
	int color;
	int playfield_left[192],playfield_right[192];

	unsigned char *image;
	int xsize,ysize;
	FILE *outfile;

	if (argc<3) {
		fprintf(stderr,"Usage:\t%s INFILE OUTFILE\n\n",argv[0]);
		exit(-1);
	}

	outfile=fopen(argv[2],"w");
	if (outfile==NULL) {
		fprintf(stderr,"Error!  Could not open %s\n",argv[2]);
		exit(-1);
	}

	if (loadpng(argv[1],&image,&xsize,&ysize,PNG_WHOLETHING)<0) {
		fprintf(stderr,"Error loading png!\n");
		exit(-1);
	}

	fprintf(stderr,"Loaded image %d by %d\n",xsize,ysize);

	if (ysize>192) {
		fprintf(stderr,"Y too big!\n");
		return -1;
	}

	/* generate color table */
	fprintf(outfile,"colors:\n");
	for(row=0;row<ysize;row++) {
		color=0;
		for(col=0;col<xsize;col++) {
			if (image[row*xsize+col]!=0) color=image[row*xsize+col];
		}
		fprintf(outfile,"\t.byte $%02X\n",color);
	}

	/* generate left playfield table */
	for(row=0;row<ysize;row++) {
		playfield_left[row]=0;
		for(col=0;col<20;col++) {
			playfield_left[row]<<=1;
			if (image[row*xsize+col]!=0) playfield_left[row]|=1;
		}
	}

	fprintf(outfile,"\nplayfield0_left:\n");
	for(row=0;row<ysize;row++) {
		fprintf(outfile,"\t.byte $%02X\n",
			reverse_byte((playfield_left[row]>>16)&0xff));
	}

	fprintf(outfile,"\nplayfield1_left:\n");
	for(row=0;row<ysize;row++) {
		fprintf(outfile,"\t.byte $%02X\n",
			(playfield_left[row]>>8)&0xff);
	}

	fprintf(outfile,"\nplayfield2_left:\n");
	for(row=0;row<ysize;row++) {
		fprintf(outfile,"\t.byte $%02X\n",
			reverse_byte((playfield_left[row]>>0)&0xff));
	}


	/* generate right playfield table */
	for(row=0;row<ysize;row++) {
		playfield_right[row]=0;
		for(col=0;col<20;col++) {
			playfield_right[row]<<=1;
			if (image[row*xsize+col+20]!=0) playfield_right[row]|=1;
		}
	}

	fprintf(outfile,"\nplayfield0_right:\n");
	for(row=0;row<ysize;row++) {
		fprintf(outfile,"\t.byte $%02X\n",
			reverse_byte((playfield_right[row]>>16)&0xff));
	}

	fprintf(outfile,"\nplayfield1_right:\n");
	for(row=0;row<ysize;row++) {
		fprintf(outfile,"\t.byte $%02X\n",
			(playfield_right[row]>>8)&0xff);
	}

	fprintf(outfile,"\nplayfield2_right:\n");
	for(row=0;row<ysize;row++) {
		fprintf(outfile,"\t.byte $%02X\n",
			reverse_byte((playfield_right[row]>>0)&0xff));
	}






	fclose(outfile);

	return 0;
}
