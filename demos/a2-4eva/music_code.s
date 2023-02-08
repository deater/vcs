
	;========================
	; music
play_music:
	dec	MUSIC_COUNTDOWN			; countdown current count
	bpl	music_ok

	ldx	MUSIC_POINTER			; get pointer
	inx					; increment

	txa					; mask at 16
	and	#$f
	sta	MUSIC_POINTER

	lsr
	bcc	sound_off

	lda	#$d
	bne	do_sound
sound_off:
	lda	#0
do_sound:
	sta	AUDV0		; volume

	dex

	lda	music_len,X			; get countdown
	sta	MUSIC_COUNTDOWN

	lda	#$f				; always buzz
	sta	AUDC0		; audio control

	lda	#$9e				; always deep buzz
	sta	AUDF0		; freq divider

music_ok:

delay_12:
	rts
