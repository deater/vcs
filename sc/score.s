	;============================================
	;============================================
	; draw Score (8 scanlines)
	;============================================
	;============================================

	;===================
	; now scanline 0
	;===================
	; center the sprite position
	; needs to be right after a WSYNC

	; to center exactly would want
	;	sprite0: 132 (GPU) = 44
	;	sprite1: 140 (GPU) = 46 2/3


	ldx	#0		; sprite 0 display nothing		; 2
	stx	GRP0		;					; 3

	stx	COLUPF			; playfield color		; 3
	stx	VDELP0			; turn off delay		; 3
	stx	VDELP1							; 3


	ldx	#3		;					; 2
spad_x:
	dex			;					; 2
	bne	spad_x		;					; 2/3

	; 3 + 5*X each time through
	;	so 18+7+9=34

	nop
	nop
	nop

	; want to be 40 here

	; beam is at proper place
	sta	RESP0							; 3
	; 43 (GPU=129, want 132) +3
	sta	RESP1							; 3
	; 46 (GPU=138, want 140) +2

	lda	#$80		; opposite what you'd think		; 2
	sta	HMP0							; 3
	lda	#$90							; 2
	sta	HMP1							; 3
	; 56

	; set color

	lda	#$0E	; bright white					; 2
	sta	COLUP0	; set sprite color				; 3
	sta	COLUP1	; set sprite color				; 3
								;===========
								;	8

	; set to be 32 adjacent pixels

	lda	#NUSIZ_TWO_COPIES_CLOSE					; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3
								;===========
								;	  8

	; 72

	sta	WSYNC							; 3

	sta	HMOVE	; adjust fine tune, must be after WSYNC		; 3
	ldx	#6							; 2


	jmp	blurgh	;						; 3
								;==========
								;	8


.align	$100

	;===================
	; now scanline 1..7
	;===================

scoreloop:
	sta	WSYNC							; 3
									;---
	nop								; 2
	lda	TEMP1							; 3
	lda	$80							; 3


blurgh:
	; 8
	lda	score_bitmap0,X		; load sprite data		; 4+
	sta	GRP0			; 				; 3
	; 15
	lda	score_bitmap1,X	; load sprite data			; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	; 22

	; need to write GRP0 at 44-47
	lda	score_bitmap2,X	; load sprite data			; 4+
	ldy	score_bitmap3,X	; load sprite data			; 4+
	; 30

	inc	TEMP1							; 5
	nop								; 2
	nop								; 2
	nop								; 2
	nop								; 2
	nop
	; 45

	sta	GRP0			;				; 3
	; write at 48!!
	sty	GRP1			;				; 3
	; wrote at 51

	dex								; 2
	bpl	scoreloop						; 2/3
	; aim for 76 if no WSYNC

	; 54 if fell through

	;
	; done drawing score
	;

	inc	TEMP1							; 5

	; turn off sprites

	ldy	#0
	sty	GRP1
	sty	GRP0

	sta	WSYNC

	; begin of scanline 8
