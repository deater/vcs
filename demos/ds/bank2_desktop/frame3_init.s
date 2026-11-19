	;=======================================================
	;=======================================================
	; setup frame 3
	;=======================================================
	;=======================================================
setup_desktop_3:
	;=============================
	jsr	common_vblank
; 9
	;================================
	; play music -- scanlines 0..10
	;================================
        ; takes 11 lines?

	lda	#2		; our bank
	jsr	do_play_music
	sta	WSYNC


	;=========================== now 11

	ldx	#37-11
	jsr	repeat_wsync

	;=========================== at line 0

	; now need to copy from 1k RAM to 256-byte RAM

	lda	#2			; bank to return to
	jsr	bank7_to_256_copy


	;=============================== approx 175

	ldx	#191-175
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
;	jmp	setup_desktop_3



