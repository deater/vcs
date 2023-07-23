
fireplace_update:

	; clear this so we only redraw in main if changed
; 0
	ldy	#$FF							; 2
	sty	FIREPLACE_CHANGED					; 3
	iny								; 2
	sty	EXIT_FIREPLACE						; 3

; 10
	; check if clicked the puzzle in the fireplace last frame

	lda	WAS_CLICKED						; 2
	beq	no_grab_fireplace					; 2/3

was_grab_fireplace:
; 14
	lda	POINTER_X						; 3
	cmp	#136							; 2
	bcs	no_grab_fireplace	; too far to right		; 2/3
; 21
	cmp	#9			; is a button, skip ahead	; 2
	bcs	not_fireplace_button					; 2/3

	cmp	#5			; less likely to press
	bcs	no_grab_fireplace	; button by mistake

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

	; used when updating screen
	stx	FIREPLACE_CHANGED			; 3
; 42

	; calculate column

	; minimum is 5?

	;					should be
	; $5 - $15 = 7		5 - 21         127 - 112
	; $16-$25  = 6		22 - 37	       111 - 96
	; $7c-$8b  = 0		123 - 139	15  - 0

	; $5, $16, $27, $38, $49, $5A, $6B, $7C

	; 0123456789012345678901234567890123456789
	; MMMM*** *** *** *** *** *** *** ***MMMMM

	; hand=10 wide
	; 7 = 16-31, -2, 14-29	4 - 19
	; 6 = 32-47, -2, 30-45	20- 35
	;...
	; 0 = 128-143, -2, 126-141  116-131
	sec						; 2
	lda	#136					; 2
	sbc	POINTER_X				; 3
	lsr						; 2
	lsr						; 2
	lsr						; 2
	lsr						; 2
	tay						; 2
; 59
	; update matrix

	lda	powers_of_two,Y				; 4
	eor	FIREPLACE_ROW1,X			; 4
	sta	FIREPLACE_ROW1,X			; 4
; 71

	ldy	#SFX_CLICK				; 2
	sty	SFX_PTR					; 3

	jmp	extra_delay				; 3

; 76

no_grab_fireplace:
	sta	WSYNC
extra_delay:
	sta	WSYNC

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
	jmp	skipped_most

done_update_fireplace_row:
	sta	WSYNC
	sta	WSYNC
skipped_most:


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

	; debug
;	nop
;	nop
	bne	not_the_combination				; 2/3
	dec	FIREPLACE_CORRECT				; 5
not_the_combination:
	dex							; 2
	bpl	check_fireplace_loop				; 2/3

	rts							; 6

fireplace_lookup_normal:
        .byte $FF,$F1,$1F,$11

fireplace_lookup_reverse:
        .byte $FF,$8F,$F8,$88

fireplace_solution:
.byte	$C3,$6B,$A3,$93,$CC,$FA
