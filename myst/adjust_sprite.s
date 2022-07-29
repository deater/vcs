;================================
;================================
; pointer moved horizontally
;================================
;================================
; call after X changes
;	compute horizontal fine adjust
;	assume sprite width of 8

pointer_moved_horizontally:
	clc								; 2
	lda	POINTER_X						; 3
; 5
	pha								; 3
	adc	#8							; 2
	sta	POINTER_X_END						; 3
	pla								; 4
; 17
	; spritex DIV 16

	lsr								; 2
	lsr								; 2
	lsr								; 2
	lsr								; 2
	sta	POINTER_X_COARSE					; 3
; 28
	; apply fine adjust
	lda	POINTER_X						; 3
	and	#$0f							; 2
	tax								; 2
	lda	fine_adjust_table,X					; 4+
	sta	HMP0							; 3
	rts								; 6
; 48


;================================
;================================
; pointer moved vertically
;================================
;================================
; call after Y changes

pointer_moved_vertically:
	clc								; 2
	lda	POINTER_Y						; 3
	adc	#16	; pointer height				; 2
	sta	POINTER_Y_END						; 3
	rts								; 6
					;=================================
					;				16


