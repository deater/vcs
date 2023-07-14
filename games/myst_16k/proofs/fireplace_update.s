fireplace_update:

	lda	#$FF
	sta	FIREPLACE_CHANGED

	; grabbed the puzzle in the fireplace

	lda	WAS_CLICKED
	beq	no_grab_fireplace

was_grab_fireplace:

	lda	POINTER_X
	cmp	#136
	bcs	no_grab_fireplace		; too far to right

	cmp	#5				; is a button, skip ahead
	bcs	not_fireplace_button

	; correct answer
	; C3 6B A3 93 CC FA

	ldx	#0
	stx	FIREPLACE_CORRECT
check_fireplace_loop:
	lda	FIREPLACE_ROW1,X
	cmp	fireplace_solution,X
	bne	not_the_combination
	inc	FIREPLACE_CORRECT
not_the_combination:
	inx
	cpx	#6
	bne	check_fireplace_loop

	beq	no_grab_fireplace	; bra


not_fireplace_button:


	; calculate row

	sec						; 2
	lda	POINTER_Y				; 3
	sbc	#23					; 2
	lsr						; 2
	lsr						; 2
	tax						; 2

	stx	FIREPLACE_CHANGED

	; calculate column

	sec
	lda	#135
	sbc	POINTER_X
	lsr
	lsr
	lsr
	lsr
	tay
	lda	powers_of_two,Y
	eor	FIREPLACE_ROW1,X
	sta	FIREPLACE_ROW1,X


;	ldy	#SFX_CLICK
;	sty	SFX_PTR

no_grab_fireplace:



	; update background data

;	ldy	#5			; row

	ldy	FIREPLACE_CHANGED

;fireplace_update_loop:
	lda	FIREPLACE_ROW1,Y
;	eor	#$FF			; temp hack

	sta	TEMP1

	; bit 0 (rightmost)

	and	#$1
	asl
	tax
	lda	fireplace_lookup_reverse,X
	and	#$0F
	ora	#$E0		; restore vertical line
	sta	FIREPLACE_C4_R0

	; bit 2+1

	ror	TEMP1
	lda	TEMP1
	and	#$3
	tax
	lda	fireplace_lookup_normal,X
	sta	FIREPLACE_C3_R0

	; bit 3

	ror	TEMP1
	ror	TEMP1
	lda	TEMP1
	and	#$1
	tax
	lda	fireplace_lookup_reverse,X
	sta	FIREPLACE_C2_R0

	; bit 5+4

	ror	TEMP1
	lda	TEMP1
	and	#$3
	tax
	lda	fireplace_lookup_reverse,X
	sta	FIREPLACE_C1_R0

	; bit 7+6

	lda	TEMP1
	ror
	ror
	and	#$3
	tax
	lda	fireplace_lookup_normal,X
	sta	FIREPLACE_C0_R0

;	dey
;	bpl	fireplace_update_loop

	rts

fireplace_lookup_normal:
        .byte $FF,$F1,$1F,$11

fireplace_lookup_reverse:
        .byte $FF,$8F,$F8,$88


; FIXME: use common one
powers_of_two:
.byte   $01,$02,$04,$08, $10,$20,$40,$80

fireplace_solution:
.byte	$C3,$6B,$A3,$93,$CC,$FA
