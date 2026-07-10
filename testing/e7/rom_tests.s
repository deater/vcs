rom_tests:

	; comes in at unknown cycles, w/o last WSYNC

; Testing screens

	lda	#$f
	sta	NEW_TEST		; set new test

	lda	#$0			; reset some values
	sta	DONE_TEST
	sta	WHICH_TEST
	sta	PF0			; is this needed?
	sta	PF1
	sta	PF2
	sta	COLUBK			; clear background to black

	lda	#$10
	sta	ROM_START		; this can vary if RAM

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

	ldx	#15
	jsr	repeat_wsync

	;=======================
	; scanline 16..35?

	jsr	update_numbers

	; returns +6 cycles

	;=======================
	; scanline 36 -- check new test
; 6
	lda	NEW_TEST						; 3
	beq	done_new_test						; 2/3
; 11

	; configure new test

	lda	#0							; 2
	sta	NEW_TEST	; reset new_test			; 3
	sta	DONE_TEST	; reset done_test			; 3
	sta	EXPECTED_L	; reset counter				; 3
	sta	BAD_RESULT						; 3
; 25
	lda	WHICH_TEST	; set upper value based on test		; 3
	tax			; in X for later			; 2
	asl								; 2
	asl								; 2
	asl								; 2
	asl								; 2
	sta	EXPECTED_H						; 3
; 41

	lda	#$f		; reset button debounce			; 2
	sta	BUTTON_COUNTDOWN					; 3
; 46
	lda	#$ff		; clear out digits			; 2
	sta	DIGITS2							; 3
	sta	DIGITS3							; 3

; 54
	lda	ROM_START	; setup where to start to read		; 3
	sta	WHICH_PAGE	; ROM is $1000, RAM is $1400		; 3
; 60
;	ldx	WHICH_TEST
	sta	E7_SET_BANK0,X	; start in BANK0?			; 5
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
	; print numbers
	;============================================
	;============================================

	jsr	print_numbers

	; comes back +6 cycles

	;==================================
	;==================================
	;==================================
	; memory check
	;==================================
	;==================================
	;==================================

	;=================================
	; scanline 8 = setup
	;==================================
; 6
	lda	DONE_TEST					; 3
	bne	done_checking					; 2/3
; 11

	lda	#$00						; 2
	sta	INL						; 3
	lda	WHICH_PAGE					; 3
	sta	INH						; 3
; 22

	;===========================
	; init the scanning routine

	ldx	#$80		; 128 pairs			; 2
	ldy	#0						; 2
; 26

	sta	WSYNC


	;===============================
	; check two bytes per scanline
	;===============================

; 0 / 5

row_loop:


compare_loop:
	lda	(INL),Y						; 5
	sta	RESULT_H					; 3
	sta	DIGITS0						; 3
	cmp	EXPECTED_H					; 3
	bne	bad_result1					; 2/3
; 16
	iny							; 2
	lda	(INL),Y						; 5
	sta	RESULT_L					; 3
	sta	DIGITS1						; 3
	cmp	EXPECTED_L					; 3
	bne	bad_result2					; 2/3
; 34
	iny							; 2
; 36

retry:
	clc			; 16 bit increment		; 2
	lda	EXPECTED_L	; cycle invariant		; 3
	adc	#2						; 2
	sta	EXPECTED_L					; 3
	lda	#0						; 2
	adc	EXPECTED_H					; 3
	sta	EXPECTED_H					; 3
; 54
	dex			; count down bytes remaining?	; 2
; 56 / 61
	sta	WSYNC
; 0
	beq	done_checking					; 2/3
; 2
	bne	row_loop		; bra			; 3


bad_result1:
; 17
	iny							; 2
bad_result2:
; 19 / 25
	iny
; 21 / 27

	lda	RESULT_L					; 3
	sta	BAD_L						; 3
	lda	RESULT_H					; 3
	sta	BAD_H						; 3

	lda	EXPECTED_L					; 3
	sta	BAD_ADDR_L					; 3
	sta	DIGITS3						; 3
	lda	EXPECTED_H					; 3
	sta	BAD_ADDR_H					; 3
	sta	DIGITS2						; 3

	inc	BAD_RESULT					; 5

	lda	#$40		; red				; 2
	sta	COLUBK						; 3
	jmp	retry						; 3

done_checking:

	;=============================================
	;=============================================
	; pad out end
	;=============================================
	;=============================================

	; draw 192-137 = 55 lines

	lda	DONE_TEST
	beq	not_done_test

	lda	BAD_RESULT
	beq	not_bad_result

	lda	BAD_L
	sta	DIGITS0
	lda	BAD_H
	sta	DIGITS1

not_bad_result:

	ldx	#184
	jmp	empty_loop

not_done_test:
	ldx	#55
empty_loop:
	jsr	repeat_wsync

	;==========================
	;==========================
	; overscan
	;==========================
	;==========================

	ldx	#28
	jsr	common_overscan


	;==========================
	; overscan 28
	;==========================
	; check for done page

	inc	WHICH_PAGE
	lda	WHICH_PAGE
	cmp	#$18
	bne	check_which_page_done

	inc	DONE_TEST

check_which_page_done:
	sta	WSYNC

	;==========================
	; overscan 29
	;==========================
	; check for button press

	jsr	check_joypad_button
	bcs	done_test

current_test_continues:

	sta	WSYNC

	;================================
	; once again

	jmp	start_test_frame

done_test:


	inc	NEW_TEST
	inc	WHICH_TEST

	lda	WHICH_TEST
	cmp	#8
	beq	done_roms


	cmp	#7
	bne	not_ram

	lda	#$14
	sta	ROM_START

not_ram:

	sta	WSYNC

	jmp	start_test_frame


done_roms:
