
update_sound:
	ldx	SFX_LEFT	; get left channel pointer		; 3
	lda	sfx_f,X		; get frequency value			; 4
	sta	AUDF0		; update frequency register		; 3
	lda	sfx_cv,X	; get Control / Volume value		; 4
	sta	AUDV0		; update Volume register		; 3
	lsr			; get control value down into		; 2
	lsr			;  the low nybble			; 2
	lsr			;					; 2
	lsr			;					; 2
	sta	AUDC0		; update control register		; 3
	beq	skipleftdec	; skip ahead if control=0		; 2/3
	dec	SFX_LEFT	; update pointer			; 5
skipleftdec:							;==========
								; 31 / 35

	ldx	SFX_RIGHT	; get right channel pointer		; 3
	lda	sfx_f,X		; get frequency value			; 4
	sta	AUDF1		; update frequency register		; 3
	lda	sfx_cv,X	; get control/volume value		; 4
	sta	AUDV1		; update Volume register		; 3
	lsr			; get control value down into		; 2
	lsr			;   the low nybble			; 2
	lsr			;					; 2
	lsr			;					; 2
	sta	AUDC1		; update control register		; 3
	beq	skiprightdec	; skip ahead if control=0		; 2/3
	dec	SFX_RIGHT	; update pointer			; 5
skiprightdec:							;===========
								; 31 / 35

; best case = 62 (74 if jsr)
; worst case = 70 (82 if jsr)

	; kick it up to two scanlines just to be consistent
	inc	TEMP1		; 5

	rts			; 6
