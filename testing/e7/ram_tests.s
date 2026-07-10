ram_tests:

	; comes in at unknown cycles, w/o last WSYNC

; Testing screens


	lda	#$f
	sta	BUTTON_COUNTDOWN
	sta	NEW_TEST
.if 0
	lda	#$0
	sta	DONE_TEST
	sta	WHICH_TEST
	sta	COLUBK

	sta	WSYNC
.endif

start_ram_test_frame:


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
	beq	done_new_ram_test					; 2/3
; 11
	lda	#0		; turn off new test			; 2
	sta	NEW_TEST	; not done the test			; 3
	sta	DONE_TEST						; 3
	sta	EXPECTED_L	; address is 0				; 3

	lda	WHICH_TEST
	tax
	asl
	asl
	asl
	asl
	sta	EXPECTED_H

	lda	#$f
	sta	BUTTON_COUNTDOWN

	lda	#$ff
	sta	DIGITS2
	sta	DIGITS3

	lda	#$18
	sta	OUTH
	lda	#$19
	sta	INH

; 19
	lda	#$10							; 2
	sta	WHICH_PAGE						; 3
; 24
;	ldx	WHICH_TEST
	sta	E7_SET_256_BANK0,X	; start in BANK0?		; 3
; 27

done_new_ram_test:
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

	;==================================
	; RAM TEST
	;=================================

	; Skip if DONE
; 6
	lda	DONE_TEST					; 3
	bne	ram_done_checking				; 2/3


	;===========================
	; read back

	ldy	#0							; 2
ram_read_loop:
	lda	$1900,Y							; 5
	sta	DIGITS0
	cmp	EXPECTED_H						; 3
	bne	ram_bad_result

	tya								; 2
	sta	DIGITS1
	cmp	$1901,Y							; 5
	bne	ram_bad_result

ram_retry:
	iny								; 2
	iny
	bne	ram_read_loop						; 2/3
	beq	ram_done_checking

ram_bad_result:
	lda	EXPECTED_L
	sta	DIGITS2
	tay
	sta	DIGITS3

	inc	BAD_RESULT
	sta	COLUBK
	jmp	ram_retry

ram_done_checking:

	sta	WSYNC

	;=============================================
	;=============================================
	; pad out end
	;=============================================
	;=============================================

	; draw 192-137 = 55 lines

	lda	DONE_TEST
	beq	not_done_ram_test

	ldx	#183
	jmp	ram_empty_loop

not_done_ram_test:
	ldx	#96
ram_empty_loop:
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
	bne	ram_check_which_page_done

	inc	DONE_TEST

ram_check_which_page_done:
	sta	WSYNC

	;==========================
	; overscan 29
	;==========================
	; check for button press

	jsr	check_joypad_button
	bcs	next_ram_test

ram_test_continues:
	sta	WSYNC

	;================================
	; once again

	jmp	start_ram_test_frame

next_ram_test:


	inc	NEW_TEST
	inc	WHICH_TEST

	lda	WHICH_TEST
	cmp	#5
	beq	done_ram_test

	sta	WSYNC

	jmp	start_ram_test_frame

done_ram_test:
