.include "../../../vcs.inc"

; optimization history

;	E9 -- original code
;	E2 -- after removing some unneeded stuff
;	D7 -- make hand movement single path rather than two
;	CA -- re-write sprite lookup and overlap zeros in sprite data
;	BD -- re-arrange sprites
;	B9 -- optimize correctness check to subtract

clock_update:

	; clear this so we only redraw in main if changed
; 0
	ldx	#0							; 2
	stx	EXIT_FIREPLACE						; 3

; 5
	; check if clicked the puzzle in the last frame

	lda	WAS_CLICKED						; 2
	beq	no_grab_clock						; 2/3

was_grab_clock:
; 9
	; check if button

	lda	POINTER_X						; 3
	cmp	#105							; 2
	bcc	not_clock_button					; 2/3


clock_button:
; 16
	inc	EXIT_FIREPLACE						; 5
	bne	no_grab_clock			; bra			; 3

not_clock_button:

; 17

	; see if left or right valve

	; POINTER_X already in A
	; X is 0 from earlier
;	ldx	#0			; default to left		; 2
	cmp	#80							; 2
	bcs	clock_right_valve					; 2/3

clock_left_valve:
	inx								; 2

clock_right_valve:

; 14/15
	inc	CLOCK_HOURS,X						; 6
	sec								; 2
	lda	CLOCK_HOURS,X						; 4
	sbc	#12							; 2
; 28/29
	bmi	done_clock_adjust					; 2/3
	sta	CLOCK_HOURS,X						; 4

done_clock_adjust:

	ldy	#SFX_CLICK						; 2
	sty	SFX_PTR							; 3

;	nop
;	lda	$80

no_grab_clock:
	sta	WSYNC							; 3

; 13 / 24 / 44 worst case


	;==========================
	; update clock

update_clock_face:

; 0
	lda	#>clock_hands_start
	sta	INH
	ldx	CLOCK_MINUTES
	lda	clock_hand_lookup,X
	sta	INL

	ldy	#8
copy_clock_loop:
	lda	(INL),Y
	sta	CLOCKFACE_0,Y
	dey
	bpl	copy_clock_loop


	ldx	CLOCK_HOURS
	lda	clock_hand_lookup,X
	sta	INL

	ldy	#7			; start 1 off to trim length
copy_clock_hours:
	lda	(INL),Y
	and	#$1C			; trim width
	ora	CLOCKFACE_0,Y		; merge with minute hand
	sta	CLOCKFACE_0,Y
	dey
	bne	copy_clock_hours


; 0
;	lda	CLOCK_MINUTES
;	asl
;	asl
;	asl
;	clc
;	adc	CLOCK_MINUTES
;	tay
;	ldx	#0
;copy_clock_loop:
;	lda	clock_12,Y
;	sta	CLOCKFACE_0,X
;	inx
;	iny
;	cpx	#9
;	bne	copy_clock_loop


;	lda	CLOCK_HOURS
;	asl
;	asl
;	asl
;	clc
;	adc	CLOCK_HOURS
;	tay

;	ldx	#1
;copy_clock_hours:
;	lda	clock_12+1,Y
;	and	#$1C
;	ora	CLOCKFACE_0,X
;	sta	CLOCKFACE_0,X
;	inx
;	iny
;	cpx	#8
;	bne	copy_clock_hours


done_update_clock_face:
	sta	WSYNC

	;=================================
	; check for correct answer

	; correct answer is 2:40
	;			$2/$8

	; answer is $FF if match?

	; 15

;	ldx	#0
;	lda	CLOCK_HOURS
;	cmp	#2
;	bne	clock_wrong
;	lda	CLOCK_MINUTES
;	cmp	#8
;	bne	clock_wrong
;	dex
;clock_wrong:
;	stx	FIREPLACE_CORRECT				; 3

	sec
	lda	#8
	sbc	CLOCK_MINUTES
	bne	not_correct
	lda	#2
	sbc	CLOCK_HOURS
not_correct:
	sta	FIREPLACE_CORRECT

	rts

	; note, the clock data can't cross a page boundary
	; this avoids a multiply by 9
clock_hand_lookup:
	.byte	<clock_12,<clock_1,<clock_2,<clock_3
	.byte	 <clock_4,<clock_5,<clock_6,<clock_7
	.byte	 <clock_8,<clock_9,<clock_10,<clock_11


; un-overlapped: 9*12 = 108 bytes
; overlapped in order:   88 bytes
; re-arrange:	  	 76 bytes

clock_hands_start:

clock_8:
	.byte $00,$00,$00,$00,$08
	.byte $10,$20;,$00,$00
clock_5:
	.byte $00,$00,$00,$00,$08
	.byte $08,$04,$04;,$00
clock_1:
	.byte $00,$04,$04,$08,$08
	.byte $00,$00;,$00,$00
clock_2:
	.byte $00,$00,$02,$04,$08
;	.byte $00,$00,$00,$00
clock_9:
	.byte $00,$00,$00,$00,$38
;	.byte $00,$00,$00,$00
clock_6:
	.byte $00,$00,$00,$00;,$08
;	.byte $08,$08,$08,$08
clock_12:
	.byte $08,$08,$08,$08,$08
;	.byte $00,$00,$00,$00
clock_3:
	.byte $00,$00,$00,$00,$0E
;	.byte $00,$00,$00,$00
clock_4:
	.byte $00,$00,$00,$00,$08
	.byte $04,$02;,$00,$00
clock_10:
	.byte $00,$00,$20,$10,$08
;	.byte $00,$00,$00,$00
clock_7:
	.byte $00,$00,$00,$00,$08
	.byte $08,$10,$10;,$00
clock_11:
	.byte $00,$10,$10,$08,$08
	.byte $00,$00,$00,$00

.if 0

; in order

clock_12:
	.byte $08,$08,$08,$08,$08
	.byte $00,$00,$00;,$00
clock_1:
	.byte $00,$04,$04,$08,$08
	.byte $00,$00;,$00,$00
clock_2:
	.byte $00,$00,$02,$04,$08
;	.byte $00,$00,$00,$00
clock_3:
	.byte $00,$00,$00,$00,$0E
;	.byte $00,$00,$00,$00
clock_4:
	.byte $00,$00,$00,$00,$08
	.byte $04,$02;,$00,$00
clock_5:
	.byte $00,$00,$00,$00,$08
	.byte $08,$04,$04;,$00
clock_6:
	.byte $00,$00,$00,$00,$08
	.byte $08,$08,$08,$08
clock_7:
	.byte $00,$00,$00,$00,$08
	.byte $08,$10,$10;,$00
clock_8:
	.byte $00,$00,$00,$00,$08
	.byte $10,$20;,$00,$00
clock_9:
	.byte $00,$00,$00,$00,$38
	.byte $00,$00;,$00,$00
clock_10:
	.byte $00,$00,$20,$10,$08
	.byte $00,$00,$00;,$00
clock_11:
	.byte $00,$10,$10,$08,$08
	.byte $00,$00,$00,$00

.endif
