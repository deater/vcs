	;=========================
	; load level
	;=========================
	; load level data for CURRENT_LEVEL
	;	put in RAM starting at $1000
	;	also update 16-bytes of ZP level data

load_level:

	; load in level number

	ldy	CURRENT_LEVEL

	; swap in ROM bank

	ldx	level_bank_lookup,Y
	lda	$FFE0,X

	; copy 256 bytes of data to temp RAM

	lda	level_compress_data_low,Y
	sta	INL
	lda	level_compress_data_high,Y
	sta	INH

	ldy	#0
copy_compress_loop:
	lda	(INL),Y
	sta	$1800,Y			; copy to 256 byte RAM block
	iny
	bne	copy_compress_loop

	; swap in RAM

	lda	$1FE7

	; decompress from temporary RAM

	lda	#<$1900
	sta	ZX0_src
	lda	#>$1900
	sta	ZX0_src_h

	lda	#>$1000
	jsr	zx02_full_decomp


	; copy first 16 bytes to zero page

	ldy	#15
copy_zp_loop:
	lda	$1400,Y
	sta	LEVEL_DATA,Y

	dey
	bpl	copy_zp_loop


	rts


level_bank_lookup:
	.byte	0			; 0 = clock
	.byte	0			; 1 = rocket
	.byte	0			; 2 = arrival

level_compress_data_low:
	.byte	<$1000
	.byte	<$1000
	.byte	<$1000

level_compress_data_high:
	.byte	>$1000
	.byte	>$1000
	.byte	>$1000


