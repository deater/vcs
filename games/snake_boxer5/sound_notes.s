; only left channel?

; videlectrix notes
;       E4 D4 F4  C4  C5 C5
; with "12" pure lower
;       15 17 14  19  9  9



vid_theme_f:
		; E4,D4,F4,C4,C5,C5
	.byte	15,17,14,19,9,9
vid_theme_d:
	.byte	20,20,20,20,20,20,$FF
vid_theme_c:
	.byte	$CF,$CF,$CF,$CF,$CF,$CF

play_note:
	dec	NOTE_DURATION
	bne	not_new_note
new_note:
	ldx	NOTE_POINTER


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

	rts
