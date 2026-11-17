	;==========================
	; copy to 256 84
	;==========================
	; src is in INL,INH
	; X is which 256 page

	; 7-1+6++84*17 = 1440/76= 18.94
	;	plus overhead really 20

copy_to_256_84:
	sta	E7_SET_256_BANK0,X					; 5
	ldy	#0							; 2
copy_256_84_loop:
	lda	(INL),Y							; 5
	sta	$1800,Y							; 5
	iny								; 2
	cpy	#84							; 2
	bne	copy_256_84_loop					; 2/3

	sta	WSYNC

	rts
