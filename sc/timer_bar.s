	;=========================
	;=========================
	; draw timer bar (6 scanlines)
	;=========================
	;=========================
	; we want to draw it 4 high
	; we have 6 scanlines to manage this


draw_timer_bar:
; 0
	; already 6 cycles in
	; set color to black/black

	lda	#$0							; 2
	sta	COLUPF	; playfield					; 3
	sta	COLUBK	; background					; 3
	sta	TRIGGER_SOUND						; 3
; 11
	; set playfield to mirrored
	lda	#CTRLPF_REF	; reflect playfield			; 2
	sta	CTRLPF							; 3
; 16
	dec	TIME_SUBSECOND	; count down				; 5
; 21
	bne	time_the_same						; 2/3
; 23
	; hit 0

	lda	#59							; 2
	sta	TIME_SUBSECOND						; 3

	lda	TIME							; 3
	cmp	#4							; 2
; 33
	bcs	time_not_low						; 2/3
; 35
	ldy	#SFX_PING						; 2
	sty	TRIGGER_SOUND						; 3
; 40

time_not_low:
; 36 / 40
	dec	TIME							; 5
; 41 / 45
	bpl	time_the_same						; 2/3
; 43 / 47
	; if here ran out of time
	lda	#20							; 2
	sta	TIME							; 3
	lda	#LEVEL_OVER_TIME					; 2
	sta	LEVEL_OVER						; 3

time_the_same:
; 24 / 44 / 48 / 53 / 57

	sta	WSYNC

	;=======================
	; timer bar scanline 1

; 0
	lda	#$32	; red						; 2
	sta	COLUPF	; playfield					; 3
	lda	#$1E	; yellow					; 2
	sta	COLUBK	; background					; 3
; 10

	ldx	TIME							; 3
	lda	bargraph_lookup_p0,X					; 4
	sta	PF0							; 3
	lda	bargraph_lookup_p1,X					; 4
	sta	PF1							; 3
	lda	bargraph_lookup_p2,X					; 4
	sta	PF2							; 3
; 34
	sta	WSYNC	; 4 lines high

	;=======================
	; timer bar scanline 2

	sta	WSYNC

	;=======================
	; timer bar scanline 3

	sta	WSYNC

	;=======================
	; timer bar scanline 4

	; shadow
	lda	#$30	; darker red					; 2
	sta	COLUPF	; playfield					; 3
	lda	#$1A	; darker yellow					; 2
	sta	COLUBK	; background					; 3
; 10
	sta	WSYNC

	;=======================
	; timer bar scanline 5

	lda	#$0							; 2
	sta	COLUPF	; playfield					; 3
	sta	COLUBK	; background					; 3

	ldy	TRIGGER_SOUND						; 3
	beq	skip_timer_sound					; 2/3
	jsr	trigger_sound						; 6+40
skip_timer_sound:
	sta	WSYNC

	;=======================
	; timer bar scanline 6
