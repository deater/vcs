; Snake Boxer5

; based on the Videlectrix game

; by Vince `deater` Weaver <vince@deater.net>

.include "../../../vcs.inc"

.include "../zp.inc"

; this is bank1 (title is bank0) of an 8k cartridge

; if we accidentally come up with bank1 active, jump to bank0


start:
switch_to_bank0_and_reset:
	bit	$1FF8			; switch to bank0, execution continues
					; at start of cartridge

switched_from_bank0_and_start_game:
	jmp	gameplay		; get here if in bank0 switched to
					; bank1

switch_to_bank0_and_start_title:
	bit	$1FF8			; switch to bank0 and re-run title

	jmp	gameplay		; came from bank0?
					; FIXME: is this needed?
gameplay:

.include "boxing_ring.s"

	; if finish, restart game?
	; maybe go to title instead of to videlectrix?

	jmp	switch_to_bank0_and_reset

.include "../position.s"
.include "../common_routines.s"
.include "../random8.s"
.include "sound_update.s"
.include "sound_trigger.s"
.include "sfx.inc"

.include "game_data.inc"

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ


