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
	sta	BUTTON_COUNTDOWN

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
;	.include "ram_tests.s"
	.include "print_numbers.s"
	.include "update_numbers.s"
	.include "print_string.s"

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
