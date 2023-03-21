; C.H.E.A.T. Gameplay

; by Vince `deater` Weaver <vince@deater.net>

; runs in bank1

.include "../../vcs.inc"
.include "zp.inc"

the_cheat_start:

	; if we accidentally come up with bank1 enabled, switch
	; to bank0 to run the title

switch_bank0:
; 38
	bit	$1FF8
; 42
	;=========================
	; gameplay
	;=========================


	.include "strongbadia.s"


.include "position.s"
.include "blue.s"
.include "pit.s"
.include "draw_score.s"
.include "update_score.s"
.include "common_movement.s"
.include "level_data.s"


.include "random16.s"
.include "the_stick.s"
.include "sound_trigger.s"
.include "sound_update.s"

	;====================
	; scanline wait
	;====================
	; scanlines to wait in X

scanline_wait:
	sta	WSYNC
	dex						; 2
	bne	scanline_wait				; 2/3
	rts						; 6


.align $100

.include "game_data.inc"

.segment "IRQ_VECTORS"
	.word the_cheat_start	; NMI
	.word the_cheat_start	; RESET
	.word the_cheat_start	; IRQ



