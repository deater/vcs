; Myst for Atari 2600

; For E7 bank-switched cartridge (16k ROM, 2k RAM)

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"

.include "zp.inc"
.include "locations.inc"

.include "locations/level_locations.inc"
.include "bank5_clock/rom5_locations.inc"
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
	dex
	txs
	pha
	bne	clear_loop

	; S=$FF, A=$00, X=$00, Y=??


	;==============================
	; Run intro (ROM bank 6)
	;==============================

	sta	E7_SET_BANK6		; intro is in rom bank6
	sta	E7_SET_256_BANK0	; not necessary?

	; this shows the MYST logo as well as the cleft

	jsr	do_intro

	;==============================
	; Show book (ROM bank 6)
	;==============================

	ldy	#LOCATION_ARRIVAL_N
	sty	CURRENT_LOCATION
	sty	LINK_DESTINATION

	jsr	do_book

	; DEBUG
;	lda	#$FF
;	sta	SWITCH_STATUS


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
	.include "position.s"
	.include "common_routines.s"
	.include "hand_update.s"

	.include "sprite_data.inc"

	.include "zx02_optim.s"


do_book:
	; switch to bank 6
	sta	E7_SET_BANK6

	jmp	book_common



; e7 signature for MAME */
; this is LDA $FFE5
;.byte $ad, $e5, $ff

.segment "BANKSWITCH"
	.byte $00

.segment "IRQ_VECTORS"
	.word myst	; NMI
	.word myst	; RESET
	.byte $E7,$00	; IRQ
