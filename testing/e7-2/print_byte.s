	;============================================
	;============================================
	; print_byte (? scanlines)
	;============================================
	;============================================

	; comes in +6 from a jsr

	; which to print in Y

print_byte:

	; preserves Y?

	jsr	center_string

	; now scanline 1 + 9 cycles

	; cycles to loop

	tya
	asl
	asl
	asl
	clc

	adc	#char_data_start
	sta	INL

	lda	#0
	sta	INH

	ldx	#6							; 2

	; set to be just one copy

	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

	;===================
	; now scanline 1..7
	;===================

print_byte_loop:
	sta	WSYNC							; 3
									;---
; 8

	lda	(INL),Y				; load sprite data	; 5
	sta	GRP0			; 				; 3
; 15
	lda	#0
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
; 22
	dey

	dex								; 2
	bpl	print_byte_loop						; 2/3
	; aim for 76 if no WSYNC

	; 55 if fell through
; 55
	;
	; done drawing score
	;

; 60

; 68
	sta	WSYNC
; 71
	; turn off sprites

	ldy	#0							; 2
	sty	GRP1							; 3
	sty	GRP0							; 3

	sta	WSYNC

	rts

