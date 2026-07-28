; e7_test for Atari 2600

; For E7 bank-switched cartridge (16k ROM, 2k RAM)

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"

.include "zp.inc"


	;==============================
	;==============================

e7_test:
	sei		; disable interrupts
	cld		; clear decimal bit

restart_test:

	; init zero page and addresses to 0

	ldx	#0
	txa
clear_loop:
	dex
	txs
	pha
	bne	clear_loop

	; S=$FF, A=$00, X=$00, Y=??

	;==============================
	; var init
	;==============================

	lda	#$f
	sta	DEBOUNCE_COUNTDOWN

	lda	#3
	sta	BANK_256

	lda	#4
	sta	BANK_1K

	lda	#$00
	sta	READ_VALUE
	sta	READ_256L
	sta	READ_1KL
	sta	WRITE_256L
	sta	WRITE_1KL
	sta	WHICH_ROW

	lda	#$19
	sta	READ_256H
	lda	#$18
	sta	WRITE_256H

	lda	#$14
	sta	READ_1KH
	lda	#$10
	sta	WRITE_1KH

	lda	#$5A
	sta	WRITE_VALUE




	; update all bytes

	ldy	#11
ub_loop:
	sty	TEMPY
	jsr	update_byte
	ldy	TEMPY
	dey
	bpl	ub_loop



	;==============================
	; Run Tests
	;==============================
again:
	jsr	memory_test

	jmp	again

	;===========================
	; common routines
	;===========================

	.include "common_routines.s"
	.include "memory_test.s"
	.include "print_word.s"
	.include "print_byte.s"
	.include "print_string.s"
	.include "update_byte.s"
	.include "center_string.s"
	.include "joypad_routines.s"

	;==========================
	; graphics
	;==========================
.align $100
	.include "number_font.inc"
	.include "strings.inc"

; e7 signature for MAME */
; this is LDA $FFE5
;.byte $ad, $e5, $ff

.segment "BANKSWITCH"
	.byte $00

.segment "IRQ_VECTORS"
	.word e7_test	; NMI
	.word e7_test	; RESET
	.byte $E7,$00	; IRQ
