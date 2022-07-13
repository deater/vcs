	;============================================
	;============================================
	; MANS: 1 sprite (7 scanlines)
	;============================================
	;============================================
	; comes in on tail of a WSYNC

	; we leave most of the settings the same from the score

	;===================
	; now scanline 0..6
	;===================

	ldx	#6							; 2
	lda	$80		; nop3					; 3
	jmp	blurgh2							; 3

manloop:
	sta	WSYNC							; 3
									;---
	nop								; 2
	lda	TEMP1							; 3
	lda	$80		; nop3					; 3
blurgh2:
	; 8
	lda	mans_bitmap0,X		; load sprite data		; 4+
	sta	GRP0			;				; 3
	; 15
	lda	mans_bitmap1,X		; load sprite data		; 4+
	sta	GRP1			;				; 3
	; 22

	lda	mans_bitmap2,X		; load sprite data		; 4+
	ldy	MANS_SPRITE_0,X		; load sprite data		; 4
	; 30

	inc	TEMP1							; 5
	nop								; 2
	nop								; 2
	nop								; 2
	nop								; 2
	nop								; 2
	; 45

	sta	GRP0			;				; 3
	; 48
	sty	GRP1							; 3
	; 51

	dex								; 5
	bpl	manloop							; 2/3
	; aim for 76 if no WSYNC

	; 54 if fell through

	;
	; done drawing mans
	;

	inc	TEMP1			; nop				; 5

	; turn off sprites
	ldy	#0
	sty	GRP1
	sty	GRP0

	sta	WSYNC

