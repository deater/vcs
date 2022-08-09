/* Use to create a sprite1 overlay for adding more colors to a scene */
/* This is used most notably for generating graphics for 2600 Myst */

/* It takes a 320x192 image.  The assumption is the source has the */
/* graphics you want offset by 32 pixels so it's effectively where */
/* The left playfield 1 would be */

/* This probably could have been implemented as part of png2pf */
/* but that would have involved a lot of conditional code */

#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "loadpng.h"

static void print_help(char *name) {
	fprintf(stderr,"Usage:\t%s [-2] [-4] [-8] [-b col] [-n name] INFILE OUTFILE\n\n",name);
	fprintf(stderr,"\t-g : generate background color data\n");
	fprintf(stderr,"\t-2 : only draw every 2nd line\n");
	fprintf(stderr,"\t-4 : only draw every 4th line\n");
	fprintf(stderr,"\t-8 : only draw every 8th line\n");
	fprintf(stderr,"\t-n : name to prepend to labels\n");
	fprintf(stderr,"\t-b : color to use for background (default 0)\n");
	exit(-1);
}


static void print_byte(FILE *outfile,int value,int which) {

	if (((which)%8)==0) {
		fprintf(outfile,"\t.byte $%02X",value);
	}
	else {
		fprintf(outfile,",$%02X",value);
	}
	if (((which)%8)==7) {
		fprintf(outfile,"\n");
	}
}


/* Convert a 320x192 PNG to a 40x192 playfield with one color per line */

int main(int argc, char **argv) {

	int row=0;
	int col=0;
	int skip=1;
	int color,value,background_color=0;
	int playfield_left[192],background[192];
	int c,debug=0;
	int generate_bg=0;

	char input_filename[BUFSIZ],output_filename[BUFSIZ];
	char *name=NULL;
	unsigned char *image;
	int xsize,ysize;
	FILE *outfile;


	/* Check command line arguments */
	while ((c = getopt (argc, argv,"248b:gdhvn:"))!=-1) {
		switch (c) {
		case 'n':
			name=strdup(optarg);
			break;
		case 'b':
			background_color=strtod(optarg,NULL);
			break;
		case 'g':
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

	if (argv[optind][0]=='-') {
		outfile=stdout;
	}
	else {

		/* Grab output filename */
		strncpy(output_filename,argv[optind],BUFSIZ-1);


		outfile=fopen(output_filename,"w");
		if (outfile==NULL) {
			fprintf(stderr,"Error!  Could not open %s\n",output_filename);
			exit(-1);
		}
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

	fprintf(outfile,"; Using background color $%02X\n",background_color);

	for(row=0;row<ysize;row++) background[row]=background_color;

	/* generate background color table */
	if (generate_bg) {
		fprintf(outfile,"bg_colors:\n");
		for(row=0;row<ysize;row+=skip) {
			background[row]=image[row*xsize];
			fprintf(outfile,"\t.byte $%02X\n",background[row]);
		}
	}


	/* generate color table */
	if (name) {
		fprintf(outfile,"%s_overlay_colors:\n",name);
	}
	else {
		fprintf(outfile,"overlay_colors:\n");
	}

	color=0;
	for(row=0;row<ysize;row+=skip) {
		/* keep last line color if no active pixels on line */
		/* hopefully this compresses better? */
		for(col=0;col<xsize;col++) {
			if (image[row*xsize+col]!=background[row]) color=image[row*xsize+col];
		}
		print_byte(outfile,color,row/skip);
	}
	fprintf(outfile,"\n");

	/* generate left playfield table */
	for(row=0;row<ysize;row++) {
		playfield_left[row]=0;
		for(col=0;col<20;col++) {
			playfield_left[row]<<=1;
			if (image[row*xsize+col]!=background[row]) playfield_left[row]|=1;
		}
	}

	if (name) {
		fprintf(outfile,"\n%s_overlay_sprite:\n",name);
	} else {
		fprintf(outfile,"\noverlay_sprite:\n");
	}
	for(row=0;row<ysize;row+=skip) {
		value=(playfield_left[row]>>8)&0xff;
		print_byte(outfile,value,row/skip);
	}

	fclose(outfile);

	return 0;
}
