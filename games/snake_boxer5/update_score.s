	;===============================================
	;===============================================
	; update score
	;===============================================
	;===============================================
	; 14 scanlines to update top of screen sprites

; comes in with 4 cycles

update_score:

	;=====================
	; setup digit pointers
	;=====================


; 4
	lda	#<score_zeros						; 2
	sta	INL							; 3
	lda	#>score_zeros						; 2
	sta	INH							; 3



;14

	;=================
	;=================
	; bottom 2 digits
	;=================
	;=================

	lda	SNAKE_KOS	; get bottom 2 digits			; 3
	and	#$f		; get bottom digit			; 2
	asl			; multiply by 8				; 2
	asl								; 2
	asl								; 2
	tay			; point to font data			; 2
	ldx	#7		; want to copy 7 lines			; 2
								;==========
								; 	15

; 29

low_right_score_loop:
	lda	(INL),Y			; copy font data to zero page	; 5+
	sta	SCORE_SPRITE_LOW_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	low_right_score_loop					; 2/3
								;===========
								; 16*7 = 112
								;	-1

; 140
	; get 10s digit

	lda	SNAKE_KOS						; 3
	lsr		; >>4 then <<3					; 2
	and	#$f8							; 2
	tay								; 2
	ldx	#7							; 2
								;==========
								;	11

;151

	; get digit data and mask with ones digit
low_left_score_loop:
	lda	(INL),Y							; 5+
	and	#$f0							; 2
	sta	TEMP1							; 3
	lda	SCORE_SPRITE_LOW_0,X					; 4
	and	#$0f							; 2
	ora	TEMP1							; 3
	sta	SCORE_SPRITE_LOW_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	low_left_score_loop					; 2/3
								;============
								; 30*7=210
								; 	-1
;360	~4.7 scanlines


	sta	WSYNC							; 3

; 5 scanlines
