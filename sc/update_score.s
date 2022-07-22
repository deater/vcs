; RECALC TIMINGS

	;===============================================
	; 13 scanlines to update top of screen sprites


update_score:

	;=====================
	; setup digit pointers
	;=====================

	lda	#<score_zeros						; 2
	sta	INL							; 3
	lda	#>score_zeros						; 2
	sta	INH							; 3

;10

	;=================
	;=================
	; bottom 2 digits
	;=================
	;=================

	lda	SCORE_LOW						; 3
	and	#$f							; 2
	asl								; 2
	asl								; 2
	asl								; 2
	tay								; 2
	ldx	#6							; 2
								;===========
								;	15
; 25

low_right_score_loop:
	lda	(INL),Y							; 5+
	sta	SCORE_SPRITE_LOW_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	low_right_score_loop					; 2/3
								;===========
								; 16*7 = 112
								;	-1

; 136

	lda	SCORE_LOW						; 3
	lsr		; >>4 then <<3					; 2
	and	#$f8							; 2
	tay								; 2
	ldx	#6							; 2
								;==========
								;	11

;147

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
;356	~5 scanlines

	;=================
	;=================
	; top 2 digits
	;=================
	;=================

	lda	SCORE_HIGH						; 3
	and	#$f							; 2
	asl								; 2
	asl								; 2
	asl								; 2
	tay								; 2
	ldx	#6							; 2
								;===========
								;	15
; 371

high_right_score_loop:
	lda	(INL),Y							; 5+
	sta	SCORE_SPRITE_HIGH_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	high_right_score_loop					; 2/3
								;===========
								; 16*7 = 112
								;	-1

; 482

	lda	SCORE_HIGH						; 3
	lsr		; >>4 then <<3					; 2
	and	#$f8							; 2
	tay								; 2
	ldx	#6							; 2
								;==========
								;	11

; 493

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
;702	~10 scanlines

update_mans:

	;=====================
	; setup digit pointers
	;=====================

	lda	#<mans_zeros						; 2
	sta	INL							; 3
	lda	#>mans_zeros						; 2
	sta	INH							; 3

; 712

	;=================
	;=================
	; bottom digit
	;=================
	;=================

	lda	MANS							; 3
	and	#$f							; 2
	asl								; 2
	asl								; 2
	asl								; 2
	tay								; 2
	ldx	#6							; 2
								;===========
								;	15
; 727

mans_loop:
	lda	(INL),Y							; 5+
	sta	MANS_SPRITE_0,X						; 4
	iny								; 2
	dex								; 2
	bpl	mans_loop						; 2/3
								;===========
								; 16*7 = 112
								;	-1

; 839 (just over 11)

	; update level

	lda	LEVEL							; 3
	and	#$7							; 2
	asl								; 2
	asl								; 2
	asl								; 2
	tay			; point to proper sprite offset		; 2
	ldx	#15							; 2
								;==========
								;	19
; 858

level_write_loop:
	lda	big_level_one,Y						; 4
	iny								; 2
	sta	LEVEL_SPRITE0,X						; 4
	dex								; 2
	sta	LEVEL_SPRITE0,X						; 4
	dex								; 2
	bpl	level_write_loop					; 2/3

	; (8*21)-1 = 167


; 1025 = 13+ scanlines
	sta	WSYNC							; 3

