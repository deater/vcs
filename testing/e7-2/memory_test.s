memory_test:

	; comes in at unknown cycles, w/o last WSYNC

; Testing screens

	lda	#$5			; reset some values
	sta	WHICH_ROW

	sta	WSYNC


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

	ldx	#35
	jsr	repeat_wsync

	;=======================
	; scanline 16..35?

;	jsr	update_numbers

	; returns +6 cycles

	;=======================
	; scanline 36 -- check new test
; 6
;	lda	NEW_TEST						; 3
;	beq	done_new_test						; 2/3
; 11

	; configure new test

	lda	#0							; 2
;	sta	NEW_TEST	; reset new_test			; 3
;	sta	DONE_TEST	; reset done_test			; 3
;	sta	EXPECTED_L	; reset counter				; 3
;	sta	BAD_RESULT						; 3
;	sta	COLUBK			; clear background to black

; --
;	lda	WHICH_TEST	; set upper value based on test		; 3
;	tax			; in X for later			; 2
;	asl								; 2
;	asl								; 2
;	asl								; 2
;	asl								; 2
;	sta	EXPECTED_H						; 3
; 41

;	lda	#$f		; reset button debounce			; 2
;	sta	BUTTON_COUNTDOWN					; 3
; 46
	lda	#$ff		; clear out digits			; 2
;	sta	DIGITS2							; 3
;	sta	DIGITS3							; 3

; 54
;	lda	ROM_START	; setup where to start to read		; 3
;	sta	WHICH_PAGE	; ROM is $1000, RAM is $1400		; 3
; 60
;	ldx	WHICH_TEST
;	sta	E7_SET_BANK0,X	; start in BANK0?			; 5
; 65

done_new_test:
; 12 / 65
	sta	WSYNC

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

	ldx	#35
	jsr	repeat_wsync





	;==========================
	;==========================
	; overscan
	;==========================
	;==========================

	ldx	#27
	jsr	common_overscan

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

	jsr	check_joypad_button
	bcs	done_test

;current_test_continues:

	sta	WSYNC

	;================================
	; once again

	jmp	start_test_frame

done_test:


;	inc	NEW_TEST
;	inc	WHICH_TEST

;	lda	WHICH_TEST
;	cmp	#8
;	beq	done_roms


;	cmp	#7
;	bne	not_ram

;	lda	#$14
;	sta	ROM_START

not_ram:

	sta	WSYNC

	jmp	start_test_frame


done_roms:
	rts


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
