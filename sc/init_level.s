; NEEDS CYCLE RECOUNT

	;============================
	; init level
	;============================


init_level:
	lda	LEVEL
	and	#$f8		; mask off bottom 3 bits
	asl
	asl			; carry should be clear (unless level really hi)
	adc	#$36		; offset from orange
	sta	LEVEL_COLOR

; 0
	; set timeout.  Gets faster as level increases

	lda	LEVEL							; 3
	lsr								; 2
	lsr								; 2
	lsr			; get LEVEL/8				; 2
	tax								; 2
	lda	#40		; 20 seconds				; 2
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

reinit_strongbad:

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
								;===========
								;	33
copy_level_data_loop:
	lda	(INL),Y							; 5
	sta	LEVEL_INFO,Y						; 5
	dey								; 2
	bpl	copy_level_data_loop					; 2/3
								;=============
								; (16*15)-1
								; 	239

	lda	#8
	sta	STRONGBAD_X
	lda	#32
	sta	STRONGBAD_Y

	lda	SECRET_Y_START
	clc
	adc	#8
	sta	SECRET_Y_END

;	jsr	strongbad_moved_horizontally	;              		; 6+48
; 61 (79)

	jmp     strongbad_moved_vertically				; 6+16
; 88 (106)

;	rts								; 6

; 94 (112)
