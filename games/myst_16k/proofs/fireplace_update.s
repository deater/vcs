fireplace_update:

	; clear this so we only redraw in main if changed
; 0
	lda	#$FF							; 2
	sta	FIREPLACE_CHANGED					; 3
	lda	#$00							; 2
	sta	EXIT_FIREPLACE						; 3

; 10
	; grabbed the puzzle in the fireplace last frame

	lda	WAS_CLICKED						; 2
	beq	no_grab_fireplace					; 2/3

was_grab_fireplace:
; 14
	lda	POINTER_X						; 3
	cmp	#136							; 2
	bcs	no_grab_fireplace	; too far to right		; 2/3
; 21
	cmp	#5			; is a button, skip ahead	; 2
	bcs	not_fireplace_button					; 2/3


fireplace_button:
; 25
	inc	EXIT_FIREPLACE						; 5
	bne	no_grab_fireplace		; bra			; 3

not_fireplace_button:

; 26

	; calculate row

	sec						; 2
	lda	POINTER_Y				; 3
	sbc	#23					; 2
	lsr						; 2
	lsr						; 2
	tax						; 2

	stx	FIREPLACE_CHANGED			; 3
; 42

	; calculate column

	sec						; 2
	lda	#135					; 2
	sbc	POINTER_X				; 3
	lsr						; 2
	lsr						; 2
	lsr						; 2
	lsr						; 2
	tay						; 2

	; update matrix

	lda	powers_of_two,Y				; 4
	eor	FIREPLACE_ROW1,X			; 4
	sta	FIREPLACE_ROW1,X			; 4
; 71

;	ldy	#SFX_CLICK				; 2
;	sty	SFX_PTR					; 3

	nop
	lda	$80


; 76

no_grab_fireplace:
; 15 / 22 / 33 / 76


	;==========================
	; update row if changed

update_fireplace_row:

; 0
	ldx	FIREPLACE_CHANGED				; 3
	bmi	done_update_fireplace_row			; 2/3

; 5

	lda	FIREPLACE_ROW1,X				; 4
	sta	TEMP1						; 3
; 12
	; bit 0 (rightmost)

	and	#$1						; 2
	asl							; 2
	tay							; 2
	lda	fireplace_lookup_reverse,Y			; 4
	and	#$0F						; 2
	ora	#$E0		; restore vertical line		; 2
	sta	FIREPLACE_C4_R0					; 3
; 29

	; bit 2+1

	ror	TEMP1						; 3
	lda	TEMP1						; 3
	and	#$3						; 2
	tay							; 2
	lda	fireplace_lookup_normal,Y			; 4
	sta	FIREPLACE_C3_R0					; 3
; 46

	; bit 3

	ror	TEMP1						; 3
	ror	TEMP1						; 3
	lda	TEMP1						; 3
	and	#$1						; 2
	tay							; 2
	lda	fireplace_lookup_reverse,Y			; 4
	sta	FIREPLACE_C2_R0					; 3
; 66

	; bit 5+4

	ror	TEMP1						; 3
	lda	TEMP1						; 3
	and	#$3						; 2
	tay							; 2
	lda	fireplace_lookup_reverse,Y			; 4
	sta	FIREPLACE_C1_R0					; 3

; 83

	; bit 7+6

	lda	TEMP1						; 3
	ror							; 2
	ror							; 2
	and	#$3						; 2
	tay							; 2
	lda	fireplace_lookup_normal,Y			; 4
	sta	FIREPLACE_C0_R0					; 3
; 101

done_update_fireplace_row:

	;=================================
	; check for correct answer

	; correct answer
	; C3 6B A3 93 CC FA

	; all wrong = 5-1+(6*16) = 100
	; all right = 5-1+(6*20) = 124

	; answer is $FF if match?

	ldx	#5						; 2
	stx	FIREPLACE_CORRECT				; 3
; 5
check_fireplace_loop:
	lda	FIREPLACE_ROW1,X				; 4
	cmp	fireplace_solution,X				; 4
	bne	not_the_combination				; 2/3
	dec	FIREPLACE_CORRECT				; 5
not_the_combination:
	dex							; 2
	bpl	check_fireplace_loop				; 2/3

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
