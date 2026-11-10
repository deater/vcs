	; increment frame count
	; total is 30 cycles if you include the jsr
inc_frame:

	lda	FRAMEL							; 3
	clc								; 2
	adc	#1							; 2
	sta	FRAMEL							; 3
	lda	#0							; 2
	adc	FRAMEH							; 3
	sta	FRAMEH							; 3

	rts								; 6
								;===========
								;	24
