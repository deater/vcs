; Snake Boxer5

; based on the Videlectrix game

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"

.include "zp.inc"

; this is bank1 (title is bank0) of an 8k cartridge

; if we accidentally come up with bank1 active, jump to bank0


start:
switch_to_bank0_and_start_game:
	bit	$1FF8

switched_from_bank0_and_start_game:
	jmp	gameplay


gameplay:

.include "boxing_ring.s"

	; if finish, restart game?
	; maybe go to title instead of to videlectrix?

	jmp	switch_to_bank0_and_start_game


.include "common_routines.s"

.include "game_data.inc"

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ


