	;===============================================
	;===============================================
	; update score
	;===============================================
	;===============================================
	; 14 scanlines to update top of screen sprites

; comes in with 0 cycles

update_score:

	;=====================
	; setup digit pointers
	;=====================


; 0
	lda	#<score_zeros						; 2
	sta	INL							; 3
	lda	#>score_zeros						; 2
	sta	INH							; 3
;10

	;=================
	;=================
	; make two digits
	;=================
	;=================

	lda	SNAKE_KOS_BCD	; get bottom 2 digits			; 3
	and	#$f		; get bottom digit			; 2
	asl			; multiply by 8				; 2
	asl								; 2
	asl								; 2
	tay			; point to font data			; 2
	ldx	#7		; want to copy 8 lines			; 2
								;==========
								; 	15

; 25

low_right_score_loop:
	lda	(INL),Y			; copy font data to zero page	; 5+
	sta	SCORE_SPRITE_LOW_0+1,X					; 4
	iny								; 2
	dex								; 2
	bpl	low_right_score_loop					; 2/3
								;===========
								; 16*8 = 128
								;	-1

; 152
	; get 10s digit

	lda	SNAKE_KOS_BCD						; 3
	lsr		; >>4 then <<3					; 2
	and	#$f8							; 2
	bne	no_lead_zero	; if leading 0, print blakn instead	; 3/2
	lda	#80							; 2
no_lead_zero:
	tay								; 2
	ldx	#7							; 2
								;==========
								;	14/15

;166/167

	; get digit data and mask with ones digit
low_left_score_loop:
	lda	(INL),Y							; 5+
	and	#$f0							; 2
	sta	TEMP1							; 3
	lda	SCORE_SPRITE_LOW_0+1,X					; 4
	and	#$0f							; 2
	ora	TEMP1							; 3
	sta	SCORE_SPRITE_LOW_0+1,X					; 4
	iny								; 2
	dex								; 2
	bpl	low_left_score_loop					; 2/3
								;============
								; 30*8=240
								; 	-1
;406/407	~5.3 scanlines


	sta	WSYNC							; 3

; 6 scanlines
