
init_game:

	lda	#$89		; BCD
	sta	SCORE_HIGH

	lda	#$67		; BCD
	sta	SCORE_LOW

	lda	#$80
	sta	ZAP_COLOR

	lda	#3
	sta	MANS

	rts
