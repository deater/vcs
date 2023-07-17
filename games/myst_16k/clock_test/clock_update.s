.include "../../../vcs.inc"

clock_update:

	; clear this so we only redraw in main if changed
; 0
	ldy	#$FF							; 2
	sty	FIREPLACE_CHANGED					; 3
	iny								; 2
	sty	EXIT_FIREPLACE						; 3

; 10
	; check if clicked the puzzle in the fireplace last frame

	lda	WAS_CLICKED						; 2
	beq	no_grab_clock						; 2/3

was_grab_clock:
; 14

	; check if button

	lda	POINTER_X						; 3
	cmp	#105							; 2
;	bcs	no_grab_clock		; too far to right		; 2/3
; 21
;	cmp	#5			; is a button, skip ahead	; 2
	bcc	not_clock_button					; 2/3


clock_button:
; 25
	inc	EXIT_FIREPLACE						; 5
	bne	no_grab_clock			; bra			; 3

not_clock_button:

; 26

	; see if left or right valve

	lda	POINTER_X				; 3
	cmp	#80
	bcs	clock_right_valve

clock_left_valve:
	inc	CLOCK_HOURS
	sec
	lda	CLOCK_HOURS
	sbc	#12
	bmi	done_clock_adjust
	sta	CLOCK_HOURS
	jmp	done_clock_adjust

clock_right_valve:
	inc	CLOCK_MINUTES

	sec
	lda	CLOCK_MINUTES
	sbc	#12
	bmi	done_clock_adjust
	sta	CLOCK_MINUTES

done_clock_adjust:

;	ldy	#SFX_CLICK				; 2
;	sty	SFX_PTR					; 3

	nop
	lda	$80

; 76

no_grab_clock:
	sta	WSYNC

; 15 / 22 / 33 / 76


	;==========================
	; update clock if changed

update_clock_face:

; 0
	ldx	FIREPLACE_CHANGED				; 3
	bmi	done_update_clock_face			; 2/3

; 5


done_update_clock_face:
	sta	WSYNC
	sta	WSYNC
skipped_most:


	;=================================
	; check for correct answer

	; correct answer is 2:40

	; answer is $FF if match?

	ldx	#0
	lda	CLOCK_HOURS
	cmp	#2
	bne	clock_wrong
	lda	CLOCK_MINUTES
	cmp	#8
	bne	clock_wrong
	dex
clock_wrong:
	stx	FIREPLACE_CORRECT				; 3

	rts

