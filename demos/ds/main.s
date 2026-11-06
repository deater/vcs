; ds for Atari 2600

; For E7 bank-switched cartridge (16k ROM, 2k RAM)

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"

.include "zp.inc"

.include "bank0_routines.inc"
.include "bank1_routines.inc"
.include "bank2_routines.inc"
.include "bank3_routines.inc"
.include "bank4_routines.inc"
.include "bank5_routines.inc"
.include "bank6_routines.inc"

	;==============================
	;==============================

e7_test:
	sei		; disable interrupts
	cld		; clear decimal bit

restart_test:

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
	; init music
	;==============================

.include "bank6_music/trial00e4_init.s"

	;==============================
	; var init
	;==============================


;	lda	#3
;	sta	BANK_256

;	lda	#4
;	sta	BANK_1K

	; init code sets to 0

	;==============================
	; Run Scenes
	;==============================
again:

	sta	E7_SET_BANK0
	jsr	do_title

;	sta	E7_SET_BANK1
;	jsr	do_bounce

;	sta	E7_SET_BANK2
;	jsr	do_desktop

;	sta	E7_SET_BANK3
;	jsr	do_knowthis

;	sta	E7_SET_BANK4
;	jsr	do_plasma

;	sta	E7_SET_BANK5
;	jsr	do_credits

	jsr	title_screen	; wastes 2 bytes of stack?


	;===========================
	; common routines
	;===========================

	.include "zx02_optim.s"
	.include "common_routines.s"


	;===========================
	; trampoline to music code
	;===========================
do_play_music:
	sta	PAGE_SAVE
	sta	E7_SET_BANK6
	jsr	play_music

	; restore page

	ldx	PAGE_SAVE
	sta	E7_SET_BANK0,X
	rts



.align $100
	.include "title_screen.s"

.if 0
	.include "memory_test.s"
	.include "print_word.s"
	.include "print_byte.s"
	.include "print_string.s"
	.include "update_byte.s"
	.include "center_string.s"
	.include "joypad_routines.s"

	;==========================
	; graphics
	;==========================
;.align $100
	.include "strings.inc"
	.include "number_font.inc"

.endif


; e7 signature for MAME */
; this is LDA $FFE5
;.byte $ad, $e5, $ff

.segment "BANKSWITCH"
	.byte $00

.segment "IRQ_VECTORS"
	.word e7_test	; NMI
	.word e7_test	; RESET
	.byte $E7,$00	; IRQ
