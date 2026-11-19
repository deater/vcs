	;=======================================================
	;=======================================================
	; setup frame 1
	;=======================================================
	;=======================================================
setup_credits_1:
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
	sta	E7_SET_256_BANK1
	sta	WSYNC			; reserve room to clear stuff

	;============================ now 12

	jsr	clear_to_black	; 34 scanlines

	;============================ now 46

	lda	#<logo_string
	sta	INL
	lda	#>logo_string
	sta	INH
	lda	#0
	jsr	print_string

	;============================ now 71

	lda	#<hammerfist_string
	sta	INL
	lda	#>hammerfist_string
	sta	INH
	lda	#10
	jsr	print_string

	;============================ now 96

	lda	#<steffest_string
	sta	INL
	lda	#>steffest_string
	sta	INH
	lda	#20
	jsr	print_string

	;============================ now 121

	lda	#<dsr_bolt0
	sta	INL
	lda	#>dsr_bolt0
	sta	INH
	ldx	#2
	jsr	rom_to_256_copy

	;============================ now 171


	; 4 from VSYNC
	; 11 from MUSIC
	; 34 for clear
	; 25*3 for strings
	; 50 for rom cpy

	ldx	#(41+192)-(171)-8
	jsr	repeat_wsync

	;=========================== now 192

	ldx	#29
	jsr	common_overscan

	; debug
;	jmp	setup_credits_1
