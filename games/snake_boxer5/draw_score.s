	;============================================
	;============================================
	; draw Score (8 scanlines)
	;============================================
	;============================================

	;===================
	; now scanline 0
	;===================
	; center the sprite position
;0
draw_score:
; 0
	lda	#$00							; 2
	sta	COLUBK		; background black			; 3
	sta	REFP0		; no reflect sprite			; 3
	sta	REFP1							; 3

; 11
	lda	#$00		; = right ?				; 2
	sta	HMP0							; 3
	lda	#$10		; = right ?				; 2
	sta	HMP1							; 3

; 21
	inc	TEMP1		; nop5					; 5
	nop								; 2
	nop								; 2
; 30
	inc	TEMP1		; nop5					; 5
;	inc	TEMP1		; nop5					; 5
	nop
;	nop

;	nop								; 2

	; (5*X)-1 each time through
	;	so if X=3 then 14

; 39	; want to be 39 here

	; beam is at proper place
	sta	RESP0							; 3
	; 42 (GPU=120, want ??) +?
	sta	RESP1							; 3
	; 45 (GPU=129, want ??) +?

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
	ldx	#7							; 2
	stx	TEMP2

	;===================
	; now scanline 1..7
	;===================

	sta	WSYNC							; 3

scoreloop:

; 0
	lda	ko_sprite0,X						; 4+
	sta	GRP0			; 0->[GRP0], [GRP1 (?)]-->GRP1	; 3
; 7
	lda	ko_sprite1,X						; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3

; 14
	lda	ko_sprite2,X						; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
; 21
	lda	ko_sprite5,X						; 4+
	sta	TEMP1			;				; 3
; 28
	lda	ko_sprite4,X						; 4+
	tay				;				; 2
; 34
	lda	ko_sprite3,X						; 4+
	ldx	a:TEMP1							; 4

; 42
	sta	GRP1			;				; 3
; 45
	sty	GRP0			;				; 3
; 48
	stx	GRP1							; 3
; 51
	sty	GRP0							; 3
; 54
	ldx	TEMP2							; 3
	dex								; 2
	stx	TEMP2							; 3
;62

	inc	TEMP1
	nop
	nop
	nop

	bpl	scoreloop						; 2/3

	; aim for 76 if no WSYNC


	; 61 if fell through
; 61
	;
	; done drawing score
	;
	; turn off sprites

	ldy	#0							; 2
	sty	GRP1							; 3
	sty	GRP0							; 3
; 68
	sta	WSYNC
; 71
	; begin of scanline 8
;	rts


