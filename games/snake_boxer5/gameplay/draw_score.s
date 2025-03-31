	;============================================
	;============================================
	; draw Score (9 scanlines)
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
	lda	#$F0		; = right ?				; 2
	sta	HMP0		; sprite0 fine tune			; 3
	lda	#$00		; = right ?				; 2
	sta	HMP1		; sprit1 fine tune			; 3

; 21
	lda	#$1							; 2
	sta	VDELP0		; turn on delay	sprite0			; 3
	sta	VDELP1		; turn on delay sprite1			; 3

; 29
	inc	TEMP1		; nop5					; 5
	nop
	nop

	; (5*X)-1 each time through
	;	so if X=3 then 14

; 38	; want to be 41+44 here

	; beam is at proper place
	sta	RESP0							; 3
	; 41
	sta	RESP1							; 3
	; 44

; 52

	; set color of sprite

	lda	#$0E	; bright white					; 2
	sta	COLUP0	; set sprite color				; 3
	sta	COLUP1	; set sprite color				; 3

; 60

	; set to be 32 adjacent pixels

	lda	#NUSIZ_THREE_COPIES_CLOSE				; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

; 68

	sta	WSYNC							; 3

; 0
	;===================
	; now scanline 1
	;===================

	sta	HMOVE	; adjust fine tune, must be after WSYNC		; 3
	ldx	#8							; 2
	stx	TEMP2							; 3

	sta	WSYNC							; 3

	;===================
	; now scanline 2..10
	;===================


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
;	lda	ko_sprite5,X						; 4+
	lda	a:SCORE_SPRITE_LOW_0,X
	sta	TEMP1			;				; 3
; 28
	lda	ko_sprite4,X						; 4+
	tay				;				; 2
; 34
	lda	ko_sprite3,X						; 4+
	ldx	a:TEMP1							; 4

; 42
	sta	a:GRP1			;				; 4
; 46
	sty	GRP0			;				; 3
; 49
	stx	GRP1							; 3
; 52
	sty	GRP0							; 3
; 55
	inc	TEMP1		; nop5
	inc	TEMP1		; nop5
; 65
	ldx	TEMP2							; 3
	dex								; 2
	stx	TEMP2							; 3
; 73
	bpl	scoreloop						; 2/3

	; aim for 76 if no WSYNC


	; 75 if fell through
; 75
	;
	; done drawing score
	;
	; turn off sprites

;	ldy	#0							; 2
;	sty	GRP1							; 3
;	sty	GRP0							; 3
; 68

;	sta	WSYNC
; 71
	; cycle 75 of scanline 10



