; restarts a new game

init_game:

;	lda	#$00		;					; 2
;	sta	SCORE_HIGH	; score, in BCD				; 3
;	sta	SCORE_LOW						; 3
;	sta	LEVEL		; level is actually LEVEL+1		; 3
;	sta	SPEED							; 3

	;====================
	; disable sound
	;====================
;disable_sound:
;	sta	TRIGGER_SOUND
;	sta	SFX_LEFT						; 3
;	sta	SFX_RIGHT						; 3
;	sta	AUDV0							; 3
;	sta	AUDV1							; 3
;	sta	AUDC0							; 3
;	sta	AUDC1							; 3


	lda	#$90		; init the zappy wall colors		; 2
	sta	ZAP_BASE						; 3

	ldx	#3		; number of lives			; 2
	stx	MANS							; 3

;	rts								; 6

