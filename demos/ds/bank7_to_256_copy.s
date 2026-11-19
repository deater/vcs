	;=================================
	; bank7_to_256_copy
	;=================================
	; A is bank to return to
	; X is 256 bank to copy from

	; approx 4*3332 = 13328/76=175

bank7_to_256_copy:
; 0
	sta	PAGE_SAVE						; 3

	sta	E7_SET_BANK7_RAM					; 3
; 6

;=====================
; 5+(13*256)-1 = 3332

	sta	E7_SET_256_BANK0					; 3
	ldx	#0							; 2
; 5
b7t256_loop1:
	lda	E7_1K_READ_ADDR,X					; 4
	sta	E7_256B_WRITE_ADDR,X					; 4
	inx								; 2
	bne	b7t256_loop1						; 2/3
; 13

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
