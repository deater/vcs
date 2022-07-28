
	;=============================
	;=============================
	; copy in hand sprite
	;=============================
	;=============================
	; takes 4 scanlines


	; look at POINTER_TYPE
; 6
hand_copy:
	lda	POINTER_TYPE						; 3
	asl								; 2
	asl								; 2
	asl								; 2
	asl	; multiply by 16
; 15
	lda	#<hand_sprite						; 2
	sta	INL							; 3
	lda	#>hand_sprite						; 2
	sta	INH							; 3
; 25
	ldy	#15							; 2
; 7
hand_copy_loop:
	lda	(INL),Y							; 5+
	sta	HAND_SPRITE,Y						; 4+
	dey								; 2
	bpl	hand_copy_loop						; 2/3

	; (16*14)-1 = 223
; 230
	;	around 3.3 scanlines
	sta	WSYNC

	rts
; 6
