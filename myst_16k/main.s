; Myst for Atari 2600

; For E7 bank-switched cartridge (16k ROM, 2k RAM)

; by Vince `deater` Weaver <vince@deater.net>

.include "../vcs.inc"

.include "zp.inc"
.include "locations.inc"

.include "rom_bank6_routines.inc"

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

	sta	E7_SET_BANK6		; intro is in rom bank6
	sta	E7_SET_256_BANK0	; not necessary?

	jsr	do_intro

	ldy	#LOCATION_ARRIVAL_N
	sty	CURRENT_LOCATION
	sty	LINK_DESTINATION

	jsr	do_book

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


do_book:
	; switch to bank 6
	sta	E7_SET_BANK6

	jmp	book_common


	.include "sfx_data.inc"
.align $100 ; temporary
	.include "sprite_data.inc"

; e7 signature for MAME */
; this is LDA $FFE5
;.byte $ad, $e5, $ff

.segment "IRQ_VECTORS"
	.word myst	; NMI
	.word myst	; RESET
	.byte $E7,$00	; IRQ
