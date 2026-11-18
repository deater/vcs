	;=======================================================
	;=======================================================
	; setup frame 1
	;=======================================================
	;=======================================================
setup_bounce_1:
	;=============================
	jsr	common_vblank
; 9
	;================================
	; play music -- scanlines 0..10
	;================================
        ; takes 11 lines?

	lda	#1		; our bank
	jsr	do_play_music
	sta	WSYNC

	;=========================== now 11

	ldx	#37-11
	jsr	repeat_wsync

	;============================ now 0

	ldx	#191
	jsr	repeat_wsync

	;=========================== now 191

	lda	#0
	sta	EFFECTL
	sta	EFFECTH
	sta	WHICH_EFFECT


	sta	WSYNC

	;=========================== now 192

	ldx	#29
	jsr	common_overscan

	; debug
;	jmp	setup_bounce_1



