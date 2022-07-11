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


	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	lda	#$1E
	sta	COLUPF	; playfield
	lda	#$30
	sta	COLUBK	; background

	lda	TIMEBAR0
	sta	PF0
	lda	TIMEBAR1
	sta	PF1
	lda	TIMEBAR2
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

	rts

update_timer_bar:

	lda	#$ff							; 2
	sta	TIMEBAR0						; 3
	sta	TIMEBAR1						; 3
	sta	TIMEBAR2						; 3

	rts
