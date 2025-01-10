; only left channel?

; videlectrix notes
;       E4 D4 F4  C4  C5 C5
; with "12" pure lower
;       15 17 14  19  9  9



vid_theme_f:
	;       E4,D4,F4,C4,C5  (+C5? not here)
;	.byte	15,17,14,19, 9, 0
	.byte	$FF,  0,  9, 19, 14, 14, 14, 14, 17, 15
vid_theme_d:
;	.byte	32,32,32,64,32,5
	.byte	$FF,  5, 64,128, 32, 32, 32, 32, 64, 64
vid_theme_cv:
	.byte	$00,$00,$CF,$CF,$CC,$CD,$CE,$CF,$CF,$CF

VID_THEME=9

play_note:
	lda	NOTE_POINTER
	beq	skip_note

	lda	NOTE_DURATION
	beq	new_note

	dec	NOTE_DURATION
	jmp	skip_note

new_note:
	ldx	NOTE_POINTER

	lda	vid_theme_d,X
	sta	NOTE_DURATION

	lda	vid_theme_f,X	; get frequency value			; 4
	sta	AUDF0		; update frequency register		; 3
	lda	vid_theme_cv,X	; get Control / Volume value		; 4
	sta	AUDV0		; update Volume register		; 3
	lsr			; get control value down into		; 2
	lsr			;  the low nybble			; 2
	lsr			;					; 2
	lsr			;					; 2
	sta	AUDC0		; update control register		; 3

	dec	NOTE_POINTER	; update pointer			; 5
not_new_note:
skip_note:
	rts
