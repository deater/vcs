; restarts a new game

init_game:

	lda	#$00		;					; 2
	sta	SCORE_HIGH	; score, in BCD				; 3
	sta	SCORE_LOW						; 3
	sta	LEVEL		; level is actually LEVEL+1		; 3

	lda	#$90		; init the zappy wall colors		; 2
	sta	ZAP_BASE						; 3

	lda	#3		; number of lives			; 2
	sta	MANS							; 3
	sta	BALLS_LEFT	; speed powerups left			; 3

	jmp	disable_sound	; disable sound				; 6+

;	rts								; 6
