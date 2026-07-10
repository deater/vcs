rom_tests:


	; comes in at unknown cycles, w/o last WSYNC

; Testing screens

	lda	#$f
	sta	BUTTON_COUNTDOWN
	sta	NEW_TEST

	lda	#$0
	sta	DONE_TEST
	sta	WHICH_TEST
	sta	PF0
	sta	PF1
	sta	PF2
	sta	COLUBK

	sta	WSYNC

; come in with 9 cycles?

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


.repeat 15
	sta	WSYNC
.endrepeat

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
	lda	#0							; 2
	sta	NEW_TEST						; 3
	sta	DONE_TEST						; 3
	sta	EXPECTED_L					; 3

	lda	WHICH_TEST
	tax
	asl
	asl
	asl
	asl
	sta	EXPECTED_H					; 3


	lda	#$f
	sta	BUTTON_COUNTDOWN

	lda	#$ff
	sta	DIGITS2
	sta	DIGITS3

; 19
	lda	#$10							; 2
	sta	WHICH_PAGE						; 3
; 24
;	ldx	WHICH_TEST
	sta	E7_SET_BANK0,X	; start in BANK0?			; 3
; 27

done_new_test:
; 12 / 27
	sta	WSYNC

	;=======================
	; scanline 37 -- ???

	ldx	#0
	stx	VBLANK
;	ldy	#4			; ???
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
;	lda	#$00						; 2
;	sta	EXPECTED_H					; 3
	lda	#$00						; 2
;	sta	EXPECTED_L					; 3
	sta	BAD_RESULT					; 3
; 24
	lda	#$00						; 2
	sta	INL						; 3
	lda	WHICH_PAGE					; 3
	sta	INH						; 3
; 35
	sta	WSYNC


	;==================================
	;==================================
	; scanline 9 - 137 = check 2 bytes
	;==================================
	;==================================

; 0
	ldx	#$80		; 128 pairs			; 2
	ldy	#0						; 2
; 4
row_loop:


compare_loop:
	lda	(INL),Y						; 5
	sta	DIGITS0						; 3
	cmp	EXPECTED_H					; 3
	bne	bad_result					; 2/3
; 
	iny							; 2
	lda	(INL),Y						; 5
	sta	DIGITS1					; 3
	cmp	EXPECTED_L					; 3
	bne	bad_result					; 2/3

	iny							; 2

retry:
	clc							; 2
	lda	EXPECTED_L					; 3
	adc	#2						; 2
	sta	EXPECTED_L					; 3
	lda	#0						; 2
	adc	EXPECTED_H					; 3
	sta	EXPECTED_H					; 3

	dex							; 2

	sta	WSYNC
	beq	done_checking
	bne	row_loop

bad_result:
	lda	EXPECTED_L
;	sta	BAD_L
	sta	DIGITS2
	lda	EXPECTED_H
;	sta	BAD_H
	sta	DIGITS3

	inc	BAD_RESULT
	sta	COLUBK
	jmp	retry

done_checking:

	;=============================================
	;=============================================
	; pad out end
	;=============================================
	;=============================================

	; draw 192-137 = 55 lines

	lda	DONE_TEST
	beq	not_done_test

	ldx	#184
	jmp	empty_loop

not_done_test:
	ldx	#55
empty_loop:
	sta	WSYNC
	dex
	bne	empty_loop

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

	; debounce

	lda	BUTTON_COUNTDOWN					; 3
	beq	twaited_button_enough					; 2/3
	dec	BUTTON_COUNTDOWN					; 5
	jmp	tdone_check_button					; 3

twaited_button_enough:

	lda	INPT4		; check joystick button pressed		; 3
	bpl	tdone_test						; 2/3

tdone_check_button:

	sta	WSYNC

	;================================
	; once again

	jmp	start_test_frame

tdone_test:


	inc	NEW_TEST
	inc	WHICH_TEST

	sta	WSYNC

	jmp	start_test_frame
