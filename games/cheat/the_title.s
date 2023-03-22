; C.H.E.A.T. Title Screen

; o/~ F o/~
; that's not F

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"
.include "zp.inc"

switch_bank1:
	bit	$1FF9		; switch to bank1


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



.include "title_sprites.inc"
.include "cheat2_trackdata.s"
.include "cheat2_player.s"

.include "sound_update.s"
;.include "sfx.inc"
;.include "game_over.inc"

;.include "bubs.s"
;.include "position.s"
;.include "update_score.s"
.include "draw_score.s"
.include "common_movement.s"
.include "level_data.s"
.include "sound_trigger.s"



strongbadia_start:
the_stick:
the_pit:
blue_land:
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
.include "title_pf.inc"
.include "game_data2.inc"
.align $100
.include "bearshark.inc"


.segment "IRQ_VECTORS"
	.word the_cheat_start	; NMI
	.word the_cheat_start	; RESET
	.word the_cheat_start	; IRQ
