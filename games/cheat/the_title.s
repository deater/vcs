; C.H.E.A.T. Title Screen

; o/~ F o/~
; that's not F

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"
.include "zp.inc"

; we're in bank0 here

switch_to_bank1_and_start_strongbadia:
	bit	$1FF9		; switch to bank1
				; this is followed by a jumpg
switched_from_bank1_and_start_game:
	jmp	the_cheat_start

bubs_start:
switch_to_bank1_and_bubs:
	bit	$1FF9

switched_from_bank0_and_start_game_over:
	jmp	game_over

switch_to_bank1_andq:
	bit	$1FF9

switched_from_bank0_and_blue_or_win:
	cpy	#0
	bne	goto_blue_land		; Y is NEW_LEVEL here
	jmp	you_win
goto_blue_land:
	jmp	blue_land

the_cheat_start:

	;=======================
	; clear registers/ZP/TIA
	;=======================

	sei			; disable interrupts
	cld			; clear decimal mode
	ldx	#0
	txa
clear_loop:
	dex
	txs
	pha
	bne	clear_loop

	; S = $FF, A=$0, x=$0, Y=??

	.include "title.s"

	.include "game_over_screen.s"



; 38

;.include "title_sprites.inc"
.include "cheat2_trackdata.s"
.include "cheat2_player.s"

.include "sound_update.s"
;.include "sfx.inc"
;.include "game_over.inc"

.include "blue.s"
.include "position.s"
.include "update_score.s"
.include "draw_score.s"
.include "common_movement.s"
.include "level_data.s"
.include "sound_trigger.s"
.include "you_win.s"
;.include "fireworks_kernel.s"

strongbadia_start:
the_stick:
the_pit:

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
.include "game_data2.inc"


.segment "IRQ_VECTORS"
	.word the_cheat_start	; NMI
	.word the_cheat_start	; RESET
	.word the_cheat_start	; IRQ
