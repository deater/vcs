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

	lda	#3		; our bank
	jsr	do_play_music
	sta	WSYNC

	;=========================== now 11

	ldx	#37-11
	jsr	repeat_wsync

	;============================ now 0


	ldx	#0
	stx	EFFECTL
	stx	EFFECTH
	stx	WHICH_EFFECT

	stx	VDELP0
	stx	VDELP1

	ldx	#192
	jsr	repeat_wsync

	;=========================== now 192

	ldx	#29
	jsr	common_overscan

	; debug
;	jmp	setup_title_1

