;================================
;================================
; strongbad moved horizontally
;================================
;================================
; call after X changes
;	compute horizontal fine adjust
;	assume sprite width of 8

strongbad_moved_horizontally:
	clc								; 2
	lda	STRONGBAD_X						; 3
; 5
	pha								; 3
	adc	#8							; 2
	sta	STRONGBAD_X_END						; 3
	pla								; 4
; 17
	; spritex DIV 16

	lsr								; 2
	lsr								; 2
	lsr								; 2
	lsr								; 2
	sta	STRONGBAD_X_COARSE					; 3
; 28
	; apply fine adjust
	lda	STRONGBAD_X						; 3
	and	#$0f							; 2
	tax								; 2
	lda	fine_adjust_table,X					; 4+
	sta	HMP0							; 3
	rts								; 6
; 48


;================================
;================================
; strongbad moved vertically
;================================
;================================
; call after Y changes

strongbad_moved_vertically:
	clc				;				2
	lda	STRONGBAD_Y		;				3
	adc	#STRONGBAD_HEIGHT	;				2
	sta	STRONGBAD_Y_END		;				3
	rts				;				6
					;=================================
					;				16


