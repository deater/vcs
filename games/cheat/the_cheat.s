; C.H.E.A.T. Gameplay

; by Vince `deater` Weaver <vince@deater.net>

; runs in bank1

.include "../../vcs.inc"
.include "zp.inc"

the_cheat_start:

	; if we accidentally come up with bank1 enabled, switch
	; to bank0 to run the title

switch_bank0:
	bit	$1FF8

	;=========================
	; gameplay
	;=========================


	.include "strongbadia.s"

.include "strongbadia.inc"


.include "position.s"
.include "blue.s"
;.align $100
.include "draw_score.s"
.include "update_score.s"
.include "common_movement.s"
.include "level_data.s"

.include "blue.inc"

	;====================
	; scanline wait
	;====================
	; scanlines to wait in X

scanline_wait:
	sta	WSYNC
	dex						; 2
	bne	scanline_wait				; 2/3
	rts						; 6

	;==================
	; increment frame
	;==================
	; worst case 18
inc_frame:
	inc	FRAME					; 5
	bne	no_inc_high				; 2/3
	inc	FRAMEH					; 5
no_inc_high:
	rts						; 6

score_bitmap0:  ; turns out this was same pattern
score_zeros:    .byte $22,$55,$55,$55,$55,$55,$22,$00
score_ones:     .byte $22,$66,$22,$22,$22,$22,$77,$00
score_twos:     .byte $22,$55,$11,$22,$44,$44,$77,$00
score_threes:   .byte $22,$55,$11,$22,$11,$55,$22,$00
score_fours:    .byte $55,$55,$55,$77,$11,$11,$11,$00

; --****** ----**-- --****** ----**-- ----**--
; --**---- --**--** ------** --**--** --**--**
; --****-- --**---- ------** --**--** --**--**
; ------** --****-- ----**-- ----**-- ----****
; ------** --**--** --**---- --**--** ------**
; --**--** --**--** --**---- --**--** --**--**
; ----**-- ----**-- --**---- ----**-- ----**--

score_fives:    .byte   $77,$44,$66,$11,$11,$55,$22,$00
score_sixes:    .byte   $33,$44,$44,$66,$55,$55,$22,$00
score_sevens:   .byte   $77,$11,$11,$22,$44,$44,$44,$00
score_eights:   .byte   $22,$55,$55,$22,$55,$55,$22,$00
score_nines:    .byte   $22,$55,$55,$33,$11,$55,$22,$00


.segment "IRQ_VECTORS"
	.word the_cheat_start	; NMI
	.word the_cheat_start	; RESET
	.word the_cheat_start	; IRQ
