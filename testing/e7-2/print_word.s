	;============================================
	;============================================
	; print_word (? scanlines)
	;============================================
	;============================================

	; comes in +6 from a jsr

	; based on DIGIT_DATA in zero page

print_word:
	stx	INL
	sty	OUTL

	jsr	center_string


	; now scanline+1 + 9 cycles

	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

	lda	#0
	sta	INH
	sta	OUTH

	ldx	#6							; 2


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
	; note: starting from bottom
	; original code hard-coded zeros here


	lda	(INL),Y			; load sprite data		; 5+
	sta	GRP0			; 				; 3
; 15
	lda	(OUTL),Y		; load sprite data			; 5+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
; 22

	; originally code to draw number to playfield was here

	lda	$80	; nop 3						; 3
	nop								; 2

	nop
	nop
	nop
	nop
	nop


;	lda	$80							; 3
;	lda	LEVEL_SPRITE0,X						; 4
;	sta	PF0 							; 3

; 37

	; need to write GRP0 at 44-47
;	lda	DIGIT2_DATA_0,X		; load sprite data		; 4
;	ldy	DIGIT3_DATA_0,X						; 4

; 45

;	sta	GRP0			;				; 3
	; write at 48!!
;	sty	GRP1			;				; 3
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

	rts

