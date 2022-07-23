; secret collect.
;
;	for NTSC Atari 2600/VCS
;
; based on the Videlectrix game from Homestarrunner.com
;

; by Vince `deater` Weaver	<vince@deater.net>

.include "../vcs.inc"

; zero page addresses
STRONGBAD_X		=	$80
STRONGBAD_Y		=	$81
OLD_STRONGBAD_X		=	$82
OLD_STRONGBAD_Y		=	$83
STRONGBAD_Y_END		=	$84
OLD_STRONGBAD_Y_END	=	$85
;STRONGBAD_X_END	=	$86
;OLD_STRONGBAD_X_END	=	$87
STRONGBAD_X_COARSE	=	$88
CURRENT_SCANLINE	=	$89
FRAME			=	$8A
LEVEL			=	$8B
INL			=	$8C
INH			=	$8D
SCORE_LOW		=	$8E
SCORE_HIGH		=	$8F


TEMP1			=	$90
TEMP2			=	$91

TIME			=	$92
TIME_SUBSECOND		=	$93
LEVEL_OVER		=	$94
	LEVEL_OVER_SC = $80
	LEVEL_OVER_GO = $40
	LEVEL_OVER_ZAP= $20
	LEVEL_OVER_TIME=$10
BACKGROUND_COLOR	=	$95
MANS			=	$96
ZAP_BASE		=	$97
ZAP_COLOR		=	$98
ZAP_OFFSET		=	$99

SFX_RIGHT		=	$9A
SFX_LEFT		=	$9B
TITLE_COUNTDOWN		=	$9C
TITLE_COLOR		=	$9D
DONE_TITLE		=	$9E
BASE_TITLE_COLOR	=	$9F

SCORE_SPRITE_LOW_0	=	$A0
SCORE_SPRITE_LOW_1	=	$A1
SCORE_SPRITE_LOW_2	=	$A2
SCORE_SPRITE_LOW_3	=	$A3
SCORE_SPRITE_LOW_4	=	$A4
SCORE_SPRITE_LOW_5	=	$A5
SCORE_SPRITE_LOW_6	=	$A6

SCORE_SPRITE_HIGH_0	=	$A7
SCORE_SPRITE_HIGH_1	=	$A8
SCORE_SPRITE_HIGH_2	=	$A9
SCORE_SPRITE_HIGH_3	=	$AA
SCORE_SPRITE_HIGH_4	=	$AB
SCORE_SPRITE_HIGH_5	=	$AC
SCORE_SPRITE_HIGH_6	=	$AD

TEXT_COLOR		=	$AE
LEVEL_COLOR		=	$AF

MANS_SPRITE_0		=	$B0
MANS_SPRITE_1		=	$B1
MANS_SPRITE_2		=	$B2
MANS_SPRITE_3		=	$B3
MANS_SPRITE_4		=	$B4
MANS_SPRITE_5		=	$B5
MANS_SPRITE_6		=	$B6
TRIGGER_SOUND		=	$B7

LEVEL_SPRITE0		=	$C0
LEVEL_SPRITE1		=	$C1
LEVEL_SPRITE2		=	$C2
LEVEL_SPRITE3		=	$C3
LEVEL_SPRITE4		=	$C4
LEVEL_SPRITE5		=	$C5
LEVEL_SPRITE6		=	$C6
LEVEL_SPRITE7		=	$C7
LEVEL_SPRITE8		=	$C8
LEVEL_SPRITE9		=	$C9
LEVEL_SPRITE10		=	$CA
LEVEL_SPRITE11		=	$CB
LEVEL_SPRITE12		=	$CC
LEVEL_SPRITE13		=	$CD
LEVEL_SPRITE14		=	$CE
LEVEL_SPRITE15		=	$CF

; Level info
LEVEL_INFO		=	SECRET_X_START	; use as pointer to this

SECRET_X_START		=	$D0
SECRET_Y_START		=	$D1
PF0_ZPL			=	$D2
PF0_ZPH			=	$D3
PF1_ZPL			=	$D4
PF1_ZPH			=	$D5
PF2_ZPL			=	$D6
PF2_ZPH			=	$D7

SECRET_Y_END		=	$D8
SECRET_X_COARSE		=	$D9
SECRET_X_FINE		=	$DA
SECRET_ON		=	$DB

; we wanted 16-bytes of state, but no room...
.if 0
SECRET_X		=	$D0
SECRET_Y_START		=	$D1
SECRET_Y_END		=	$D2
FUTURE4			=	$D3
BONUS_X			=	$D4
BONUS_Y			=	$D5
ZAP_BEGIN		=	$D6
ZAP_END			=	$D7
STRONGBAD_X		=	$D8
STRONGBAD_Y		=	$D9
PF0_ZPL			=	$DA
PF0_ZPH			=	$DB
PF1_ZPL			=	$DC
PF1_ZPH			=	$DD
PF2_ZPL			=	$DE
PF2_ZPH			=	$DF
.endif



start:
	;============================
	;============================
	; initial init
	;============================
	;============================

	sei			; disable interrupts
	cld			; clear decimal mode

	ldx	#$FF		; set stack to $1FF (mirrored at $FF)
	txs

restart_game:
	lda	#2
	sta	VBLANK		; disable beam

	jsr	init_game

	jsr	init_level

title_screen:

	.include "title_screen.s"

do_level:

	.include "level_engine.s"


secret_collect_animation:

	.include "sc_screen.s"

game_over_animation:

	.include "game_over_screen.s"


;.include	"adjust_sprite.s"
.include	"init_game.s"
.include	"init_level.s"
.include	"sound_trigger.s"
.include	"sound_update.s"

; data, which has alignment constraints
.include	"game_data.inc"
.include	"level_playfields.inc"
.include	"level_data.inc"

; FIXME: move to gaps
;.byte "by Vince `deater` Weaver <vince@deater.net>"

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ
