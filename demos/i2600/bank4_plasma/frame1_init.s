	;=======================================================
	;=======================================================
	; setup frame 1
	;=======================================================
	;=======================================================
setup_plasma_1:
	;=============================
	jsr	common_vblank
; 9
	;================================
	; play music -- scanlines 0..10
	;================================
        ; takes 11 lines?

	lda	#4		; our bank
	jsr	do_play_music
	sta	WSYNC

	;=========================== now 11

	ldx	#37-11
	jsr	repeat_wsync

	;============================ now 0

	; load code into RAM

	lda	#<draw_routine1
	sta	INL
	lda	#>draw_routine1
	sta	INH

	ldx	#2
	jsr	rom_to_256_copy

	;============================ now 53

	; load code into RAM

	lda	#<draw_routine1
	sta	INL
	lda	#>draw_routine1
	sta	INH

	ldx	#1
	jsr	rom_to_256_copy

	;============================ now 106

	; load code into RAM

	lda	#<draw_routine1
	sta	INL
	lda	#>draw_routine1
	sta	INH

	ldx	#0
	jsr	rom_to_256_copy


	;============================ now 159

	ldx	#0
	stx	EFFECTL
	stx	EFFECTH
	stx	WHICH_EFFECT

	ldx	#192-154
	jsr	repeat_wsync

	;=========================== now 192

	ldx	#29
	jsr	common_overscan

	; debug
;	jmp	setup_plasma_1
