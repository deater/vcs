	;===============================================
	;===============================================
	; update byte
	;===============================================
	;===============================================
	; 5 scanlines to update numbers to print

	; Y is the byte to update

; comes in with 4 cycles

update_byte:
	lda	data_bytes,Y		; get byte to print		; 4
	sta	TEMP			; save for later		; 3

	tya				; multiply which by 8		; 2
	asl								; 2
	asl								; 2
	asl								; 2
	clc								; 2
	adc	#char_data_start	; char data offset		; 2
	sta	OUTL							; 3
	lda	#0							; 2
	sta	OUTH			; OUTL points to output		; 3

	;=====================
	; setup digit pointers
	;=====================


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
	tax			; point to font data			; 2
	ldy	#6		; want to copy 7 lines			; 2
								;==========
								; 	15

; 29

ub_ones_font_loop:
	lda	font_zeros,X		; copy font data to zero page	; 4+
	sta	(OUTL),Y						; 5
	inx								; 2
	dey								; 2
	bpl	ub_ones_font_loop					; 2/3
								;===========
								; 16*7 = 112
								;	-1

; 140
	; get 10s digit

	lda	TEMP							; 3
	lsr		; >>4 then <<3					; 2
	and	#$f8							; 2
	tax								; 2
	ldy	#6							; 2
								;==========
								;	11

;151

	; get digit data and mask with ones digit
ub_tens_font_loop:
	lda	font_zeros,X						; 4+
	and	#$f0							; 2
	sta	TEMP1							; 3
	lda	(OUTL),Y						; 4
	and	#$0f							; 2
	ora	TEMP1							; 3
	sta	(OUTL),Y						; 4
	inx								; 2
	dey								; 2
	bpl	ub_tens_font_loop					; 2/3
								;============
								; 30*7=210
								; 	-1
;360	~4.7 scanlines (round up to 5)

	sta	WSYNC

	rts
