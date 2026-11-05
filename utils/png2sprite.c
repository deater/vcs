/* Code for generating 48-pixel wide sprites on Atari 2600 */

#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "loadpng.h"


static void dump_sprite(FILE *outfile,char *name, int which,
	int start_line,int ysize, int *sprite, int flipped,
	int row_skip) {

	int row,i;

	fprintf(outfile,"\n%s%d:\n",name==NULL?"sprite":name,which);

	if (flipped) {

	for(row=ysize-1;row>=start_line;row-=row_skip) {
		fprintf(outfile,"\t.byte $%02X\t; ",sprite[row]);

		for(i=0;i<8;i++) {
			fprintf(outfile,"%c",(sprite[row]&(128>>i))?'*':'.');
		}
		fprintf(outfile,"\n");
	}

	}
	else {

	for(row=start_line;row<ysize;row+=row_skip) {
		fprintf(outfile,"\t.byte $%02X\t; ",sprite[row]);

		for(i=0;i<8;i++) {
			fprintf(outfile,"%c",(sprite[row]&(128>>i))?'*':'.');
		}
		fprintf(outfile,"\n");
	}

	}

}


/* from http://graphics.stanford.edu/~seander/bithacks.html */
//static unsigned char reverse_byte(unsigned char b) {
//	return (b * 0x0202020202ULL & 0x010884422010ULL) % 1023;
//}

static void print_help(char *name) {
	fprintf(stderr,"Usage:\t%s [-l lines] [-w width] INFILE OUTFILE\n\n",name);
	fprintf(stderr,"\t-f       : flip vertically\n");
	fprintf(stderr,"\t-n name  : name to prepend to label\n");
	fprintf(stderr,"\t-l line  : end line\n");
	fprintf(stderr,"\t-s line  : start line\n");
	fprintf(stderr,"\t-w width : width of pixels\n");
	fprintf(stderr,"\t-r num   : row skip\n");

	exit(-1);
}

/* Convert a 320x192 PNG to a 48x192 monochrome sprite */

int main(int argc, char **argv) {

	int row=0,max_lines=-1,pixel_width=1,start_line=0;
	int col=0,flipped=0,row_skip=0;
	int sprite0[192],sprite1[192],sprite2[192];
	int sprite3[192],sprite4[192],sprite5[192];
	int c,debug=0;

	char input_filename[BUFSIZ],output_filename[BUFSIZ];
	unsigned char *image;
	char *name=NULL;
	int xsize,ysize;
	FILE *outfile;


	/* Check command line arguments */
	while ((c = getopt (argc, argv,"248dfhn:l:s:w:r:v"))!=-1) {
		switch (c) {
		case 'd':
			fprintf(stderr,"DEBUG enabled\n");
			debug=1;
			break;
		case 'f':
			flipped=1;
			break;
		case 'h':
			print_help(argv[0]);
			break;
		case 'l':
			max_lines=atoi(optarg);
			break;
		case 'n':
			name=strdup(optarg);
			break;
		case 's':
			start_line=atoi(optarg);
			break;
		case 'w':
			pixel_width=atoi(optarg);
			break;
		case 'r':
			row_skip=atoi(optarg);
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

	if (loadpng(input_filename,&image,&xsize,&ysize,PNG_WHOLETHING,pixel_width)<0) {
		fprintf(stderr,"Error loading png!\n");
		exit(-1);
	}

	if (debug) fprintf(stderr,"Loaded image %d by %d\n",xsize,ysize);

	if (ysize>192) {
		fprintf(stderr,"Y too big!\n");
		return -1;
	}

	/* Yes I know this is inefficient */

	/* ======================================= */

	if ((max_lines>0) && (max_lines<ysize)) {
		ysize=max_lines;
	}


	fprintf(stderr,"Generating %d lines starting at %d, flipped=%d\n",
			ysize-start_line,start_line,flipped);

	/* ======================================= */



	/* generate sprite0 table */
	for(row=start_line;row<ysize;row++) {
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


	dump_sprite(outfile,name,0,start_line,ysize,sprite0,flipped,row_skip);
	dump_sprite(outfile,name,1,start_line,ysize,sprite1,flipped,row_skip);
	dump_sprite(outfile,name,2,start_line,ysize,sprite2,flipped,row_skip);
	dump_sprite(outfile,name,3,start_line,ysize,sprite3,flipped,row_skip);
	dump_sprite(outfile,name,4,start_line,ysize,sprite4,flipped,row_skip);
	dump_sprite(outfile,name,5,start_line,ysize,sprite5,flipped,row_skip);

	fclose(outfile);

	return 0;
}
