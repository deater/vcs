	;==========================
	; rom to 256 copy
	;==========================
	; src is in INL,INH
	; X is which 256 page

	; 7-1+6+256*15 = 3852/76= 50.68
	;	plus overhead really 51

rom_to_256_copy:
	sta	E7_SET_256_BANK0,X					; 5
	ldy	#0							; 2
rom_to_256_copy_loop:
	lda	(INL),Y							; 5
	sta	$1800,Y							; 5
	iny								; 2
	bne	rom_to_256_copy_loop					; 2/3

	sta	WSYNC

	rts
