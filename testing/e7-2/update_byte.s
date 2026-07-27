	;===============================================
	;===============================================
	; update byte
	;===============================================
	;===============================================
	; 5 scanlines to update numbers to print

	; Y is the byte to update
	; ??? is the output

; comes in with 4 cycles

update_byte:

	lda	data_bytes,Y
	sta	TEMP


	;=====================
	; setup digit pointers
	;=====================
; 4
	lda	#<font_zeros						; 2
	sta	INL							; 3
	lda	#>font_zeros						; 2
	sta	INH							; 3

;14

	;=========================
	;=========================
	; right-most DIGIT
	;=========================
	;=========================

	lda	TEMP		; get bottom 2 digits			; 3
	and	#$f		; get bottom digit			; 2
	asl			; multiply by 8				; 2
	asl								; 2
	asl								; 2
	tay			; point to font data			; 2
	ldx	#6		; want to copy 7 lines			; 2
								;==========
								; 	15

; 29

ub_ones_font_loop:
	lda	(INL),Y			; copy font data to zero page	; 5+
	sta	BANK_256_DATA_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	ub_ones_font_loop					; 2/3
								;===========
								; 16*7 = 112
								;	-1

; 140
	; get 10s digit

	lda	TEMP							; 3
	lsr		; >>4 then <<3					; 2
	and	#$f8							; 2
	tay								; 2
	ldx	#6							; 2
								;==========
								;	11

;151

	; get digit data and mask with ones digit
ub_tens_font_loop:
	lda	(INL),Y							; 5+
	and	#$f0							; 2
	sta	TEMP1							; 3
	lda	BANK_256_DATA_0,X					; 4
	and	#$0f							; 2
	ora	TEMP1							; 3
	sta	BANK_256_DATA_0,X					; 4
	iny								; 2
	dex								; 2
	bpl	ub_tens_font_loop					; 2/3
								;============
								; 30*7=210
								; 	-1
;360	~4.7 scanlines (round up to 5)

	sta	WSYNC

	rts
