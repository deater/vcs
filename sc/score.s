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
; 0
	; to center exactly would want
	;	sprite0: ??
	;	sprite1: ??

	ldx	#3		;					; 2
; 2

spad_x:
	dex			;					; 2
	bne	spad_x		;					; 2/3

	; (5*X)-1 each time through
	;	so if X=3 then 14

	; X should be 0 here
; 16
	stx	VDELP0		; turn off delay			; 3
	stx	VDELP1							; 3
; 22

	lda	LEVEL_COLOR	; orange by default			; 3
	sta	COLUPF  	; set playfield color			; 3
	nop								; 2
	nop								; 2
	nop								; 2
	lda	$80		; nop3					; 3

; 37

	; want to be 37 here

	; beam is at proper place
	sta	RESP0							; 3
	; 40 (GPU=120, want ??) +?
	sta	RESP1							; 3
	; 43 (GPU=129, want ??) +?

; 43

	lda	#$90		; opposite what you'd think		; 2
	sta	HMP0							; 3
	lda	#$A0							; 2
	sta	HMP1							; 3
; 53

	; set color of sprite

	lda	#$0E	; bright white					; 2
	sta	COLUP0	; set sprite color				; 3
	sta	COLUP1	; set sprite color				; 3

; 61

	; set to be 32 adjacent pixels

	lda	#NUSIZ_TWO_COPIES_CLOSE					; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

; 69

	sta	WSYNC							; 3

	;===================
	; now scanline 1
	;===================
; 0
	sta	HMOVE	; adjust fine tune, must be after WSYNC		; 3
	ldx	#6							; 2


	jmp	blurgh	;						; 3

; 8


.align	$100

	;===================
	; now scanline 1..7
	;===================

scoreloop:
	sta	WSYNC							; 3
									;---
	lda	#0	; clear level # on playfield			; 2
	sta	PF0							; 3
	lda	$80	; nop3						; 3

blurgh:

; 8
	lda	score_bitmap0,X		; load sprite data		; 4+
	sta	GRP0			; 				; 3
; 15
	lda	score_bitmap0,X	; load sprite data			; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
; 22

	; try to draw level number on right of screen

	lda	$80	; nop 3						; 3
	nop								; 2
	lda	$80							; 3

	lda	LEVEL_SPRITE0,X						; 4
	sta	PF0 							; 3

; 37

	; need to write GRP0 at 44-47
	lda	SCORE_SPRITE_HIGH_0,X	; load sprite data		; 4
	ldy	SCORE_SPRITE_LOW_0,X					; 4

; 45

	sta	GRP0			;				; 3
	; write at 48!!
	sty	GRP1			;				; 3
	; wrote at 51

	dex								; 2
	bpl	scoreloop						; 2/3
	; aim for 76 if no WSYNC

	; 55 if fell through
; 55
	;
	; done drawing score
	;

	inc	TEMP1							; 5
; 60
	; turn off sprites

	ldy	#0							; 2
	sty	GRP1							; 3
	sty	GRP0							; 3
; 68
	sta	WSYNC
; 71
	; begin of scanline 8
