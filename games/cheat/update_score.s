	;===============================================
	;===============================================
	; update score
	;===============================================
	;===============================================
	; 10 scanlines to update top of screen sprites

; comes in with 10 cycles

update_score:

	;=====================
	; setup digit pointers
	;=====================
; 10
	lda	#<score_zeros						; 2
	sta	INL							; 3
	lda	#>score_zeros						; 2
	sta	INH							; 3

;20

	;=================
	;=================
	; bottom 2 digits
	;=================
	;=================

	lda	SCORE_LOW	; get bottom 2 digits			; 3
	and	#$f		; get bottom digit			; 2
	asl			; multiply by 8				; 2
	asl								; 2
	asl								; 2
	tay			; point to font data			; 2
	ldx	#6		; want to copy 7 lines			; 2
								;==========
								; 	15

; 35

low_right_score_loop:
	lda	(INL),Y			; copy font data to zero page	; 5+
	sta	SCORE_SPRITE_LOW_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	low_right_score_loop					; 2/3
								;===========
								; 16*7 = 112
								;	-1

; 146
	; get 10s digit

	lda	SCORE_LOW						; 3
	lsr		; >>4 then <<3					; 2
	and	#$f8							; 2
	tay								; 2
	ldx	#6							; 2
								;==========
								;	11

;157

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
;366	~4.7 scanlines

	;=================
	;=================
	; top 2 digits
	;=================
	;=================

	; get hundreds digit
	lda	SCORE_HIGH						; 3
	and	#$f							; 2
	asl								; 2
	asl								; 2
	asl								; 2
	tay								; 2
	ldx	#6							; 2
								;===========
								;	15
; 381

	; copy to zero page
high_right_score_loop:
	lda	(INL),Y							; 5+
	sta	SCORE_SPRITE_HIGH_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	high_right_score_loop					; 2/3
								;===========
								; 16*7 = 112
								;	-1

; 492
	; get thousands digit

	lda	SCORE_HIGH						; 3
	lsr		; >>4 then <<3					; 2
	and	#$f8							; 2
	tay								; 2
	ldx	#6							; 2
								;==========
								;	11

; 503

	; mask into place
high_left_score_loop:
	lda	(INL),Y							; 5+
	and	#$f0							; 2
	sta	TEMP1							; 3
	lda	SCORE_SPRITE_HIGH_0,X					; 4
	and	#$0f							; 2
	ora	TEMP1							; 3
	sta	SCORE_SPRITE_HIGH_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	high_left_score_loop					; 2/3
								;============
								; 30*7=210
								; 	-1
;712	9.3 scanlines (round up to 10)

; 9*76=684

; 28
	sed							; 2
	sec							; 2
	lda	SCORE_LOW					; 3
	sbc	#1						; 2
	sta	SCORE_LOW					; 3
; 40
	lda	SCORE_HIGH					; 3
	sbc	#0						; 2
	sta	SCORE_HIGH					; 3
	cld							; 2
; 50
	rts							; 6
