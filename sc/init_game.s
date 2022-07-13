
init_game:

	lda	#$89		; BCD
	sta	SCORE_HIGH

	lda	#$67		; BCD
	sta	SCORE_LOW

	lda	#$90
	sta	ZAP_BASE

	lda	#3
	sta	MANS

	rts
