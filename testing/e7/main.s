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
	; Display Title Screen
	;==============================

.include "title_screen.s"

	;==============================
	; Run Tests
	;==============================

.include "test.s"

	;===========================
	; common routines
	;===========================

	.include "common_routines.s"

	;==========================
	; graphics
	;==========================
.align $100
	.include "e7_title.inc"
	.include "number_font.inc"

; e7 signature for MAME */
; this is LDA $FFE5
;.byte $ad, $e5, $ff

.segment "BANKSWITCH"
	.byte $00

.segment "IRQ_VECTORS"
	.word e7_test	; NMI
	.word e7_test	; RESET
	.byte $E7,$00	; IRQ
