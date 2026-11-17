	; comes in at unknown cycles, w/o last WSYNC


setup_credits_2:
	;=============================
	jsr	common_vblank
; 9
	;================================
	; play music -- scanlines 0..10
	;================================
        ; takes 11 lines?

	lda	#5		; our bank
	jsr	do_play_music
	sta	WSYNC

	;============================ now 11

	sta	E7_SET_256_BANK0
	sta	WSYNC			; reserve room to clear stuff

	;============================ now 12

	jsr	clear_to_black	; 34 scanlines

	;============================ now 46

	lda	#<code_string
	sta	INL
	lda	#>code_string
	sta	INH
	lda	#0
	jsr	print_string

	;============================ now 71

	lda	#<deater_string
	sta	INL
	lda	#>deater_string
	sta	INH
	lda	#10
	jsr	print_string

	;============================ now 96

	lda	#<music_string
	sta	INL
	lda	#>music_string
	sta	INH
	lda	#22
	jsr	print_string

	;============================ now 121

	lda	#<miker_string
	sta	INL
	lda	#>miker_string
	sta	INH
	lda	#32
	jsr	print_string

	;============================ now 146

	ldx	#42+37
	jsr	repeat_wsync

	;=========================== now 192

	ldx	#29
	jsr	common_overscan

	; debug
;	jmp	setup_credits_1

