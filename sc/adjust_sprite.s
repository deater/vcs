
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


