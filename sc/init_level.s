	;============================
	; init levels
	;============================


init_level:
; 0
	lda	#20		; 20 seconds				; 2
	sta	TIME							; 3
; 5
	lda	#59							; 2
	sta	TIME_SUBSECOND						; 3
; 10
	lda	#0							; 2
	sta	FRAME							; 3
	sta	LEVEL_OVER						; 3
; 18

reinit_strongbad:

copy_level_data_in:
	ldx	LEVEL							; 3
	dex								; 2
	txa								; 2
	and	#$7		; currently only 8 levels		; 2
	asl			; in 16 byte chunks			; 2
	asl								; 2
	asl								; 2
	asl								; 2
	clc								; 2
	adc	#<level1_data						; 2
	sta	INL							; 3
	lda	#0							; 2
	adc	#>level1_data						; 2
	sta	INH							; 3
	ldy	#15							; 2
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


	jsr	strongbad_moved_horizontally	;              		; 6+48
; 61 (79)

	jsr     strongbad_moved_vertically				; 6+16
; 88 (106)

	rts								; 6

; 94 (112)
