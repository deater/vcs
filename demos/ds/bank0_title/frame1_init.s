	;=======================================================
	;=======================================================
	; setup frame 1
	;=======================================================
	;=======================================================
setup_title_1:
	;=============================
	jsr	common_vblank
; 9
	;================================
	; play music -- scanlines 0..10
	;================================
        ; takes 11 lines?

	lda	#0		; our bank
	jsr	do_play_music
	sta	WSYNC

	;=========================== now 11

	ldx	#37-11-4
	jsr	common_overscan

	;============================ now 0

	lda	#<desire3_colors_fg
	sta	INL
	lda	#>desire3_colors_fg
	sta	INH
	ldx	#0
	jsr	copy_to_256_84

	;============================ now 20

	lda	#<desire2_colors_fg
	sta	INL
	lda	#>desire2_colors_fg
	sta	INH
	ldx	#1
	jsr	copy_to_256_84

	;============================ now 40

	lda	#<desire1_colors_fg
	sta	INL
	lda	#>desire1_colors_fg
	sta	INH
	ldx	#2
	jsr	copy_to_256_84

	;============================ now 60

	lda	#<desire1_colors_fg
	sta	INL
	lda	#>desire1_colors_fg
	sta	INH
	ldx	#3
	jsr	copy_to_256_84

	;============================ now 80

	; not sure why extra 2

	inc	FIRST_TIME
	ldx	#192-80-2
	jsr	repeat_wsync

	;=========================== now 192

	ldx	#29
	jsr	common_overscan

	; debug
;	jmp	setup_title_1



