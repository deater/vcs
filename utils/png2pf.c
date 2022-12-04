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
	fprintf(stderr,"Usage:\t%s [-2] [-4] [-8] [-b col] [-n name] INFILE OUTFILE\n\n",name);
	fprintf(stderr,"\t-g : generate background color data\n");
	fprintf(stderr,"\t-2 : only draw every 2nd line\n");
	fprintf(stderr,"\t-4 : only draw every 4th line\n");
	fprintf(stderr,"\t-8 : only draw every 8th line\n");
	fprintf(stderr,"\t-n : name to prepend to labels\n");
	fprintf(stderr,"\t-b : color to use for background (default 0)\n");
	fprintf(stderr,"\t-p : use PAL palette\n");
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
	int color=0,value,background_color=0;
	int playfield_left[192],playfield_right[192],background[192];
	int c,debug=0;
	int generate_bg=0;
	int is_pal=0,custom_ysize=0;

	char input_filename[BUFSIZ],output_filename[BUFSIZ];
	char *name=NULL;
	unsigned char *image;
	int xsize,ysize;
	FILE *outfile;


	/* Check command line arguments */
	while ((c = getopt (argc, argv,"248b:gdhvn:py:"))!=-1) {
		switch (c) {
		case 'n':
			name=strdup(optarg);
			break;
		case 'b':
			background_color=strtod(optarg,NULL);
			break;
		case 'y':
			custom_ysize=strtod(optarg,NULL);
			break;
		case 'g':
			generate_bg=1;
			break;
		case 'p':
			is_pal=1;
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

	if (custom_ysize) ysize=custom_ysize;

	for(row=0;row<ysize;row++) background[row]=background_color;

	/* generate background color table */
	if (generate_bg) {
		if (name) {
			fprintf(outfile,"%s_bg_colors:\n",name);
		}
		else {
			fprintf(outfile,"bg_colors:\n");
		}
		for(row=0;row<ysize;row+=skip) {
			background[row]=image[row*xsize];
			//fprintf(outfile,"\t.byte $%02X\n",
			//background[row]);
			if (is_pal) color=background[row]+16;
			else color=background[row];

			print_byte(outfile,color,row/skip);
		}
		fprintf(outfile,"\n");
	}


	/* generate color table */
	if (name) {
		fprintf(outfile,"%s_colors:\n",name);
	}
	else {
		fprintf(outfile,"colors:\n");
	}
	for(row=0;row<ysize;row+=skip) {
		color=0;
		for(col=0;col<xsize;col++) {
			if (image[row*xsize+col]!=background[row]) color=image[row*xsize+col];
		}
		if (is_pal) color=color+16;
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
		fprintf(outfile,"\n%s_playfield0_left:\n",name);
	} else {
		fprintf(outfile,"\nplayfield0_left:\n");
	}
	for(row=0;row<ysize;row+=skip) {
		value=reverse_byte((playfield_left[row]>>16)&0xff);
		print_byte(outfile,value,row/skip);
	}

	if (name) {
		fprintf(outfile,"\n%s_playfield1_left:\n",name);
	} else {
		fprintf(outfile,"\nplayfield1_left:\n");
	}
	for(row=0;row<ysize;row+=skip) {
		value=(playfield_left[row]>>8)&0xff;
		print_byte(outfile,value,row/skip);
	}

	if (name) {
		fprintf(outfile,"\n%s_playfield2_left:\n",name);
	} else {
		fprintf(outfile,"\nplayfield2_left:\n");
	}
	for(row=0;row<ysize;row+=skip) {
		value=reverse_byte((playfield_left[row]>>0)&0xff);
		print_byte(outfile,value,row/skip);
	}


	/* generate right playfield table */
	for(row=0;row<ysize;row++) {
		playfield_right[row]=0;
		for(col=0;col<20;col++) {
			playfield_right[row]<<=1;
			if (image[row*xsize+col+20]!=background[row]) playfield_right[row]|=1;
		}
//		fprintf(outfile,"row=%d bg=%x %x\n",row,background[row],playfield_right[row]);
	}

	if (name) {
		fprintf(outfile,"\n%s_playfield0_right:\n",name);
	} else {
		fprintf(outfile,"\nplayfield0_right:\n");
	}
	for(row=0;row<ysize;row+=skip) {
		value=reverse_byte((playfield_right[row]>>16)&0xff);
		print_byte(outfile,value,row/skip);
	}

	fprintf(outfile,"\n.align $100\n");

	if (name) {
		fprintf(outfile,"\n%s_playfield1_right:\n",name);
	} else {
		fprintf(outfile,"\nplayfield1_right:\n");
	}
	for(row=0;row<ysize;row+=skip) {
		value=(playfield_right[row]>>8)&0xff;
		print_byte(outfile,value,row/skip);
	}


	if (name) {
		fprintf(outfile,"\n%s_playfield2_right:\n",name);
	} else {
		fprintf(outfile,"\nplayfield2_right:\n");
	}
	for(row=0;row<ysize;row+=skip) {
		value=reverse_byte((playfield_right[row]>>0)&0xff);
		print_byte(outfile,value,row/skip);
	}

	fclose(outfile);

	return 0;
}
