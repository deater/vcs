; Videlectrix Intro and Title for Snake Boxer 5

; based on the Videlectrix game Snake Boxer 5

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"

.include "zp.inc"

start:
	sei		; disable interrupts
	cld		; clear decimal bit


restart_game:

	; init zero page and addresses to 0

	ldx	#0
	txa
clear_loop:
	dex
	txs
	pha
	bne	clear_loop

	; S=$FF, A=$00, X=$00, Y=??


	.include "videlectrix.s"

	.include "title_screen.s"

.include "position.s"

.include "common_routines.s"

.include "sound_notes.s"

.include "delay.s"

.align $100
.include "title_data.inc"

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ







