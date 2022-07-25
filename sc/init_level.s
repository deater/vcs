; NEEDS CYCLE RECOUNT

	;============================
	; init level
	;============================


init_level:
; 0
	lda	LEVEL							; 3
	and	#$f8		; mask off bottom 3 bits		; 2
	asl								; 2
	asl			; carry should be clear			; 2
				; (unless level really hi)
	adc	#$36		; offset from orange			; 2
	sta	LEVEL_COLOR						; 3

; 14
	; set timeout.  Gets faster as level increases

	lda	LEVEL							; 3
	lsr								; 2
	lsr								; 2
	lsr			; get LEVEL/8				; 2
	tax								; 2
	lda	#40		; 20 seconds				; 2
; 27
hardness_loop:
	lsr								; 2
	dex								; 2
	bpl	hardness_loop						; 2/3

	sta	TIME							; 3

	lda	#59							; 2
	sta	TIME_SUBSECOND						; 3
; ?+5
	lda	#0							; 2
	sta	FRAME							; 3
	sta	LEVEL_OVER						; 3
; ?+18



copy_level_data_in:
	lda	LEVEL							; 3
	and	#$7		; currently only 8 levels		; 2
	asl			; in 8 byte chunks			; 2
	asl								; 2
	asl								; 2
	clc								; 2
	adc	#<level1_data						; 2
	sta	INL							; 3
	lda	#0							; 2
	adc	#>level1_data						; 2
	sta	INH							; 3
	ldy	#7							; 2
; 33

copy_level_data_loop:
	lda	(INL),Y							; 5
	sta	LEVEL_INFO,Y						; 5
	dey								; 2
	bpl	copy_level_data_loop					; 2/3
								;=============
								; (16*15)-1
								; 	239


	;========================
	; adjust secret position

	lda	SECRET_Y_START
	clc
	adc	#8
	sta	SECRET_Y_END

	lda	SECRET_X_START
	lsr								; 2
	lsr								; 2
	lsr								; 2
	lsr								; 2
	sta	SECRET_X_COARSE						; 3
; 16
	; apply fine adjust
	lda	SECRET_X_START						; 3
	and	#$0f							; 2
	tax								; 2
	lda	fine_adjust_table,X					; 4+
	sta	SECRET_X_FINE						; 3
; 30

	; init balls
	lda	#0
	ldx	SPEED
	cpx	#3
	bcs	too_many_balls
	lda	#1
too_many_balls:
	sta	BALL_OUT

reinit_strongbad:
	; adjust strong bad position
	;	for now, fixed start

	lda	#8							; 2
	sta	STRONGBAD_X						; 3
	lda	#32							; 2
	sta	STRONGBAD_Y						; 3
	lda	#0							; 2
	sta	STRONGBAD_X_LOW						; 3


; 61 (79)
	rts


