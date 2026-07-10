rom_tests:


; Testing screens

	lda	#$f
	sta	BUTTON_COUNTDOWN
	sta	NEW_TEST

	lda	#$0
	sta	DONE_TEST


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


.repeat 20
	sta	WSYNC
.endrepeat

	;=======================
	; scanline 21..35?

.include "update_numbers.s"


	;=======================
	; scanline 36 -- check new test

	lda	NEW_TEST
	beq	done_new_test

	lda	#0
	sta	NEW_TEST
	sta	DONE_TEST

	lda	#$10
	sta	WHICH_PAGE

	sta	E7_SET_BANK0	; start in BANK0?

done_new_test:
	sta	WSYNC

	;=======================
	; scanline 37 -- ???

	ldx	#0
	stx	VBLANK
	ldy	#4
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

	lda	DONE_TEST
	bne	done_checking

	lda	#$00						; 2
	sta	EXPECTED_H					; 3
	lda	#$00						; 2
	sta	EXPECTED_L					; 3
	sta	BAD_RESULT					; 3

	lda	#$00						; 2
	sta	INL						; 3
	lda	WHICH_PAGE					; 3
	sta	INH						; 3

	sta	WSYNC


	;==================================
	;==================================
	; scanline 9 - 137 = check 2 bytes
	;==================================
	;==================================

	ldx	#$80						; 2
	ldy	#0						; 2

row_loop:


compare_loop:
	lda	(INL),Y						; 5
	sta	SCORE_HIGH					; 3
	cmp	EXPECTED_H					; 3
	bne	bad_result					; 2/3

	iny							; 2
	lda	(INL),Y						; 5
	sta	SCORE_LOW					; 3
	cmp	EXPECTED_L					; 3
	bne	bad_result					; 2/3

	iny							; 2

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
	lda	#$1
	ora	BAD_RESULT
	lda	#$20
	sta	COLUPF


done_checking:

	;=============================================
	;=============================================
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

	sta	WSYNC

	jmp	start_test_frame
