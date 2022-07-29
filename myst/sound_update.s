	; mono, just play one sound out both channels

update_sound:
	ldx	SFX_PTR		; get left channel pointer		; 3
	lda	sfx_f,X		; get frequency value			; 4
	sta	AUDF0		; update frequency register		; 3
	sta	AUDF1							; 3
; 13
	lda	sfx_cv,X	; get Control / Volume value		; 4
	sta	AUDV0		; update Volume register		; 3
	sta	AUDV1							; 3
; 23
	lsr			; get control value down into		; 2
	lsr			;  the low nybble			; 2
	lsr			;					; 2
	lsr			;					; 2
	sta	AUDC0		; update control register		; 3
	sta	AUDC1							; 3
; 37
	beq	skipleftdec	; skip ahead if control=0		; 2/3

	lda	FRAME
	and	#$7
	bne	skipleftdec

	dec	SFX_PTR		; update pointer			; 5
skipleftdec:							;==========
								; 44 / 40

	rts			; 6

; 50 / 46
