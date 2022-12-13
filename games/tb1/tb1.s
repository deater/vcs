; Tom Bombem for NTSC Atari 2600/VCS
;

; by Vince `deater` Weaver	<vince@deater.net>

.include "../../vcs.inc"

.include "zp.inc"


tb1:
	;=============================
	; clear out mem / init things
	;=============================
	; initialize the 6507
	;       and clear RAM
	;==========================

	sei			; disable interrupts			; 2
	cld			; clear decimal mode			; 2
restart_game:
	ldx	#0							; 2
	txa								; 2
clear_loop:
	dex								; 2
	txs								; 2
	pha								; 3
	bne	clear_loop						; 2/3
						;============================
	; S = $FF, A=$0, x=$0, Y=??		;       8+(256*10)-1=2567 / 10B



title_screen:

	.include "title_screen.s"

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
.include	"common_routines.s"

; data, which has alignment constraints
.align $100
;.include	"game_data.inc"
;.include	"level_playfields.inc"
;.include	"level_data.inc"
.include	"title.inc"

.segment "IRQ_VECTORS"
	.word tb1	; NMI
	.word tb1	; RESET
	.word tb1	; IRQ
