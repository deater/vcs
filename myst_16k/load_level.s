

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

	lda	#$4
	sta	READ_WRITE_OFFSET

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
	.byte	2			; 2 = rocket_close_n
	.byte	2			; 3 = pool_n
	.byte	2			; 4 = shack_w
	.byte	2			; 5 = cabin_e
	.byte	2			; 6 = clock_close_s
	.byte	1			; 7 = dock_n

	.byte	2			; 8 = red_book_close
	.byte	2			; 9 = blue_book_close
	.byte	$FF			; 10 = green_book_close
	.byte	0			; 11 = arrival_n

	.byte	0			; 12 = clock_s
	.byte	0			; 13 = rocket_n
	.byte	0			; 14 = hilltop_w
	.byte	0			; 15 = imager_w
	.byte	0			; 16 = hilltop_s
	.byte	0			; 17 = hilltop_n
	.byte	0			; 18 = hilltop_e
	.byte	0			; 19 = arrival_e
	.byte	0			; 20 = clock_n
	.byte	1			; 21 = shortsteps_w
	.byte	1			; 22 = library_n
	.byte	1			; 23 = gear_s
	.byte	1			; 24 = library_s
	.byte	1			; 25 = arrival_s
	.byte	1			; 26 = arrival_w
	.byte	1			; 27 = hill_w
	.byte	2			; 28 = library_w
	.byte	2			; 29 = library_e
	.byte	2			; 30 = steps_s
	.byte	3			; 31 = shack_s
	.byte	3			; 32 = cabin_path_s
	.byte	3			; 33 = cabin_path_n
	.byte	3			; 34 = library_sw
	.byte	3			; 35 = library_se
	.byte	3			; 36 = burnt_book
	.byte	3			; 37 = imager_e
	.byte	3			; 38 = behind_fireplace
	.byte	3			; 39 = inside_fireplace
	.byte	4			; 40 = dni_n
	.byte	4			; 41 = dni_e



level_compress_data_low:
	.byte	<gear_n_data_zx02			; 0
	.byte	<dentist_n_data_zx02			; 1
	.byte	<rocket_close_n_data_zx02		; 2
	.byte	<pool_n_data_zx02			; 3
	.byte	<shack_w_data_zx02			; 4
	.byte	<cabin_e_data_zx02			; 5
	.byte	<clock_close_s_data_zx02		; 6
	.byte	<dock_n_data_zx02			; 7

	.byte	<red_book_close_data_zx02		; 8
	.byte	<blue_book_close_data_zx02		; 9
	.byte	$FF					; 10
	.byte	<arrival_n_data_zx02			; 11

	.byte	<clock_s_data_zx02
	.byte	<rocket_n_data_zx02
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
	.byte	<library_e_data_zx02
	.byte	<steps_s_data_zx02
	.byte	<shack_s_data_zx02
	.byte	<cabin_path_s_data_zx02
	.byte	<cabin_path_n_data_zx02
	.byte	<library_sw_data_zx02
	.byte	<library_se_data_zx02
	.byte	<burnt_book_data_zx02
	.byte	<imager_e_data_zx02
	.byte	<behind_fireplace_data_zx02
	.byte	<inside_fireplace_data_zx02
	.byte	<dni_n_data_zx02
	.byte	<dni_e_data_zx02



level_compress_data_high:
	.byte	>gear_n_data_zx02			; 0
	.byte	>dentist_n_data_zx02			; 1
	.byte	>rocket_close_n_data_zx02		; 2
	.byte	>pool_n_data_zx02			; 3
	.byte	>shack_w_data_zx02			; 4
	.byte	>cabin_e_data_zx02			; 5
	.byte	>clock_close_s_data_zx02		; 6
	.byte	>dock_n_data_zx02			; 7

	.byte	>red_book_close_data_zx02		; 8
	.byte	>blue_book_close_data_zx02		; 9
	.byte	$FF					; 10
	.byte	>arrival_n_data_zx02			; 11

	.byte	>clock_s_data_zx02
	.byte	>rocket_n_data_zx02
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
	.byte	>library_e_data_zx02
	.byte	>steps_s_data_zx02
	.byte	>shack_s_data_zx02
	.byte	>cabin_path_s_data_zx02
	.byte	>cabin_path_n_data_zx02
	.byte	>library_sw_data_zx02
	.byte	>library_se_data_zx02
	.byte	>burnt_book_data_zx02
	.byte	>imager_e_data_zx02
	.byte	>behind_fireplace_data_zx02
	.byte	>inside_fireplace_data_zx02
	.byte	>dni_n_data_zx02
	.byte	>dni_e_data_zx02
