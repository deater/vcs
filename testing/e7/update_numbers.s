	;===============================================
	;===============================================
	; update numbers
	;===============================================
	;===============================================
	; 14 scanlines to update numbrers to print

; comes in with 4 cycles

update_numbers:

	;=====================
	; setup digit pointers
	;=====================
; 4
	lda	#<score_zeros						; 2
	sta	INL							; 3
	lda	#>score_zeros						; 2
	sta	INH							; 3

;14

	;=========================
	;=========================
	; right-most DIGIT3 digits
	;=========================
	;=========================

	lda	DIGITS3		; get bottom 2 digits			; 3
	and	#$f		; get bottom digit			; 2
	asl			; multiply by 8				; 2
	asl								; 2
	asl								; 2
	tay			; point to font data			; 2
	ldx	#6		; want to copy 7 lines			; 2
								;==========
								; 	15

; 29

low_right_score_loop:
	lda	(INL),Y			; copy font data to zero page	; 5+
	sta	DIGIT3_DATA_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	low_right_score_loop					; 2/3
								;===========
								; 16*7 = 112
								;	-1

; 140
	; get 10s digit

	lda	DIGITS3						; 3
	lsr		; >>4 then <<3					; 2
	and	#$f8							; 2
	tay								; 2
	ldx	#6							; 2
								;==========
								;	11

;151

	; get digit data and mask with ones digit
low_left_score_loop:
	lda	(INL),Y							; 5+
	and	#$f0							; 2
	sta	TEMP1							; 3
	lda	DIGIT3_DATA_0,X					; 4
	and	#$0f							; 2
	ora	TEMP1							; 3
	sta	DIGIT3_DATA_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	low_left_score_loop					; 2/3
								;============
								; 30*7=210
								; 	-1
;360	~4.7 scanlines

	;=================
	;=================
	; DIGIT2 digits
	;=================
	;=================

	; get hundreds digit
	lda	DIGITS2								; 3
	and	#$f							; 2
	asl								; 2
	asl								; 2
	asl								; 2
	tay								; 2
	ldx	#6							; 2
								;===========
								;	15
; 375

	; copy to zero page
high_right_score_loop:
	lda	(INL),Y							; 5+
	sta	DIGIT2_DATA_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	high_right_score_loop					; 2/3
								;===========
								; 16*7 = 112
								;	-1

; 486
	; get thousands digit

	lda	DIGITS2							; 3
	lsr		; >>4 then <<3					; 2
	and	#$f8							; 2
	tay								; 2
	ldx	#6							; 2
								;==========
								;	11

; 497

	; mask into place
high_left_score_loop:
	lda	(INL),Y							; 5+
	and	#$f0							; 2
	sta	TEMP1							; 3
	lda	DIGIT2_DATA_0,X					; 4
	and	#$0f							; 2
	ora	TEMP1							; 3
	sta	DIGIT2_DATA_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	high_left_score_loop					; 2/3
								;============
								; 30*7=210
								; 	-1
;706	9.3 scanlines (round up to 10)





	;=========================
	;=========================
	; DIGIT1 digits
	;=========================
	;=========================

	lda	DIGITS1		; get bottom 2 digits			; 3
	and	#$f		; get bottom digit			; 2
	asl			; multiply by 8				; 2
	asl								; 2
	asl								; 2
	tay			; point to font data			; 2
	ldx	#6		; want to copy 7 lines			; 2
								;==========
								; 	15

; 29

low_right_d1_score_loop:
	lda	(INL),Y			; copy font data to zero page	; 5+
	sta	DIGIT1_DATA_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	low_right_d1_score_loop					; 2/3
								;===========
								; 16*7 = 112
								;	-1

; 140
	; get 10s digit

	lda	DIGITS1						; 3
	lsr		; >>4 then <<3					; 2
	and	#$f8							; 2
	tay								; 2
	ldx	#6							; 2
								;==========
								;	11

;151

	; get digit data and mask with ones digit
low_left_d1_loop:
	lda	(INL),Y							; 5+
	and	#$f0							; 2
	sta	TEMP1							; 3
	lda	DIGIT1_DATA_0,X					; 4
	and	#$0f							; 2
	ora	TEMP1							; 3
	sta	DIGIT1_DATA_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	low_left_d1_loop					; 2/3
								;============
								; 30*7=210
								; 	-1
;360	~4.7 scanlines

	;=================
	;=================
	; DIGIT0 digits
	;=================
	;=================

	; get hundreds digit
	lda	DIGITS0							; 3
	and	#$f							; 2
	asl								; 2
	asl								; 2
	asl								; 2
	tay								; 2
	ldx	#6							; 2
								;===========
								;	15
; 375

	; copy to zero page
high_right_d0_loop:
	lda	(INL),Y							; 5+
	sta	DIGIT0_DATA_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	high_right_d0_loop					; 2/3
								;===========
								; 16*7 = 112
								;	-1

; 486
	; get thousands digit

	lda	DIGITS0						; 3
	lsr		; >>4 then <<3					; 2
	and	#$f8							; 2
	tay								; 2
	ldx	#6							; 2
								;==========
								;	11

; 497

	; mask into place
high_left_d0_loop:
	lda	(INL),Y							; 5+
	and	#$f0							; 2
	sta	TEMP1							; 3
	lda	DIGIT0_DATA_0,X					; 4
	and	#$0f							; 2
	ora	TEMP1							; 3
	sta	DIGIT0_DATA_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	high_left_d0_loop					; 2/3
								;============
								; 30*7=210
								; 	-1
;1412	18.5 scanlines (round up to 19)

; 19 scanlines

	sta	WSYNC

	rts
