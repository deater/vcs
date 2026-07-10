

write_pattern_ram:

	;===================================
	; write banked RAM first
	;===================================

	ldx	#0

banked_ram_loop:
	sta	E7_SET_256_BANK0,X	; start in BANK0?		; 3

	; write our pattern to RAM

	txa
	asl
	asl
	asl
	asl
	sta	EXPECTED_H

	ldy	#0							; 2
ram_write_loop:
	lda	EXPECTED_H						; 3
	sta	$1800,Y							; 5
	tya								; 2
	sta	$1801,Y							; 5
	iny								; 2
	iny								; 2

	bne	ram_write_loop						; 2/3

	; 2+(256*22)-1 = 5633 cycles = 75 scanlines?


	inx
	cpx	#4
	bne	banked_ram_loop



	;===================================
	; write 1k RAM next
	;===================================

	sta	E7_SET_BANK7_RAM	; set RAM

	ldx	#0
	stx	OUTL

	lda	#$10
	sta	OUTH

	lda	#$70
	sta	EXPECTED_H

onek_ram_loop:

	; write our pattern to RAM

	ldy	#0							; 2
onek_ram_write_loop:
	lda	EXPECTED_H						; 3
	sta	(OUTL),Y						; 5
	tya								; 2
	iny
	sta	(OUTL),Y						; 5
	iny								; 2

	bne	onek_ram_write_loop					; 2/3

	; 2+(256*22)-1 = 5633 cycles = 75 scanlines?

	inc	EXPECTED_H
	inc	OUTH

	inx
	cpx	#4
	bne	onek_ram_write_loop

; insert glitches to test

.if 0
	lda	#$dd
	sta	$1280
.endif

.if 0
	sta	E7_SET_256_BANK0
	lda	#$dd
	sta	$1830
.endif
