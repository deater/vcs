	;=========================
	;=========================
	; draw timer bar
	;=========================
	;=========================
	; we want to draw it 4 high
	; we have 9 scanlines to manage this

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

	dec	TIME
	bpl	time_the_same

	; if here ran out of time
	lda	#20
	sta	TIME
	inc	LEVEL_OVER

time_the_same:


	sta	WSYNC

	lda	#$30	; red
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

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	lda	#$0
	sta	COLUPF	; playfield
	sta	COLUBK	; background

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	rts

