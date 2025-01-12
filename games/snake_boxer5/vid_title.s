; Videlectrix Intro and Title for Snake Boxer 5

; based on the Videlectrix game Snake Boxer 5

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"

.include "zp.inc"

; we're in bank0 here

switch_to_bank1_and_start_game:
	bit	$1FF9		; switch to bank1
				; this is followed by a jump there

switched_from_bank1_and_reset:
	jmp	start

	bit	$1FF9		; switch to bank1
switched_from_bank1_and_title:
	jmp	do_title

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

	;============================
	; do videlectrix intro
	;============================

	.include "videlectrix.s"

	;============================
	; do title screen
	;============================
do_title:
	.include "title_screen.s"

	;============================
	; done with title, start game
	;============================

	jmp	switch_to_bank1_and_start_game


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

