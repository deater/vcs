
; optimization history

;	E9 -- original code
;	E2 -- after removing some unneeded stuff
;	D7 -- make hand movement single path rather than two
;	CA -- re-write sprite lookup and overlap zeros in sprite data
;	BD -- re-arrange sprites
;	B9 -- optimize correctness check to subtract

clock_update:

	; clear this so we only redraw in main if changed
; 19
	ldx	#0							; 2
	stx	EXIT_PUZZLE						; 3

; 24
	; check if clicked the puzzle in the last frame

	lda	WAS_CLICKED						; 2
	beq	no_grab_clock						; 2/3

; 28

was_grab_clock:
	; check if button

	lda	POINTER_X						; 3
	cmp	#100		; $64 = 100				; 2
; 33
	bcc	not_clock_button					; 2/3


clock_button:
; 35
	;===========================
	; action button was pressed
	;===========================

	lda	CLOCK_CORRECT		; 0 if correct			; 3
	bne	lower_clock_bridge					; 2/3
raise_clock_bridge:
; 40

	ldy	#SFX_RUMBLE		; play noise			; 2
	sty	SFX_PTR							; 3
; 45
	lda	BARRIER_STATUS						; 3
	ora	#BARRIER_CLOCK_BRIDGE_UP				; 2
	bne	common_clock_bridge	; bra				; 3
; 53

lower_clock_bridge:
; 41
	lda	BARRIER_STATUS
	and	#<(~BARRIER_CLOCK_BRIDGE_UP)

common_clock_bridge:
; 53
	sta	BARRIER_STATUS						; 3
; 56
	inc	EXIT_PUZZLE						; 5
	bne	no_grab_clock			; bra			; 3
; 64

not_clock_button:

; 36
	; see if left or right valve

	; POINTER_X already in A
	; X is 0 from earlier
;	ldx	#0			; default to left		;
	cmp	#76	; $4c						; 2
; 38
	bcs	clock_right_valve					; 2/3

clock_left_valve:
; 40
	inx								; 2

clock_right_valve:
; 41/42

	inc	CLOCK_HOURS,X						; 6
	sec								; 2
	lda	CLOCK_HOURS,X						; 4
	sbc	#12							; 2
; 55/56
	bmi	done_clock_adjust					; 2/3
; 57/58
	sta	CLOCK_HOURS,X						; 4

done_clock_adjust:
; 58/59/61/62
	ldy	#SFX_CLICK						; 2
	sty	SFX_PTR							; 3

no_grab_clock:

; 29 / 63..67 worst case

	sta	WSYNC							; 3




	;==========================
	; update clock

update_clock_face:

; 0
	lda	#>clock_hands_start					; 2
	sta	INH							; 3
	ldx	CLOCK_MINUTES						; 3
	lda	clock_hand_lookup,X					; 4
	sta	INL							; 3
; 15

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

done_update_clock_face:
	sta	WSYNC

	;=================================
	; check for correct answer

	; correct answer is 2:40
	;			$2/$8

	; answer is $FF if match?

; 0
	sec								; 2
	lda	#8							; 2
	sbc	CLOCK_MINUTES						; 3
; 7
	bne	not_correct						; 2/3
; 9
	lda	#2							; 2
	sbc	CLOCK_HOURS						; 3
not_correct:
; 10/ 14
	sta	CLOCK_CORRECT						; 3
; 13 / 17
	rts
; 19, 23 worst case

	; note, the clock data can't cross a page boundary
	; this avoids a multiply by 9
clock_hand_lookup:
	.byte	<clock_12,<clock_1,<clock_2,<clock_3
	.byte	 <clock_4,<clock_5,<clock_6,<clock_7
	.byte	 <clock_8,<clock_9,<clock_10,<clock_11


