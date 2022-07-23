;================================
;================================
; strongbad moved horizontally
;================================
;================================
; call after X changes
;	compute horizontal fine adjust
;	assume sprite width of 8

strongbad_moved_horizontally:
; 0
	clc								; 2
	lda	STRONGBAD_X						; 3
; 5
	; spritex DIV 16

	lsr								; 2
	lsr								; 2
	lsr								; 2
	lsr								; 2
	sta	STRONGBAD_X_COARSE					; 3
; 16
	; apply fine adjust
	lda	STRONGBAD_X						; 3
	and	#$0f							; 2
	tax								; 2
	lda	fine_adjust_table,X					; 4+
	sta	HMP0							; 3
; 30


