
init_game:

	lda	#$00		; BCD
	sta	SCORE_HIGH

	lda	#$00		; BCD
	sta	SCORE_LOW

	lda	#$90
	sta	ZAP_BASE

	lda	#3
	sta	MANS

	lda	#1
	sta	LEVEL

	jsr	disable_sound

	rts
