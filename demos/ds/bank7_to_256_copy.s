
	; A is bank to return to
	; X is 256 bank to copy from
bank7_to_256_copy:
	sta	PAGE_SAVE

	sta	E7_SET_256_BANK0,X

	sta	E7_SET_BANK7_RAM

	ldx	#0
b7t256_loop:
	lda	E7_1K_READ_ADDR,X
	sta	E7_256B_WRITE_ADDR,X
	inx
	bne	b7t256_loop

	ldx	PAGE_SAVE
	sta	E7_SET_BANK0,X

	rts
