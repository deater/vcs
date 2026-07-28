memory_test:

	; comes in at unknown cycles, w/o last WSYNC


start_test_frame:

	;=============================
	; Start Vertical Blank

	lda	#2
	sta	VBLANK

	jsr	common_vblank

	; now 9 cycles in

	;=============================
	; 37 lines of vertical blank
	;=============================

	ldx	#36
	jsr	repeat_wsync

	;=======================
	; scanline 37 -- ???

	ldx	#0
	stx	VBLANK
	sta	WSYNC

	;============================================
	;============================================
	; playfield
	;============================================
	;============================================


	;===================================
	; 256 bank
	;===================================

	ldy	#0
	jsr	print_string

	ldy	#0
	jsr	print_byte

	; comes back +6 cycles

	ldx	#1
	jsr	update_row_color

	sta	WSYNC

	;===================================
	; 1k bank
	;===================================

	ldy	#1
	jsr	print_string

	ldy	#1
	jsr	print_byte

	; comes back +6 cycles

	ldx	#2
	jsr	update_row_color

	sta	WSYNC

	;===================================
	; 256 read
	;===================================

	ldy	#2
	jsr	print_string

	ldx	#4
	ldy	#5
	jsr	print_word

	; comes back +6 cycles

	ldx	#3
	jsr	update_row_color

	sta	WSYNC


	;===================================
	; 256 write
	;===================================

	ldy	#3
	jsr	print_string

	ldx	#6
	ldy	#7
	jsr	print_word

	; comes back +6 cycles

	ldx	#4
	jsr	update_row_color

	sta	WSYNC

	;===================================
	; 1k read
	;===================================

	ldy	#4
	jsr	print_string

	ldx	#8
	ldy	#9
	jsr	print_word

	; comes back +6 cycles

	ldx	#5
	jsr	update_row_color

	sta	WSYNC


	;===================================
	; 1k write
	;===================================

	ldy	#5
	jsr	print_string

	ldx	#$A
	ldy	#$B
	jsr	print_word

	; comes back +6 cycles

	ldx	#6
	jsr	update_row_color

	sta	WSYNC

	;===================================
	; write value
	;===================================

	ldy	#6
	jsr	print_string

	ldy	#2
	jsr	print_byte

	; comes back +6 cycles

	ldx	#7
	jsr	update_row_color

	sta	WSYNC


	;===================================
	; read_value
	;===================================

	ldy	#7
	jsr	print_string

	ldy	#3
	jsr	print_byte

	; comes back +6 cycles

	ldx	#0
	jsr	update_row_color

	sta	WSYNC


	;=============================================
	;=============================================
	; pad out end
	;=============================================
	;=============================================

	ldx	#26
	jsr	repeat_wsync


	;==============================
	; button pressed (6 cycles?)
	;==============================
	; check for button being pressed
	; + nothing pressed is 1 scanline
	; + read		7 scanlines
	; + write		1 scanlines


	jsr	check_joypad_button

;	bcs	button_was_pressed
	bcc	check_joypad_button_extra	; bra

button_was_pressed:
	; was pressed

	ldx	WHICH_ROW
	lda	button_table_h,X
	pha
	lda	button_table_l,X
	pha
	rts

button_table_l:
.byte <(button_row_0-1),<(button_row_1-1),<(button_row_2-1)
.byte <(button_row_3-1),<(button_row_4-1),<(button_row_5-1)
.byte <(button_row_6-1),<(button_row_7-1)

button_table_h:
.byte >(button_row_0-1),>(button_row_1-1),>(button_row_2-1)
.byte >(button_row_3-1),>(button_row_4-1),>(button_row_5-1)
.byte >(button_row_6-1),>(button_row_7-1)


	; change bank
button_row_0:
	ldx	BANK_256
	lda	$1FE8,X		; 1FE8=bank0,1fE9=1,1feA=2,1feb=3

	jmp	check_joypad_button_none

button_row_1:
	ldx	BANK_1K
	lda	$1FE0,X		; 1FE0=bank0 ROM.  1FE7=1k RAM bank

	jmp	check_joypad_button_none

button_row_2:
	lda	READ_256L
	sta	INL
	lda	READ_256H
	sta	INH
	ldy	#0
	lda	(INL),Y
	sta	READ_VALUE

	ldy	#3
	jsr	update_byte

	jmp	check_joypad_button_read

button_row_3:
	lda	WRITE_256L
	sta	INL
	lda	WRITE_256H
	sta	INH
	lda	WRITE_VALUE
	ldy	#0
	sta	(INL),Y

	jmp	check_joypad_button_none


button_row_4:
	lda	READ_1KL
	sta	INL
	lda	READ_1KH
	sta	INH
	ldy	#0
	lda	(INL),Y
	sta	READ_VALUE

	ldy	#3
	jsr	update_byte

	jmp	check_joypad_button_read

button_row_5:
	lda	WRITE_1KL
	sta	INL
	lda	WRITE_1KH
	sta	INH
	lda	WRITE_VALUE
	ldy	#0
	sta	(INL),Y

	jmp	check_joypad_button_none

button_row_6:
button_row_7:
	; do nothing
	jmp	check_joypad_button_none

check_joypad_button_extra:
	sta	WSYNC


check_joypad_button_none:

	; delay 6 rows

	ldx	#6
	jsr	repeat_wsync

check_joypad_button_read:

	sta	WSYNC


	;==========================
	;==========================
	; overscan
	;==========================
	;==========================

	ldx	#1
	jsr	common_overscan


	;==============================
	; overscan 0..12 (13 scanlines)
	;==============================
	; check for left being pressed
	; + nothing pressed is 1 scanline
	; + 8-bit value =  7 lines
	; + 16-bit value = 13 lines


	jsr	check_joypad_left

	bcs	left_was_pressed

	jmp	check_joypad_left_none

left_was_pressed:
	; was pressed

	ldx	WHICH_ROW
	lda	left_table_h,X
	pha
	lda	left_table_l,X
	pha
	rts

left_table_l:
.byte <(left_row_0-1),<(left_row_1-1),<(left_row_2-1)
.byte <(left_row_3-1),<(left_row_4-1),<(left_row_5-1)
.byte <(left_row_6-1),<(left_row_7-1)

left_table_h:
.byte >(left_row_0-1),>(left_row_1-1),>(left_row_2-1)
.byte >(left_row_3-1),>(left_row_4-1),>(left_row_5-1)
.byte >(left_row_6-1),>(left_row_7-1)


left_row_0:
	dec	BANK_256
	lda	BANK_256
	and	#3
	sta	BANK_256
	ldy	#0
	beq	check_joypad_left_8	; bra

left_row_1:
	dec	BANK_1K
	lda	BANK_1K
	and	#7
	sta	BANK_1K
	ldy	#1
	bne	check_joypad_left_8	; bra

left_row_2:
	sec
	lda	READ_256L
	sbc	#1
	sta	READ_256L

	lda	READ_256H
	sbc	#0
	sta	READ_256H

	ldy	#4
	jsr	update_byte
	ldy	#5
	bne	check_joypad_left_16	; bra

left_row_3:

	sec
	lda	WRITE_256L
	sbc	#1
	sta	WRITE_256L
	lda	WRITE_256H
	sbc	#0
	sta	WRITE_256H

	ldy	#6
	jsr	update_byte

	ldy	#7
	bne	check_joypad_left_16	; bra

left_row_4:

	sec
	lda	READ_1KL
	sbc	#1
	sta	READ_1KL
	lda	READ_1KH
	sbc	#0
	sta	READ_1KH

	ldy	#8
	jsr	update_byte

	ldy	#9
	bne	check_joypad_left_16	; bra

left_row_5:
	sec
	lda	WRITE_1KL
	sbc	#1
	sta	WRITE_1KL
	lda	WRITE_1KH
	sbc	#0
	sta	WRITE_1KH

	ldy	#10
	jsr	update_byte
	ldy	#11
	bne	check_joypad_left_16	; bra

left_row_6:
	dec	WRITE_VALUE
	ldy	#2
	bne	check_joypad_left_8	; bra

left_row_7:
	; do nothing


check_joypad_left_none:

	; delay 13 rows

	ldx	#13
	jsr	repeat_wsync

	jmp	check_joypad_left_done

check_joypad_left_8:

	; delay 6 rows to get to 13

	ldx	#6
	jsr	repeat_wsync

check_joypad_left_16:
	jsr	update_byte



check_joypad_left_done:
	sta	WSYNC



	;==============================
	; overscan 14-26 (13 scanlines)
	;==============================
	; check for right being pressed
	; + nothing pressed is 1 scanline
	; + 8-bit value =  7 lines
	; + 16-bit value = 13 lines


	jsr	check_joypad_right

	bcs	right_was_pressed

	jmp	check_joypad_right_none

right_was_pressed:
	; was pressed

	ldx	WHICH_ROW
	lda	right_table_h,X
	pha
	lda	right_table_l,X
	pha
	rts

right_table_l:
.byte <(right_row_0-1),<(right_row_1-1),<(right_row_2-1)
.byte <(right_row_3-1),<(right_row_4-1),<(right_row_5-1)
.byte <(right_row_6-1),<(right_row_7-1)

right_table_h:
.byte >(right_row_0-1),>(right_row_1-1),>(right_row_2-1)
.byte >(right_row_3-1),>(right_row_4-1),>(right_row_5-1)
.byte >(right_row_6-1),>(right_row_7-1)


right_row_0:
	inc	BANK_256
	lda	BANK_256
	and	#3
	sta	BANK_256
	ldy	#0
	beq	check_joypad_right_8	; bra

right_row_1:
	inc	BANK_1K
	lda	BANK_1K
	and	#7
	sta	BANK_1K
	ldy	#1
	bne	check_joypad_right_8	; bra

right_row_2:
	clc
	lda	#1
	adc	READ_256L
	sta	READ_256L
	lda	#0
	adc	READ_256H
	sta	READ_256H

	ldy	#4
	jsr	update_byte
	ldy	#5
	bne	check_joypad_right_16	; bra

right_row_3:
	clc
	lda	#1
	adc	WRITE_256L
	sta	WRITE_256L
	lda	#0
	adc	WRITE_256H
	sta	WRITE_256H

	ldy	#6
	jsr	update_byte
	ldy	#7
	bne	check_joypad_right_16	; bra

right_row_4:
	clc
	lda	#1
	adc	READ_1KL
	sta	READ_1KL
	lda	#0
	adc	READ_1KH
	sta	READ_1KH

	ldy	#8
	jsr	update_byte
	ldy	#9
	bne	check_joypad_right_16	; bra

right_row_5:
	clc
	lda	#1
	adc	WRITE_1KL
	sta	WRITE_1KL
	lda	#0
	adc	WRITE_1KH
	sta	WRITE_1KH

	ldy	#10
	jsr	update_byte
	ldy	#11
	bne	check_joypad_right_16	; bra

right_row_6:
	inc	WRITE_VALUE
	ldy	#2
	bne	check_joypad_right_8	; bra

right_row_7:
	; do nothing


check_joypad_right_none:

	; delay 13 rows

	ldx	#13
	jsr	repeat_wsync

	jmp	check_joypad_right_done

check_joypad_right_8:

	; delay 6 rows to get to 13

	ldx	#6
	jsr	repeat_wsync

check_joypad_right_16:
	jsr	update_byte



check_joypad_right_done:
	sta	WSYNC

	;==========================
	; overscan 27
	;==========================
	; check for down being pressed

	jsr	check_joypad_down

	bcc	check_joypad_down_done

	; was pressed

	inc	WHICH_ROW
	lda	WHICH_ROW
	and	#$7
	sta	WHICH_ROW

check_joypad_down_done:


	sta	WSYNC

	;==========================
	; overscan 28
	;==========================
	; check for up / down pressed

	jsr	check_joypad_up					; 31 worse case

	bcc	check_joypad_up_done

	; was pressed

	dec	WHICH_ROW
	lda	WHICH_ROW
	and	#$7
	sta	WHICH_ROW

check_joypad_up_done:

	sta	WSYNC

	;==========================
	; overscan 29
	;==========================
	; check for button press

;	jsr	check_joypad_button
;	bcs	done_test

;	sta	WSYNC

	;================================
	; once again

	lda	DEBOUNCE_COUNTDOWN
	beq	debounce_count_skip
	dec	DEBOUNCE_COUNTDOWN
debounce_count_skip:
	jmp	start_test_frame




	; handle row highlighting
	; if X=WHICH ROW, color on
	; else, color off
update_row_color:
	lda	#0
	cpx	WHICH_ROW
	bne	row_color_set
	lda	#$20

row_color_set:
	sta	COLUBK
	rts
