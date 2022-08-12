

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
	.byte	1			; 0 = gear_n
	.byte	1			; 1 = dentist_n
	.byte	$FF			; 2 = rocket_close_n
	.byte	$FF			; 3 = pool_n
	.byte	$FF			; 4 = shack_w
	.byte	$FF			; 5 = cabin_e
	.byte	$FF			; 6 = clock_close_s
	.byte	1			; 7 = dock_n

	.byte	0			; 8 = clock_s
	.byte	0			; 9 = rocket_n
	.byte	0			; 10 = arrival_n
	.byte	0			; 11 = hilltop_w
	.byte	0			; 12 = imager_w
	.byte	0			; 13 = hilltop_s
	.byte	0			; 14 = hilltop_n
	.byte	0			; 15 = hilltop_e
	.byte	0			; 16 = arrival_e
	.byte	0			; 17 = clock_n
	.byte	1			; 18 = shortsteps_w
	.byte	1			; 19 = library_n
	.byte	1			; 20 = gear_s
	.byte	1			; 21 = library_s
	.byte	1			; 22 = arrival_s
	.byte	1			; 23 = arrival_w
	.byte	1			; 24 = hill_w
	.byte	2			; 25 = library_w


level_compress_data_low:
	.byte	<gear_n_data_zx02			; 0
	.byte	<dentist_n_data_zx02			; 1
	.byte	$FF					; 2
	.byte	$FF					; 3
	.byte	$FF					; 4
	.byte	$FF					; 5
	.byte	$FF					; 6
	.byte	<dock_n_data_zx02			; 7

	.byte	<clock_s_data_zx02
	.byte	<rocket_n_data_zx02
	.byte	<arrival_n_data_zx02
	.byte	<hilltop_w_data_zx02
	.byte	<imager_w_data_zx02
	.byte	<hilltop_s_data_zx02
	.byte	<hilltop_n_data_zx02
	.byte	<hilltop_e_data_zx02
	.byte	<arrival_e_data_zx02
	.byte	<clock_n_data_zx02
	.byte	<shortsteps_w_data_zx02
	.byte	<library_n_data_zx02
	.byte	<gear_s_data_zx02
	.byte	<library_s_data_zx02
	.byte	<arrival_s_data_zx02
	.byte	<arrival_w_data_zx02
	.byte	<hill_w_data_zx02
	.byte	<library_w_data_zx02



level_compress_data_high:
	.byte	>gear_n_data_zx02			; 0
	.byte	>dentist_n_data_zx02			; 1
	.byte	$FF					; 2
	.byte	$FF					; 3
	.byte	$FF					; 4
	.byte	$FF					; 5
	.byte	$FF					; 6
	.byte	>dock_n_data_zx02			; 7

	.byte	>clock_s_data_zx02
	.byte	>rocket_n_data_zx02
	.byte	>arrival_n_data_zx02
	.byte	>hilltop_w_data_zx02
	.byte	>imager_w_data_zx02
	.byte	>hilltop_s_data_zx02
	.byte	>hilltop_n_data_zx02
	.byte	>hilltop_e_data_zx02
	.byte	>arrival_e_data_zx02
	.byte	>clock_n_data_zx02
	.byte	>shortsteps_w_data_zx02
	.byte	>library_n_data_zx02
	.byte	>gear_s_data_zx02
	.byte	>library_s_data_zx02
	.byte	>arrival_s_data_zx02
	.byte	>arrival_w_data_zx02
	.byte	>hill_w_data_zx02
	.byte	>library_w_data_zx02


