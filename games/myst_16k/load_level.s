

	;=========================
	; load level
	;=========================
	; load level data for CURRENT_LOCATION
	;	put in RAM starting at $1000
	;	also update 16-bytes of ZP level data

load_level:

	sta	WSYNC

	;=====================
	; set up in advance


	jsr	common_vblank

	lda	#18
	sta	T1024T


	; load in level number

;	ldy	#2

	ldy	CURRENT_LOCATION

	; swap in ROM bank


	; Note: we combined the ROM number with high data area to save room
	; top 3 bits indicate bank 0..7

	lda	level_bank_and_high,Y
	lsr
	lsr
	lsr
	lsr
	lsr
	tax
	lda	E7_SET_BANK0,X		; set bank

	; point to compressed area

	lda	level_compress_data_low,Y
	sta	INL
	lda	level_bank_and_high,Y
	and	#$1f
	sta	INH

	;===============================================
	; copy 256 bytes of compressed data to temp RAM
	;	can't decompress direct from ROM to main RAM
	;	as both can't be active at same time

	ldy	#0
copy_compress_loop:
	lda	(INL),Y			; load from ROM
	sta	E7_256B_WRITE_ADDR,Y	; copy to 256 byte RAM block
	iny
	bne	copy_compress_loop

	;=======================================
	; swap in RAM to bottom of address range

	sta	E7_SET_BANK7_RAM	; also MAME-recognized E7 signature

	;===============================
	; decompress from temporary RAM

	lda	#$4
	sta	READ_WRITE_OFFSET

	lda	#<E7_256B_READ_ADDR
	sta	ZX0_src
	lda	#>E7_256B_READ_ADDR
	sta	ZX0_src_h

	lda	#>E7_BANK_BASE
	jsr	zx02_full_decomp

	;=================================
	; copy first 16 bytes to zero page

	ldy	#15							; 2
copy_zp_loop:
	lda	E7_1K_READ_ADDR,Y					; 4+
	sta	LEVEL_DATA,Y						; 5

	dey								; 2
	bpl	copy_zp_loop						; 2/3


; 2+(14*15)-1 = 211 cycles = roughly 3 scanlines

	rts


level_bank_and_high:

	; Marker switch locations are 0..7 to make code slightly easier

	.byte	(1<<5) | (>gear_n_data_zx02)		; 0 = gear_n
	.byte	(1<<5) | (>dentist_n_data_zx02)		; 1 = dentist_n
	.byte	(2<<5) | (>rocket_close_n_data_zx02)	; 2 = rocket_close_n
	.byte	(1<<5) | (>pool_n_data_zx02)		; 3 = pool_n
	.byte	(2<<5) | (>shack_w_data_zx02)		; 4 = shack_w
	.byte	(2<<5) | (>cabin_e_data_zx02)		; 5 = cabin_e
	.byte	(3<<5) | (>clock_close_s_data_zx02)	; 6 = clock_close_s
	.byte	(1<<5) | (>dock_n_data_zx02)		; 7 = dock_n

	; places you can grab
	; 	first few area also Linking book locations

	.byte	(2<<5) | (>red_book_close_data_zx02)	; 8 = red_book_close
	.byte	(2<<5) | (>blue_book_close_data_zx02)	; 9 = blue_book_close
	.byte	(3<<5) | (>behind_fireplace_data_zx02)	; 10 = behind_fireplace
	.byte	(0<<5) | (>arrival_n_data_zx02)		; 11 = arrival_n
	.byte	(4<<5) | (>atrus_e_data_zx02)		; 12 = atrus_e


	; Other locations you can "grab"
	.byte	(3<<5) | (>library_sw_data_zx02)	; 13 = library_sw
	.byte	(3<<5) | (>inside_fireplace_data_zx02)	; 14 = inside_fireplace
	.byte	(0<<5) | (>clock_s_data_zx02)		; 15 = clock_s
	.byte	(5<<5) | (>library_nw_data_zx02)	; 16 = library_nw
	.byte	(5<<5) | (>library_ne_data_zx02)	; 17 = library_ne
	.byte	(5<<5) | (>clock_puzzle_data_zx02)	; 18 = clock_puzzle
	.byte	$FF					; 19 = in_elevator

	.byte	(1<<5) | (>library_n_data_zx02)		; 20 = library_n
	.byte	(0<<5) | (>rocket_n_data_zx02)		; 21 = rocket_n
	.byte	(0<<5) | (>hilltop_w_data_zx02)		; 22 = hilltop_w
	.byte	(0<<5) | (>imager_w_data_zx02)		; 23 = imager_w
	.byte	(0<<5) | (>hilltop_s_data_zx02)		; 24 = hilltop_s
	.byte	(0<<5) | (>hilltop_n_data_zx02)		; 25 = hilltop_n
	.byte	(0<<5) | (>hilltop_e_data_zx02)		; 26 = hilltop_e
	.byte	(3<<5) | (>arrival_e_data_zx02)		; 27 = arrival_e
	.byte	(0<<5) | (>clock_n_data_zx02)		; 28 = clock_n
	.byte	(2<<5) | (>shortsteps_w_data_zx02)	; 29 = shortsteps_w
	.byte	(1<<5) | (>gear_s_data_zx02)		; 30 = gear_s
	.byte	(1<<5) | (>library_s_data_zx02)		; 31 = library_s
	.byte	(0<<5) | (>arrival_s_data_zx02)		; 32 = arrival_s
	.byte	(1<<5) | (>arrival_w_data_zx02)		; 33 = arrival_w
	.byte	(1<<5) | (>hill_w_data_zx02)		; 34 = hill_w

	.byte	(2<<5) | (>library_w_data_zx02)		; 35 = library_w
	.byte	(2<<5) | (>library_e_data_zx02)		; 36 = library_e
	.byte	(1<<5) | (>steps_s_data_zx02)		; 37 = steps_s
	.byte	(3<<5) | (>shack_s_data_zx02)		; 38 = shack_s
	.byte	(3<<5) | (>cabin_path_s_data_zx02)	; 39 = cabin_path_s
	.byte	(2<<5) | (>cabin_path_n_data_zx02)	; 40 = cabin_path_n

	.byte	(3<<5) | (>library_se_data_zx02)	; 41 = library_se
	.byte	(2<<5) | (>burnt_book_data_zx02)	; 42 = burnt_book
	.byte	(3<<5) | (>imager_e_data_zx02)		; 43 = imager_e
	.byte	(5<<5) | (>shack_n_data_zx02)		; 44 = shack_n
	.byte	(4<<5) | (>dni_n_data_zx02)		; 45 = dni_n
	.byte	(4<<5) | (>dni_e_data_zx02)		; 46 = dni_e
	.byte	(4<<5) | (>trapped_data_zx02)		; 47 = trapped
	.byte	(4<<5) | (>dock_s_data_zx02)		; 48 = dock_s
	.byte	(4<<5) | (>dentist_e_data_zx02)		; 49 = dentist_e
	.byte	(4<<5) | (>rocket_s_data_zx02)		; 50 = rocket_s
	.byte	(4<<5) | (>pool_s_data_zx02)		; 51 = pool_s
	.byte	(4<<5) | (>you_win_data_zx02)		; 52 = you_win

	.byte	(5<<5) | (>steps_e_data_zx02)		; 53 = steps_e
	.byte	(5<<5) | (>library_up_data_zx02)	; 54 = library_up
	.byte	(5<<5) | (>elevator_n_data_zx02)	; 55 = elevator_n
	.byte	(5<<5) | (>elevator_s_data_zx02)	; 56 = elevator_s
	.byte	(5<<5) | (>hint_data_zx02)		; 57 = hint


level_compress_data_low:
	.byte	<gear_n_data_zx02			; 0 = gear_n
	.byte	<dentist_n_data_zx02			; 1 = dentist_n
	.byte	<rocket_close_n_data_zx02		; 2 = rocket_close_n
	.byte	<pool_n_data_zx02			; 3 = pool_n
	.byte	<shack_w_data_zx02			; 4 = shack_w
	.byte	<cabin_e_data_zx02			; 5 = cabin_e
	.byte	<clock_close_s_data_zx02		; 6 = clock_close_s
	.byte	<dock_n_data_zx02			; 7 = dock_n

	.byte	<red_book_close_data_zx02		; 8 = red_book_close
	.byte	<blue_book_close_data_zx02		; 9 = blue_book_close
	.byte	<behind_fireplace_data_zx02		; 10 = behind_fireplace
	.byte	<arrival_n_data_zx02			; 11 = arrival_n
	.byte	<atrus_e_data_zx02			; 12 = atrus_e

	.byte	<library_sw_data_zx02			; 13 = library_sw
	.byte	<inside_fireplace_data_zx02		; 14 = inside_fireplace
	.byte	<clock_s_data_zx02			; 15 = clock_s

	.byte	<library_nw_data_zx02			; 16 = library_nw
	.byte	<library_ne_data_zx02			; 17 = library_ne
	.byte	<clock_puzzle_data_zx02			; 18 = clock_puzzle
	.byte	$FF					; 19 = inside_elevator

	.byte	<library_n_data_zx02			; 20 = library_n
	.byte	<rocket_n_data_zx02			; 21 = rocket_n
	.byte	<hilltop_w_data_zx02			; 22 = hilltop_w
	.byte	<imager_w_data_zx02			; 23 = imager_w
	.byte	<hilltop_s_data_zx02			; 24 = hilltop_s
	.byte	<hilltop_n_data_zx02			; 25 = hilltop_n
	.byte	<hilltop_e_data_zx02			; 26 = hilltop_e
	.byte	<arrival_e_data_zx02			; 27 = arrival_e
	.byte	<clock_n_data_zx02			; 28 = clock_n

	.byte	<shortsteps_w_data_zx02			; 29 = shortsteps_w
	.byte	<gear_s_data_zx02			; 30 = gear_s
	.byte	<library_s_data_zx02			; 31 = library_s
	.byte	<arrival_s_data_zx02			; 32 = arrival_s
	.byte	<arrival_w_data_zx02			; 33 = arrival_w
	.byte	<hill_w_data_zx02			; 34 = hill_W

	.byte	<library_w_data_zx02			; 35 = library_w
	.byte	<library_e_data_zx02			; 36 = library_e
	.byte	<steps_s_data_zx02			; 37 = steps_s

	.byte	<shack_s_data_zx02			; 38 = shack_s
	.byte	<cabin_path_s_data_zx02			; 39 = cabin_path_s
	.byte	<cabin_path_n_data_zx02			; 40 = cabin_path_n

	.byte	<library_se_data_zx02			; 41 = library_se
	.byte	<burnt_book_data_zx02			; 42 = burnt_book
	.byte	<imager_e_data_zx02			; 43 = imager_e
	.byte	<shack_n_data_zx02			; 44 = shack_n

	.byte	<dni_n_data_zx02			; 45 = dni_n
	.byte	<dni_e_data_zx02			; 46 = dni_e
	.byte	<trapped_data_zx02			; 47 = trapped
	.byte	<dock_s_data_zx02			; 48 = dock_S
	.byte	<dentist_e_data_zx02			; 49 = dentist_e
	.byte	<rocket_s_data_zx02			; 50 = rocket_s
	.byte	<pool_s_data_zx02			; 51 = pool_s
	.byte	<you_win_data_zx02			; 52 = you_win

	.byte	<steps_e_data_zx02			; 53 = steps_e
	.byte	<library_up_data_zx02			; 54 = library_up
	.byte	<elevator_n_data_zx02			; 55 = elevator_n
	.byte	<elevator_s_data_zx02			; 56 = elevator_s
	.byte	<hint_data_zx02				; 57 = hint
