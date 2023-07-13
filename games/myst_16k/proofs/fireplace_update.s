fireplace_update:

	ldy	#5			; row

fireplace_update_loop:
	lda	FIREPLACE_ROW1,Y
	eor	#$FF			; temp hack

	sta	TEMP1

	and	#$1
	tax
	lda	fireplace_lookup_reverse,X
	and	#$0F
	ora	#$E0		; restore vertical line
	sta	FIREPLACE_C0_R0,Y

	ror	TEMP1
	lda	TEMP1
	and	#$3
	tax
	lda	fireplace_lookup_normal,X
	sta	FIREPLACE_C1_R0,Y

	ror	TEMP1
	ror	TEMP1
	lda	TEMP1
	and	#$2
	tax
	lda	fireplace_lookup_reverse,X
	sta	FIREPLACE_C2_R0,Y

	ror	TEMP1
	lda	TEMP1
	and	#$3
	tax
	lda	fireplace_lookup_reverse,X
	sta	FIREPLACE_C3_R0,Y

	lda	TEMP1
	ror
	ror
	and	#$3
	tax
	lda	fireplace_lookup_normal,X
	sta	FIREPLACE_C4_R0,Y

	dey
	bpl	fireplace_update_loop

	rts

fireplace_lookup_normal:
        .byte $FF,$F1,$1F,$11
;       .byte $88,$8F,$F8,$FF

fireplace_lookup_reverse:
        .byte $88,$F8,$8F,$88
