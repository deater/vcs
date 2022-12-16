	;=====================
	; add to score
	;=====================
	; value to add in A
add_to_score:

	sed				; set BCD mode			; 2
	clc								; 2
	adc	SCORE_LOW						; 3
	sta	SCORE_LOW						; 3
	lda	#0							; 2
	adc	SCORE_HIGH						; 3
	sta	SCORE_HIGH						; 3
	cld				; disable BCD mode		; 2
; 20
delay_12:
	rts
; 26
