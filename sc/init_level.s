
	;============================
	; init level
	;============================
	;


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
	lda	hardness_lookup,X					; 4+
	sta	TIME							; 3
; 32

	lda	#59							; 2
	sta	TIME_SUBSECOND						; 3
; 37
	lda	#0							; 2
	sta	FRAME							; 3
	sta	LEVEL_OVER						; 3
	sta	DIDNT_TOUCH_WALL					; 3
; 48


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
								;==========
								;	27
; 75

copy_level_data_loop:
	lda	(INL),Y							; 5+
	sta	LEVEL_INFO,Y						; 5
	dey								; 2
	bpl	copy_level_data_loop					; 2/3
								;=============
								; (8*15)-1
								; 	119

; 194


	;========================
	; adjust secret position

	lda	SECRET_Y_START						; 3
	clc								; 2
	adc	#8							; 2
	sta	SECRET_Y_END						; 3
; 204

	lda	SECRET_X_START						; 3
	lsr								; 2
	lsr								; 2
	lsr								; 2
	lsr								; 2
	sta	SECRET_X_COARSE						; 3
; 218
	; apply fine adjust
	lda	SECRET_X_START						; 3
	and	#$0f							; 2
	tax								; 2
	lda	fine_adjust_table,X					; 4+
	sta	SECRET_X_FINE						; 3
; 232

	;===========================
	; init speed boost
	;	limit to 3

	ldx	#0							; 2
	lda	SPEED							; 3
	cmp	#3							; 2
	bcs	too_many_balls						; 2/3
	inx								; 2
too_many_balls:
	stx	BALL_OUT						; 3
								;===========
								; 14/13
; 246

reinit_strongbad:
	; adjust strong bad position
	;	for now, fixed start

	lda	#8							; 2
	sta	STRONGBAD_X						; 3
	lda	#32							; 2
	sta	STRONGBAD_Y						; 3
	lda	#0							; 2
	sta	STRONGBAD_X_LOW						; 3
	sta	STRONGBAD_Y_LOW						; 3
	sta	STRONGBAD_ON

; 264

	rts								; 6

; 270 = ~3.5 scanlines

; could use some tuning?
; amount of time allowed for each wave
; in theory anything less than 2 probably not humanly possible

hardness_lookup:
	.byte 20,10,5,4,3,2,1,0
