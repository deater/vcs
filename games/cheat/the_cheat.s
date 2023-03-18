; the cheat?

; o/~ F o/~
; that's not F

; by Vince `deater` Weaver <vince@deater.net>

.include "../../vcs.inc"
.include "zp.inc"

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

	lda	#$E			; setup debounce
	sta	TITLE_COUNTDOWN

; =====================================================================
; Initialize music.
; Set tt_cur_pat_index_c0/1 to the indexes of the first patterns from
; tt_SequenceTable for each channel.
; Set tt_timer and tt_cur_note_index_c0/1 to 0.
; All other variables can start with any value.
; =====================================================================
        lda #0
        sta tt_cur_pat_index_c0
        lda #11
        sta tt_cur_pat_index_c1
        ; the rest should be 0 already from startup code. If not,
        ; set the following variables to 0 manually:
        ; - tt_timer
        ; - tt_cur_pat_index_c0
        ; - tt_cur_pat_index_c1
        ; - tt_cur_note_index_c0
        ; - tt_cur_note_index_c1


	;=========================
	; title
	;=========================

	.include "title.s"

	;=========================
	; gameplay
	;=========================


	.include "strongbadia.s"

.include "title_pf.inc"
.align $100
.include "title_sprites.inc"
.include "strongbadia.inc"

.include "cheat2_trackdata.s"
.include "cheat2_player.s"

.include "position.s"

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
