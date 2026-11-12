; sierzoom for Atari 2600

; For E7 bank-switched cartridge (16k ROM, 2k RAM)

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"

.include "zp.inc"

	;==============================
	;==============================

sierzoom:
	sei		; disable interrupts
	cld		; clear decimal bit

restart:

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
	; Run Scenes
	;==============================

	sta	E7_SET_BANK7_RAM

again:

	jsr	do_framebuffer

	jmp	again


	;===========================
	; common routines
	;===========================

	.include "common_routines.s"




.align $100
	.include "framebuffer.s"
	.include "sierzoom_effect.s"


; e7 signature for MAME */
; this is LDA $FFE5
;.byte $ad, $e5, $ff

.segment "BANKSWITCH"
	.byte $00

.segment "IRQ_VECTORS"
	.word sierzoom	; NMI
	.word sierzoom	; RESET
	.byte $E7,$00	; IRQ
