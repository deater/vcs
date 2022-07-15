
init_game:

	lda	#$00		; BCD
	sta	SCORE_HIGH
	sta	SCORE_LOW
;	sta	DONE_TITLE

	lda	#$90
	sta	ZAP_BASE

	lda	#1
	sta	MANS

	lda	#1
	sta	LEVEL

	jsr	disable_sound

	rts
