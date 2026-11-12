
	; A is bank to return to
	; X is 256 bank to copy from
bank7_to_256_copy:
	sta	PAGE_SAVE

;	sta	E7_SET_256_BANK0,X

	sta	E7_SET_BANK7_RAM


	sta	E7_SET_256_BANK0
	ldx	#0
b7t256_loop1:
	lda	E7_1K_READ_ADDR,X
	sta	E7_256B_WRITE_ADDR,X
	inx
	bne	b7t256_loop1

	sta	E7_SET_256_BANK1
	ldx	#0
b7t256_loop2:
	lda	E7_1K_READ_ADDR+256,X
	sta	E7_256B_WRITE_ADDR,X
	inx
	bne	b7t256_loop2

	sta	E7_SET_256_BANK2
	ldx	#0
b7t256_loop3:
	lda	E7_1K_READ_ADDR+512,X
	sta	E7_256B_WRITE_ADDR,X
	inx
	bne	b7t256_loop3

	sta	E7_SET_256_BANK3
	ldx	#0
b7t256_loop4:
	lda	E7_1K_READ_ADDR+768,X
	sta	E7_256B_WRITE_ADDR,X
	inx
	bne	b7t256_loop4



	ldx	PAGE_SAVE
	sta	E7_SET_BANK0,X

	rts
