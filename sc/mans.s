	;============================================
	;============================================
	; draw Videlectrix Logo sprite (10 scanlines)
	;============================================
	;============================================
	; comes in on tail of a WSYNC

	;====================
	; Now scanline 0
	;====================
	; configure 48-pixel sprite code

	; make playfield black
;	lda	#$00			; black
;	sta	COLUPF			; playfield color

	; set color

;	lda	#$0E	; bright white					; 2
;	sta	COLUP0	; set sprite color				; 3
;	sta	COLUP1	; set sprite color				; 3

	; set to be 48 adjacent pixels

;	lda	#NUSIZ_TWO_COPIES_CLOSE					; 2
;	sta	NUSIZ0							; 3
;	sta	NUSIZ1							; 3


	; number of lines to draw
;	ldx	#7							; 2
;	stx	TEMP2							; 3

;	sta	WSYNC							; 3
								;===========


	;===================
	; now scanline 2
	;===================
	; center the sprite position
	; needs to be right after a WSYNC

	; to center exactly would want sprite0 at
	;	CPU cycle 41.3
	; and sprite1 at
	;	GPU cycle 44


;	ldx	#0		; sprite 0 display nothing		; 2
;	stx	GRP0		;					; 3

;	ldx	#6		;					; 2
;mpad_x:
;	dex			;					; 2
;	bne	mpad_x		;					; 2/3
	; 3 + 5*X each time through

	; beam is at proper place
;	sta	RESP0							; 3
	; 41 (GPU=123, want 124) +1
;	sta	RESP1							; 3
	; 44 (GPU=132, want 132) 0

;	lda	#$F0		; opposite what you'd think		; 2
;	sta	HMP0							; 3
;	lda	#$00							; 2
;	sta	HMP1							; 3

;	sta	WSYNC
;	sta	HMOVE		; adjust fine tune, must be after WSYNC


	;===================
	; now scanline 3
	;===================



	;===================
	; now scanline 4
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
	ldy	mans_bitmap3,X		; load sprite data		; 4+
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

