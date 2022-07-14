; based on code by SpiceWare

	;====================
	; disable sound
	;====================
disable_sound:
	ldx	#0		; silence sound output
	stx	SFX_LEFT
	stx	SFX_RIGHT
	stx	AUDV0
	stx	AUDV1
	stx	AUDC0
	stx	AUDC1
	stx	SOUND_TO_PLAY
	rts

	;=======================
	; trigger sound
	;=======================
	; sound to play in Y

	; case no sound playing:	18 cycles
	; case left sound playing:	28 cycles
	; case high priority left:	34 cycles
	; case high priority right:	40 cycles
	; case no room:			38 cycles

trigger_sound:
	ldx	SFX_LEFT	; test left channel			; 3
	lda	sfx_cv,X	; CV will be 0 if idle			; 4
	bne	leftnotfree	; if not 0 then skip ahead		; 2/3
	sty	SFX_LEFT	; channel is idle, use it		; 3
	rts			; all done				; 6
								;===========
								;        18
leftnotfree:
; 10
	ldx	SFX_RIGHT	; test right channel			; 3
	lda	sfx_cv,X	; CV value will be 0 if idle		; 4
	bne	rightnotfree	; if not 0 then skip ahead		; 2/3
	sty	SFX_RIGHT	; channel is idle, use it		; 3
	rts			; all done				; 6
								;===========
								;        28

rightnotfree:
; 20
	cpy	SFX_LEFT	; test sfx priority left channel	; 3
	bcc	leftnotlower	; skip ahead has lower priority		; 2/3
	sty	SFX_LEFT	; new has higher priority so use left	; 3
	rts			; all done				; 6
								;===========
								;	34

leftnotlower:
; 26
	cpy	SFX_RIGHT	; test sfx priority right channel	; 3
	bcc	rightnotlower	; skip ahead has lower priority		; 2/3
	sty	SFX_RIGHT	; new has higher priority so use right	; 3
rightnotlower:
	rts								; 6
