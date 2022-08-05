; Myst for Atari 2600

; For E7 bank-switched cartridge (16k ROM, 2k RAM)

; by Vince `deater` Weaver <vince@deater.net>

.include "../vcs.inc"

.include "zp.inc"
.include "locations.inc"

	;==============================
	;==============================


myst:
	sei		; disable interrupts
	cld		; clear decimal bit

restart_game:


	; init zero page and addresses to 0

	ldx	#0
	txa
clear_loop:
	sta	$0,X
	inx
	bne	clear_loop
	dex
	txs	; point stack to $1FF (mirrored at top of zero page)

	lda	#2
	sta	VBLANK	; disable beam


	;==============================
	; Run intro (bank 6)
	;==============================

	lda	$FFE6

	jsr	$1000

	ldy	#LOCATION_ARRIVAL
	sty	CURRENT_LOCATION

	;==============================
	; load in current level
	;==============================
load_new_level:
	jsr	load_level


	;===========================
	;===========================
	; main engine
	;===========================
	;===========================


	.include "level_engine.s"

	;===========================
	; common routines
	;===========================

	.include "load_level.s"
	.include "adjust_sprite.s"
	.include "common_routines.s"
	.include "hand_motion.s"
	.include "hand_copy.s"
	.include "sound_update.s"
	.include "zx02_optim.s"

	.include "sfx_data.inc"
	.include "sprite_data.inc"

clock_data_zx02:
;	.incbin "locations/clock_data.zx02"

;.include "myst_data.inc"

.segment "IRQ_VECTORS"
	.word myst	; NMI
	.word myst	; RESET
	.byte $E7,$00	; IRQ
