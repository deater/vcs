

	;=========================
	; load level
	;=========================
	; load level data for CURRENT_LOCATION
	;	put in RAM starting at $1000
	;	also update 16-bytes of ZP level data

load_level:

	; load in level number

;	ldy	#2

	ldy	CURRENT_LOCATION

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

.include "locations/level_locations.inc"

level_bank_lookup:
	.byte	0			; 0 = clock_s
	.byte	0			; 1 = rocket_n
	.byte	0			; 2 = arrival_n
	.byte	0			; 3 = hilltop_w
	.byte	0			; 4 = pool
	.byte	0			; 5 = hilltop_s
	.byte	0			; 6 = hilltop_n
	.byte	0			; 7 = hilltop_e
	.byte	0			; 8 = arrival_e
	.byte	0			; 9 = clock_n
	.byte	1			; 10 = shortsteps_w
	.byte	1			; 11 = dock_n
	.byte	1			; 12 = library_n
	.byte	1			; 13 = gear_n
	.byte	1			; 14 = gear_s
	.byte	1			; 15 = library_s

level_compress_data_low:
	.byte	<clock_s_data_zx02
	.byte	<rocket_n_data_zx02
	.byte	<arrival_n_data_zx02
	.byte	<hilltop_w_data_zx02
	.byte	<pool_w_data_zx02
	.byte	<hilltop_s_data_zx02
	.byte	<hilltop_n_data_zx02
	.byte	<hilltop_e_data_zx02
	.byte	<arrival_e_data_zx02
	.byte	<clock_n_data_zx02
	.byte	<shortsteps_w_data_zx02
	.byte	<dock_n_data_zx02
	.byte	<library_n_data_zx02
	.byte	<gear_n_data_zx02
	.byte	<gear_s_data_zx02
	.byte	<library_s_data_zx02


level_compress_data_high:
	.byte	>clock_s_data_zx02
	.byte	>rocket_n_data_zx02
	.byte	>arrival_n_data_zx02
	.byte	>hilltop_w_data_zx02
	.byte	>pool_w_data_zx02
	.byte	>hilltop_s_data_zx02
	.byte	>hilltop_n_data_zx02
	.byte	>hilltop_e_data_zx02
	.byte	>arrival_e_data_zx02
	.byte	>clock_n_data_zx02
	.byte	>shortsteps_w_data_zx02
	.byte	>dock_n_data_zx02
	.byte	>library_n_data_zx02
	.byte	>gear_n_data_zx02
	.byte	>gear_s_data_zx02
	.byte	>library_s_data_zx02

