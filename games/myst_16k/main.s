; Myst for Atari 2600

; For E7 bank-switched cartridge (16k ROM, 2k RAM)

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"

.include "zp.inc"
.include "locations.inc"

.include "locations/level_locations.inc"
.include "rom_bank5_routines.inc"
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
	; var init
	;==============================

	lda	#$F8
	sta	LIBRARY_PAGE_MASK

	;==============================
	; Run intro
	;==============================

	;=============================
	; first run title (MYST logo)

	; title is now in BANK5

	sta	E7_SET_BANK5		; title is in rom bank6
	sta	E7_SET_256_BANK0	; not necessary?
	jsr	do_title

	;=============================
	; then run cleft

	; cleft is in BANK6

	sta	E7_SET_BANK6		; cleft is in rom bank6
	jsr	do_cleft

	;==============================
	; Show book (ROM bank 6)
	;==============================
	; this all happens in bank 6...

;	ldy	#LOCATION_ARRIVAL_N
;	sty	CURRENT_LOCATION
;	sty	LINK_DESTINATION

	; switch to bank 6
;	sta	E7_SET_BANK6	; not necessary, already in bank6?

;	jsr	book_common


	;==========================
	; DEBUG/debug
	;	makes getting white page easier

.if 0
	dec	SWITCH_STATUS
.else
	nop
	nop
.endif


	;==============================
	; load in current level
	;==============================
load_new_level:
;	jsr	load_level

	; we inline it now to save 4 bytes

	.include "load_level.s"

	;===========================
	;===========================
	; main engine
	;===========================
	;===========================

	.include "level_engine.s"

	;===========================
	; common routines
	;===========================

	.include "zx02_optim.s"

	.include "level_data.inc"
;	.include "load_level.s"
	.include "position.s"
	.include "common_routines.s"

;	.include "sound_update.s"
	.include "sfx_data.inc"


; e7 signature for MAME */
; this is LDA $FFE5
;.byte $ad, $e5, $ff

.segment "BANKSWITCH"
	.byte $00

.segment "IRQ_VECTORS"
	.word myst	; NMI
	.word myst	; RESET
	.byte $E7,$00	; IRQ
