
	;=======================================
	; fireplace stuff

	lda	#$FF
	sta	FIREPLACE_ROW1

	lda	FIREPLACE_ROW1
	sta	TEMP1

	and	#$1
	tax
	lda	fireplace_lookup_reverse,X
	and	#$0F
	ora	#$E0		; restore vertical line
	sta	level_playfield2_right-$400+23
	sta	level_playfield2_right-$400+24
	sta	level_playfield2_right-$400+25

	ror	TEMP1
	lda	TEMP1
	and	#$3
	tax
	lda	fireplace_lookup_normal,X
	sta	level_playfield1_right-$400+23
	sta	level_playfield1_right-$400+24
	sta	level_playfield1_right-$400+25

	ror	TEMP1
	ror	TEMP1
	lda	TEMP1
	and	#$2
	tax
	lda	fireplace_lookup_reverse,X
	sta	level_playfield0_right-$400+23
	sta	level_playfield0_right-$400+24
	sta	level_playfield0_right-$400+25

	ror	TEMP1
	lda	TEMP1
	and	#$3
	tax
	lda	fireplace_lookup_reverse,X
	sta	level_playfield2_left-$400+23
	sta	level_playfield2_left-$400+24
	sta	level_playfield2_left-$400+25

.if 0
	lda	TEMP1
	ror
	ror
	and	#$3
	tax
	lda	fireplace_lookup_normal,X
	sta	level_playfield1_left-$400+23
	sta	level_playfield1_left-$400+24
	sta	level_playfield1_left-$400+25
.endif

	sta	WSYNC



