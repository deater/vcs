/* Pad small ROM so will run in emulators that expect at last 2k ROM */

/* Two ways to do this, one is pad with zeros, the other is mirror */
/* the data [as you would see in real life if you just left off */
/* address pins] */

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <string.h>
#include <sys/stat.h>

#define PAD_ZERO	0
#define PAD_MIRROR	1


static void print_help(char *name, int show_help) {

	fprintf(stderr,"Usage:\t%s [-m] [-z] [-s size] INFILE OUTFILE\n\n",name);
	fprintf(stderr,"\t-m : mirror ROM contents\n");
	fprintf(stderr,"\t-z : pad with zeros\n");
	fprintf(stderr,"\t-s size : size of output ROM\n");
	exit(-1);
}


int main(int argc, char **argv) {

	int input_size=256;
	int output_size=2048;
	int pad_type=PAD_ZERO;
	int c,input_fd,output_fd;
	char *input,*output;
	char *input_filename,*output_filename;
	int result;
	struct stat statbuf;

	/* Check command line arguments */
	while ((c = getopt (argc, argv,"hvs:mz"))!=-1) {
		switch (c) {
		case 'm':
			pad_type=PAD_MIRROR;
			break;
		case 'z':
			pad_type=PAD_ZERO;
			break;
		case 's':
			output_size=strtod(optarg,NULL);
			break;
		case 'h':
			print_help(argv[0],1);
			break;
		case 'v':
			print_help(argv[0],0);
			break;

		}
	}

	if (optind==argc) {
		fprintf(stderr,"ERROR!  Must specify input file\n\n");
		return -1;
	}
	/* get argument 1, which is input name */
	input_filename=strdup(argv[optind]);

	/* Move to next argument */
	optind++;

	if (optind==argc) {
		fprintf(stderr,"ERROR!  Must specify output file!\n\n");
		return -1;
	}

	/* get arugment 2 which is output name */
	output_filename=strdup(argv[optind]);

	/* open input ROM */
	input_fd=open(input_filename,O_RDONLY);
	if (input_fd<0) {
		fprintf(stderr,"Error opening input file %s (%s)\n",
			input_filename,strerror(errno));
		return -1;
	}

	/* get size of ROM */
	result=fstat(input_fd,&statbuf);
	if (result<0) {
		fprintf(stderr,"Error getting file size of input\n");
		return -1;
	}

	input_size=statbuf.st_size;

	/* allocate space for input file data */
	input=calloc(input_size,sizeof(char));
	if (input==NULL) {
		fprintf(stderr,"Error allocating room for input\n");
		return -1;
	}

	/* allocate space for output file data */
	output=calloc(output_size,sizeof(char));
	if (output==NULL) {
		fprintf(stderr,"Error allocating room for output\n");
		return -1;
	}

	/* read input ROM */
	result=read(input_fd,input,input_size);
	if (result<0) {
		fprintf(stderr,"Error reading input %s\n",strerror(errno));
		return -1;
	}
	if (result!=input_size) {
		fprintf(stderr,"Error only read %d bytes\n",result);
		return -1;
	}

	/* close file descriptor */
	close(input_fd);

	/******************/
	/* do the padding */
	/******************/

	if (pad_type==PAD_ZERO) {
		memcpy(output+(output_size-input_size),input,input_size);
	}
	else if (pad_type==PAD_MIRROR) {

	}
	else {
		fprintf(stderr,"Unknown pad type!\n");
		return -1;
	}


	/* open output ROM */
	output_fd=open(output_filename,O_RDWR|O_CREAT,0666);
	if (output_fd<0) {
		fprintf(stderr,"Error opening input file %s (%s)\n",
			output_filename,strerror(errno));
		return -1;
	}

	/* write output ROM */
	result=write(output_fd,output,output_size);
	if (result<0) {
		fprintf(stderr,"Error writing output %s\n",strerror(errno));
		return -1;
	}
	if (result!=output_size) {
		fprintf(stderr,"Error only wrote %d bytes\n",result);
		return -1;
	}


	close(output_fd);

	free(input);
	free(output);

	return 0;
}
