; C.H.E.A.T. Gameplay

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"
.include "zp.inc"

; this is bank1



	; if we accidentally come up with bank1 enabled, switch
	; to bank0 to run the title
the_cheat_start:
switch_to_bank0_and_start_game:
; 38
	bit	$1FF8
; 42
switched_from_bank0_and_start_strongbadia:
	jmp	strongbadia

switch_to_bank0_and_game_over:
	bit	$1FF8

switched_from_bank0_and:
	jmp	switched_from_bank0_and

blue_land:
switch_to_bank0_and_blue_land:
	bit	$1FF8

switched_from_bank0_andq:
	jmp	switched_from_bank0_andq


	;=========================
	; gameplay
	;=========================


	.include "strongbadia.s"


.include "position.s"
.include "bubs.s"
;.include "blue.s"
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
