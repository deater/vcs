/* Loads a 320x192 PNG and converts to a 40x192 array */
/* With Atari 2600 colors */

#include <stdio.h>
#include <stdlib.h>

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include <png.h>
#include "loadpng.h"


/* FIXME: do proper ATARI NTSC decoder */
static int convert_color(int color, char *filename) {

	int c=0;

	switch(color) {
		case 0x000000:	c=0; break;	/* black */
		case 0xe31e60:	c=1; break;	/* magenta */
		case 0x604ebd:	c=2; break;	/* dark blue */
		case 0xff44fd:	c=3; break;	/* purple */
		case 0x00a360:	c=4; break;	/* dark green */
		case 0x9c9c9c:	c=5; break;	/* grey 1 */
		case 0x14cffd:	c=6; break;	/* medium blue */
		case 0xd0c3ff:	c=7; break;	/* light blue */
		case 0x607203:	c=8; break;	/* brown */
		case 0xff6a3c:	c=9; break;	/* orange */
		case 0x9d9d9d:	c=10; break;	/* grey 2 */
		case 0xffa0d0:	c=11; break;	/* pink */
		case 0x14f53c:	c=12; break;	/* bright green */
		case 0xd0dd8d:	c=13; break;	/* yellow */
		case 0x72ffd0:	c=14; break;	/* aqua */
		case 0xffffff:	c=15; break;	/* white */
		default:
			fprintf(stderr,"Unknown color %x, file %s\n",
				color,filename);
			exit(-1);
			break;
	}

	return c;
}

/* xsize, ysize is the size of the result, not size of */
/* the input image */
int loadpng(char *filename, unsigned char **image_ptr, int *xsize, int *ysize,
	int png_type, int skip) {

	int x,y,ystart,yadd,xadd;
	int color;
	FILE *infile;
	int debug=0;
	unsigned char *image,*out_ptr;
	int width, height;
	int a2_color;

	png_byte bit_depth;
	png_structp png_ptr;
	png_infop info_ptr;
	png_bytep *row_pointers;
	png_byte color_type;

	unsigned char header[8];

        /* open file and test for it being a png */
        infile = fopen(filename, "rb");
        if (infile==NULL) {
		fprintf(stderr,"Error!  Could not open %s\n",filename);
		return -1;
	}

	/* Check the header */
        fread(header, 1, 8, infile);
        if (png_sig_cmp(header, 0, 8)) {
		fprintf(stderr,"Error!  %s is not a PNG file\n",filename);
		return -1;
	}

        /* initialize stuff */
        png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
        if (!png_ptr) {
		fprintf(stderr,"Error create_read_struct\n");
		exit(-1);
	}

        info_ptr = png_create_info_struct(png_ptr);
        if (!info_ptr) {
		fprintf(stderr,"Error png_create_info_struct\n");
		exit(-1);
	}

	png_init_io(png_ptr, infile);
	png_set_sig_bytes(png_ptr, 8);

	png_read_info(png_ptr, info_ptr);

	width = png_get_image_width(png_ptr, info_ptr);
	height = png_get_image_height(png_ptr, info_ptr);

	/* get the xadd */
	if (width==80) {
		*xsize=40;
		xadd=2;
		yadd=1;
	}
	else if (width==160) {
		if (skip==2) {
			*xsize=160;
			xadd=1;
			yadd=1;
		}
		else {
			fprintf(stderr,"Unsupported skip %d!\n",skip);
			return -1;
		}
	}
	else if (width==320) {
		if (skip==8) {
			*xsize=40;
			xadd=8;
			yadd=1;
		}
		else if (skip==2) {
			*xsize=160;
			xadd=2;
			yadd=1;
		}
		else if (skip==1) {
			*xsize=320;
			xadd=1;
			yadd=1;
		}
		else {
			fprintf(stderr,"Unsupported skip %d!\n",skip);
			return -1;
		}
	}
	else {
		fprintf(stderr,"Unsupported width %d\n",width);
		return -1;
	}

	if (png_type==PNG_WHOLETHING) {
		*ysize=height;
		ystart=0;
		yadd*=1;
	}
	else if (png_type==PNG_ODDLINES) {
		*ysize=height/2;
		ystart=1;
		yadd*=4;
	}
	else if (png_type==PNG_EVENLINES) {
		*ysize=height/2;
		ystart=0;
		yadd*=4;
	}
	else if (png_type==PNG_RAW) {
		/* FIXME, not working */
		*ysize=height;
		ystart=0;
		yadd=1;
	}
	else {
		fprintf(stderr,"Unknown PNG type\n");
		return -1;
	}

	color_type = png_get_color_type(png_ptr, info_ptr);
	bit_depth = png_get_bit_depth(png_ptr, info_ptr);

	if (debug) {
		printf("PNG: width=%d height=%d depth=%d\n",width,height,bit_depth);
		if (color_type==PNG_COLOR_TYPE_RGB) printf("Type RGB\n");
		else if (color_type==PNG_COLOR_TYPE_RGB_ALPHA) printf("Type RGBA\n");
		else if (color_type==PNG_COLOR_TYPE_PALETTE) printf("Type palette\n");
		printf("Generating output size %d x %d\n",*xsize,*ysize);
	}

//        number_of_passes = png_set_interlace_handling(png_ptr);
	png_read_update_info(png_ptr, info_ptr);

	row_pointers = (png_bytep*) malloc(sizeof(png_bytep) * height);
	for (y=0; y<height; y++) {
		/* FIXME: do we ever free these? */
		row_pointers[y] = (png_byte*) malloc(png_get_rowbytes(png_ptr,info_ptr));
	}

	png_read_image(png_ptr, row_pointers);

	fclose(infile);

	image=calloc(width*height,sizeof(unsigned char));
	if (image==NULL) {
		fprintf(stderr,"Memory error!\n");
		return -1;
	}
	out_ptr=image;

	if (color_type==PNG_COLOR_TYPE_RGB_ALPHA) {
		for(y=ystart;y<height;y+=yadd) {
			for(x=0;x<width;x+=xadd) {
				/* convert to RGB */
				color=	(row_pointers[y][x*xadd*4]<<16)+
					(row_pointers[y][x*xadd*4+1]<<8)+
					(row_pointers[y][x*xadd*4+2]);
				if (debug) {
					printf("%x ",color);
				}

				a2_color=convert_color(color,filename);

				*out_ptr=a2_color;
				out_ptr++;
			}
			if (debug) printf("\n");
		}
	}
	else if (color_type==PNG_COLOR_TYPE_PALETTE) {
		for(y=ystart;y<height;y+=yadd) {
			for(x=0;x<width;x+=xadd) {
				if (bit_depth==8) {
					/* top color */
                                        a2_color=row_pointers[y][x];
					*out_ptr=a2_color<<1;
					out_ptr++;
				}
				else {
					printf("Unsupported depth %d\n",
						bit_depth);
				}
			}
		}
	}
	else {
		printf("Unknown color type\n");
	}

	*image_ptr=image;

	return 0;
}

