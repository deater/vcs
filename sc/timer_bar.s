	;=========================
	;=========================
	; draw timer bar (6 scanlines)
	;=========================
	;=========================
	; we want to draw it 4 high
	; we have 6 scanlines to manage this

draw_timer_bar:
	; already 6 cycles in
	; set color to black/black

	lda	#$0
	sta	COLUPF	; playfield
	sta	COLUBK	; background

	; set playfield to mirrored
	lda	#CTRLPF_REF	; reflect playfield
	sta	CTRLPF

	dec	TIME_SUBSECOND	; count down
	bne	time_the_same

	; hit 0

	lda	#59
	sta	TIME_SUBSECOND

	lda	TIME
	cmp	#4
	bcs	time_not_low

	ldy	#SFX_PING
;	sta	SOUND_TO_PLAY
	jsr	trigger_sound

time_not_low:

	dec	TIME
	bpl	time_the_same

	; if here ran out of time
	lda	#20
	sta	TIME
	lda	#LEVEL_OVER_TIME
	sta	LEVEL_OVER

time_the_same:


	sta	WSYNC

	lda	#$32	; red
	sta	COLUPF	; playfield
	lda	#$1E	; yellow
	sta	COLUBK	; background

	ldx	TIME

	lda	bargraph_lookup_p0,X
	sta	PF0
	lda	bargraph_lookup_p1,X
	sta	PF1
	lda	bargraph_lookup_p2,X
	sta	PF2

	sta	WSYNC	; 4 lines high
	sta	WSYNC
	sta	WSYNC

	; shadow
	lda	#$30	; darker red
	sta	COLUPF	; playfield
	lda	#$1A	; darker yellow
	sta	COLUBK	; background

	sta	WSYNC

	lda	#$0
	sta	COLUPF	; playfield
	sta	COLUBK	; background

	sta	WSYNC



