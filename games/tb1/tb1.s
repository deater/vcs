; Tom Bombem for NTSC Atari 2600/VCS
;

; by Vince `deater` Weaver	<vince@deater.net>

.include "../../vcs.inc"

.include "zp.inc"


tb1:
	;============================
	;============================
	; initial init
	;============================
	;============================

	sei			; disable interrupts
	cld			; clear decimal mode

restart_game:

	;=========================================
	; init zero page and TIA registers to 0


	ldx	#0
	txa
clear_loop:
	sta	$0,X
	inx
	bne	clear_loop
	dex
	txs			; init stack pointer to $FF

	lda	#2
	sta	VBLANK		; disable beam

init_game:

	lda	#$90		; init the zappy wall colors		; 2
	sta	ZAP_BASE						; 3

	ldx	#3		; number of lives			; 2
	stx	MANS							; 3


title_screen:

;	.include "title_screen.s"

;	jsr	init_level


do_level:

;	.include "level_engine.s"


secret_collect_animation:

;	.include "sc_screen.s"

game_over_animation:

;	.include "game_over_screen.s"


;.include	"init_level.s"
;.include	"sound_trigger.s"
;.include	"sound_update.s"
;.include	"common_routines.s"

; data, which has alignment constraints
;.include	"game_data.inc"
;.include	"level_playfields.inc"
;.include	"level_data.inc"

.segment "IRQ_VECTORS"
	.word tb1	; NMI
	.word tb1	; RESET
	.word tb1	; IRQ
