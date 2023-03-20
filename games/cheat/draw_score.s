	;============================================
	;============================================
	; draw Score (8 scanlines)
	;============================================
	;============================================

	;===================
	; now scanline 0
	;===================
	; center the sprite position
;16
draw_score:
; 16
	lda	#$00							; 2
	sta	COLUBK							; 3
	sta	REFP0							; 3
	sta	REFP1							; 3

; 27
	lda	#$c0		; $c0 = right 4				; 2
	sta	HMP0							; 3
	lda	#$d0		; $d0 = right 3				; 2
	sta	HMP1							; 3

; 37
	inc	TEMP1
	nop
	nop

	; (5*X)-1 each time through
	;	so if X=3 then 14

; 46	; want to be 46 here

	; beam is at proper place
	sta	RESP0							; 3
	; 50 (GPU=120, want ??) +?
	sta	RESP1							; 3
	; 53 (GPU=129, want ??) +?

; 52

	; set color of sprite

	lda	#$0E	; bright white					; 2
	sta	COLUP0	; set sprite color				; 3
	sta	COLUP1	; set sprite color				; 3

; 60

	; set to be 32 adjacent pixels

	lda	#NUSIZ_TWO_COPIES_CLOSE					; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

; 68

	sta	WSYNC							; 3

	;===================
	; now scanline 1
	;===================
; 0
	sta	HMOVE	; adjust fine tune, must be after WSYNC		; 3
	ldx	#6							; 2

	;===================
	; now scanline 1..7
	;===================

scoreloop:
	sta	WSYNC							; 3
									;---

	; Fake values for first four digits?
; 0
	lda	score_ones,X		; load sprite data		; 4+
	sta	GRP0			; 				; 3
; 7
	nop
	lda	#0		; load sprite data			; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
; 14

	inc	TEMP2
	inc	TEMP2
; 24
	inc	TEMP2
	inc	TEMP2
; 34
;	inc	TEMP2
;	inc	TEMP2
; 44
	lda	TEMP2
; 47
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
	rts
