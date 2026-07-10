ram_tests:

	; comes in at unknown cycles, w/o last WSYNC

; Testing screens

	lda	#$f
	sta	NEW_TEST

	lda	#$0
	sta	WHICH_TEST

	sta	WSYNC


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
	sta	COLUBK		; black background			; 3
	sta	BAD_RESULT
; 25
	lda	WHICH_TEST						; 3
	tax			; for later				; 2
	asl								; 2
	asl								; 2
	asl								; 2
	asl								; 2
	sta	EXPECTED_H						; 3
; 41
	lda	#$f							; 2
	sta	BUTTON_COUNTDOWN					; 3
; 46
	lda	#$ff							; 2
	sta	DIGITS2							; 3
	sta	DIGITS3							; 3
; 54

	lda	#$18	; set output/input pointers			; 2
	sta	OUTH							; 3
	lda	#$19							; 2
	sta	INH							; 3

; 64
	; WHICH_TEST is in X
	sta	E7_SET_256_BANK0,X	; start in BANK0?		; 3
; 67

done_new_ram_test:
; 12/67
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

	;==================================
	; RAM TEST
	;=================================

	; Skip if DONE
; 6
	lda	DONE_TEST						; 3
	bne	skip_ram_test						; 2/3
; 11

	;===========================
	; read back

	ldy	#0							; 2
ram_read_loop:
	lda	$1900,Y							; 5
	sta	RESULT_H
	sta	DIGITS0							; 3
	cmp	EXPECTED_H						; 3
	bne	ram_bad_result						; 2/3

	tya								; 2
	sta	DIGITS1							; 3
	lda	$1901,Y							; 5
	sta	RESULT_L
	cmp	DIGITS1
	bne	ram_bad_result						; 2/3

ram_retry:
	iny								; 2
	iny								; 2
	bne	ram_read_loop						; 2/3
	beq	ram_done_checking		; bra			; 3

ram_bad_result:
	lda	EXPECTED_H						; 3
	sta	DIGITS2							; 3
	tya								; 2
	sta	DIGITS3							; 3

	lda	RESULT_H
	sta	BAD_H
	lda	RESULT_L
	sta	BAD_L

	inc	BAD_RESULT						; 5
	lda	#$40							; 2
	sta	COLUBK							; 3
	jmp	ram_retry						; 3

ram_done_checking:

	inc	DONE_TEST
	sta	WSYNC

; 12 / 
	jmp	did_ram_test

	;=============================================
	;=============================================
	; pad out end
	;=============================================
	;=============================================

	; draw 192-137 = 55 lines


skip_ram_test:
	ldx	#184
	jmp	ram_empty_loop

did_ram_test:
	lda	BAD_RESULT
	beq	ram_was_ok

	lda	BAD_L
	sta	DIGITS1
	lda	BAD_H
	sta	DIGITS0

ram_was_ok:

	; 226, so + 36  97+36=133
	; -15?
;	ldx	#133
	ldx	#118
ram_empty_loop:
	jsr	repeat_wsync

	;==========================
	;==========================
	; overscan
	;==========================
	;==========================

	ldx	#29
	jsr	common_overscan

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

	inc	NEW_TEST						; 5
	inc	WHICH_TEST						; 5

	lda	WHICH_TEST						; 3
	cmp	#4							; 2
	beq	done_ram_test						; 2/3

	sta	WSYNC

	jmp	start_ram_test_frame

done_ram_test:
	rts
