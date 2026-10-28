	;============================================
	;============================================
	; print_word (? scanlines)
	;============================================
	;============================================

	; comes in +6 from a jsr

	; high byte in X
	; low byte in Y

print_word:
	stx	INL			; save X for later		; 3


	; preserves Y

	jsr	center_string

	; now scanline+1 + 9 cycles

	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

	lda	INL			; multiply by 8			; 3
	asl								; 2
	asl								; 2
	asl								; 2
	clc								; 2
	adc	#char_data_start					; 2
	sta	INL							; 3

	tya				; get low byte			; 2
	asl				; multipy by 8			; 2
	asl								; 2
	asl								; 2
	clc				; add offset			; 2
	adc	#char_data_start					; 2
	sta	OUTL							; 3

	lda	#0			; set high pointers		; 2
	sta	INH							; 3
	sta	OUTH							; 3

	ldy	#6			; loop counter			; 2

	;===================
	; now scanline 1..7
	;===================

print_word_loop:
	sta	WSYNC							; 3


; 8
	; note: starting from bottom

	lda	(OUTL),Y		; load sprite data		; 5+
	sta	GRP0			; left byte 			; 3
; 15
	lda	(INL),Y			; load sprite data		; 5+
	sta	GRP1			; right byte			; 3
; 22

	dey								; 2
	bpl	print_word_loop						; 2/3


	; 55 if fell through
; 55

	sta	WSYNC

	; turn off sprites

	ldy	#0							; 2
	sty	GRP1							; 3
	sty	GRP0							; 3


	rts

