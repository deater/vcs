	;============================================
	;============================================
	; print_string
	;============================================
	;============================================

	; Y is which string to use

	; comes in +6 from a jsr

print_string:

	; in theory doesn't touch Y?

	jsr	center_string

	; now +1 scanline + 9 cycles


	lda	string_table_l,Y
	sta	INL

	lda	string_table_h,Y
	sta	INH


	; set to be 32 adjacent pixels
; 9
	lda	#NUSIZ_TWO_COPIES_CLOSE					; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3
; 17
	; set up loop vars

	ldx	#6							; 2
	ldy	#0							; 2
; 21


	;===================
	; now scanline 1..7
	;===================

stringloop:
	sta	WSYNC							; 3

; 0
	; note: starting from bottom
	; original code hard-coded zeros here


	lda	(INL),Y		; load sprite data			; 5+
	sta	GRP0			; 				; 3
; 8
	iny								; 2
; 10
	lda	(INL),Y		; load sprite data			; 5+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	iny								; 2
; 20

; 20
	; need to write GRP0 at 44-47
	lda	(INL),Y		; load sprite data			; 5+
	sta	TEMP							; 3
	iny								; 2
; 30
	lda	(INL),Y							; 5+
	iny								; 2
; 37
	sty	TEMPY							; 3
	tay								; 2
	lda	TEMP							; 3
; 45

	sta	GRP0			;				; 3
	; write at 48!!
	sty	GRP1			;				; 3
	; wrote at 51

	ldy	TEMPY							; 3

	dex								; 2
	bpl	stringloop						; 2/3
	; aim for 76 if no WSYNC

	; 55 if fell through
; 55
	;
	; done drawing score
	;

;	inc	TEMP1							; 5

; 60
	; turn off sprites

	ldy	#0							; 2
	sty	GRP1							; 3
	sty	GRP0							; 3
; 68
	sta	WSYNC
; 71

	rts

