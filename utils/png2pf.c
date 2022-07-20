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

static void print_help(char *name) {
	fprintf(stderr,"Usage:\t%s [-2] [-4] [-8] INFILE OUTFILE\n\n",name);
	fprintf(stderr,"\t-2 : only draw every 2nd line\n");
	fprintf(stderr,"\t-4 : only draw every 4th line\n");
	fprintf(stderr,"\t-8 : only draw every 8th line\n");
	exit(-1);
}

/* Convert a 320x192 PNG to a 40x192 playfield with one color per line */

int main(int argc, char **argv) {

	int row=0;
	int col=0;
	int skip=1;
	int color;
	int playfield_left[192],playfield_right[192],background[192];
	int c,debug=0;
	int generate_bg=0;

	char input_filename[BUFSIZ],output_filename[BUFSIZ];
	unsigned char *image;
	int xsize,ysize;
	FILE *outfile;


	/* Check command line arguments */
	while ((c = getopt (argc, argv,"248bdhv"))!=-1) {
		switch (c) {
		case 'b':
			generate_bg=1;
			break;
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
		case '2':
			skip=2;
			break;
		case '4':
			skip=4;
			break;
		case '8':
			skip=8;
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

	if (loadpng(input_filename,&image,&xsize,&ysize,PNG_WHOLETHING,8)<0) {
		fprintf(stderr,"Error loading png!\n");
		exit(-1);
	}

	if (debug) fprintf(stderr,"Skip = %d\n",skip);
	fprintf(stderr,"Loaded image %d by %d\n",xsize,ysize);

	if (ysize>192) {
		fprintf(stderr,"Y too big!\n");
		return -1;
	}

	for(row=0;row<ysize;row++) background[row]=0;

	/* generate background color table */
	if (generate_bg) {
		fprintf(outfile,"bg_colors:\n");
		for(row=0;row<ysize;row+=skip) {
			background[row]=image[row*xsize];
			fprintf(outfile,"\t.byte $%02X\n",background[row]);
		}
	}


	/* generate color table */
	fprintf(outfile,"colors:\n");
	for(row=0;row<ysize;row+=skip) {
		color=0;
		for(col=0;col<xsize;col++) {
			if (image[row*xsize+col]!=background[row]) color=image[row*xsize+col];
		}
		fprintf(outfile,"\t.byte $%02X\n",color);
	}

	/* generate left playfield table */
	for(row=0;row<ysize;row++) {
		playfield_left[row]=0;
		for(col=0;col<20;col++) {
			playfield_left[row]<<=1;
			if (image[row*xsize+col]!=background[row]) playfield_left[row]|=1;
		}
	}

	fprintf(outfile,"\nplayfield0_left:\n");
	for(row=0;row<ysize;row+=skip) {
		fprintf(outfile,"\t.byte $%02X\n",
			reverse_byte((playfield_left[row]>>16)&0xff));
	}

	fprintf(outfile,"\nplayfield1_left:\n");
	for(row=0;row<ysize;row+=skip) {
		fprintf(outfile,"\t.byte $%02X\n",
			(playfield_left[row]>>8)&0xff);
	}

	fprintf(outfile,"\nplayfield2_left:\n");
	for(row=0;row<ysize;row+=skip) {
		fprintf(outfile,"\t.byte $%02X\n",
			reverse_byte((playfield_left[row]>>0)&0xff));
	}


	/* generate right playfield table */
	for(row=0;row<ysize;row++) {
		playfield_right[row]=0;
		for(col=0;col<20;col++) {
			playfield_right[row]<<=1;
			if (image[row*xsize+col+20]!=background[row]) playfield_right[row]|=1;
		}
	}

	fprintf(outfile,"\nplayfield0_right:\n");
	for(row=0;row<ysize;row+=skip) {
		fprintf(outfile,"\t.byte $%02X\n",
			reverse_byte((playfield_right[row]>>16)&0xff));
	}

	fprintf(outfile,"\nplayfield1_right:\n");
	for(row=0;row<ysize;row+=skip) {
		fprintf(outfile,"\t.byte $%02X\n",
			(playfield_right[row]>>8)&0xff);
	}

	fprintf(outfile,"\nplayfield2_right:\n");
	for(row=0;row<ysize;row+=skip) {
		fprintf(outfile,"\t.byte $%02X\n",
			reverse_byte((playfield_right[row]>>0)&0xff));
	}

	fclose(outfile);

	return 0;
}
