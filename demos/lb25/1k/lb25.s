; 1k demo?

; by Vince `deater` Weaver

.include "../../../vcs.inc"

; zero page addresses

.include "zp.inc"

.include "deetia2_variables.s"

	;=============================
	; clear out mem / init things
	;=============================

lb25:

	; TODO: can we move txs outside loop?

	sei			; disable interrupts			; 2
	cld			; clear decimal mode			; 2
	ldx	#0							; 2
	txa								; 2
clear_loop:
	dex								; 2
	txs								; 2
	pha								; 3
	bne	clear_loop						; 2/3
						;============================
	; S = $FF, A=$0, x=$0, Y=??		;	8+(256*10)-1=2567 / 10B


	; =========================
	; Initialize music.
	; Set tt_cur_pat_index_c0/1 to the indexes of the first patterns from
	; tt_SequenceTable for each channel.
	; Set tt_timer and tt_cur_note_index_c0/1 to 0.
	; All other variables can start with any value.
	; =========================

	lda	#0
	sta	tt_cur_pat_index_c0
	lda	#50
	sta	tt_cur_pat_index_c1

;======================================================================
; MAIN LOOP
;======================================================================


	; init rasterbars
	ldy	#90
	sty	RASTER_G_Y
	ldy	#122
	sty	RASTER_R_Y
	ldy	#154
	sty	RASTER_B_Y
	inc	RASTER_R_YADD
	inc	RASTER_B_YADD
	inc	RASTER_G_YADD

	ldy	#63

	sty	LOGO_Y
	ldy	#100
	sty	SPRITE0_X
	sty	SPRITE0_Y
	sty	SPRITE1_X
	dec	SPRITE0_XADD
	inc	SPRITE0_YADD
	inc	SPRITE0_YADD
	inc	SPRITE1_XADD


;======================================================================
; MAIN LOOP
;======================================================================

; Technically
;		vsync	vblank	screen	overscan
;	PAL	3	37	242	30		= 312
;	NTSC	3	37	192	30		= 262
;
; This demo for some reason did
;	PAL	3	45	228	36		= 312

tia_frame:

	;========================
	; start VBLANK
	;========================
	; in scanline 0

	jsr	common_vblank

	;================================
	; 45 lines of VBLANK (37 on NTSC)
	;================================


	;========================
	; update music player
	;========================
	; worst case for this particular song seems to be
	;	around 9 * 64 = 576 cycles = 8 scanlines
	;	make it 12 * 64 = 11 scanlines to be safe

	; Original is 43 * 64 cycles = 2752/76 = 36.2 scanlines

	lda	#12		; TIM_VBLANK
	sta	TIM64T


	;=======================
	; run the music player
	;=======================

.include "deetia2_player.s"

	; Measure player worst case timing
	lda	#12		; TIM_VBLANK
	sec
	sbc	INTIM
	cmp	player_time_max
	bcc	no_new_max
	sta	player_time_max
no_new_max:


wait_for_vblank:
        lda	INTIM
        bne	wait_for_vblank

	; in theory we are 11 scanlines in

	sta	WSYNC

	;=====================================================
	; VBLANK scanline 12 -- handle frame / switch effects
	;=====================================================

	inc	FRAMEL                                                  ; 5
	bne	no_frame_oflo						; 2/3
frame_oflo:
        inc	FRAMEH                                                  ; 5
no_frame_oflo:

	; switch effects


	clc
	lda	FRAMEL
	rol
	bne	same_effect
	lda	FRAMEH
	rol

;	lda	FRAMEL							; 3
;	bne	same_effect						; 2/3
;	lda	FRAMEH							; 3
check3:
	cmp	#$6			; $03:00 15s, move on to parallax
	beq	next_effect
	cmp	#$C			; $06:00 ??s, move on to bitmap
	beq	next_effect
	cmp	#$F			; $07:80 ??s, move on to rasterbar
	beq	next_effect
	cmp	#$15			; $0A:80 ??s, move on to fireworks
	beq	next_effect
	cmp	#$25			; $12:80 ??s done?
	bne	same_effect
;	lda	#$ff			; loop
;	sta	WHICH_EFFECT
	jmp	lb25			; restart
next_effect:
	inc	WHICH_EFFECT
same_effect:


	;=======================
	; wait the rest
	;=======================
	; want to come in with 8 scanlines remaining
	;	so 37 (of 45) on PAL
	;	so 29 (of 37) on NTSC
	; subtract 11 we already did

	ldx	#18							; 2

le_vblank_loop:
	sta     WSYNC							; 3
	dex								; 2
	bne	le_vblank_loop						; 2/3

	;============================
	; choose which effect to run
	;============================
; 4
	ldx	WHICH_EFFECT						; 3
	lda	jmp_table_low,X						; 4
	sta	INL							; 3
	lda	jmp_table_high,X					; 4
	sta	INH							; 3
	jmp	(INL)							; 5
; 26

jmp_table_low:
	.byte <logo_effect
;	.byte <parallax_effect
;	.byte <bitmap_effect
;	.byte <raster_effect
;	.byte <firework_effect


jmp_table_high:
	.byte >logo_effect
;	.byte >parallax_effect
;	.byte >bitmap_effect
;	.byte >raster_effect
;	.byte >firework_effect



	;============================
	; handle overscan
	;============================
	; NTSC 30 / PAL 36
	; 	unsure why we do one extra?

	; should arrive 3 cycles after a WSYNC

effect_done:

; 3
	lda	#2		; we want this to happen in hblank	; 2
	sta	VBLANK		;					; 3
; 8
	; turn off everything

	lda	#0
	sta	GRP0							; 3
	sta	GRP1							; 3
	sta	PF0							; 3
	sta	PF1							; 3
	sta	PF2							; 3
; 23

	;=============================
	; overscan
	;=============================

common_overscan:


	ldx	#31


	;============================
	; common delay scanlines?
	; value in X?

common_delay_scanlines:
	sta	WSYNC							; 3
	dex								; 2
	bne	common_delay_scanlines					; 2/3

	jmp	tia_frame

	LOGO_SIZE=33


LOGO_BOUNCE_TOP	= 14
LOGO_BOUNCE_BOTTOM = (177-LOGO_SIZE*2-1)


	;================================================
	; draws logo effect
	;================================================
	; comes in with 8 cycles left in VBLANK

logo_effect:

	; FIXME: make this a loop

	; 37
	sta	WSYNC
	; 38
	sta	WSYNC
	; 39
	sta	WSYNC
	; 40
	sta	WSYNC
	; 41
	sta	WSYNC
	; 42
	sta	WSYNC

	;===============================
	; line 43 -- check if move logo
	;===============================
	; start it at 1:80

	lda	FRAMEL							; 3
	cmp	#$80							; 2
	bne	no_start_logo						; 2/3
	lda	FRAMEH							; 3
	cmp	#1							; 2
	bne	no_start_logo						; 2/3

	inc	LOGO_YADD						; 5

no_start_logo:

	; stop if at 2:a#
	lda	FRAMEL
	cmp	#$A3
	bne	no_stop_logo
	lda	FRAMEH
	cmp	#2
	bne	no_stop_logo

	lda	#0
	sta	LOGO_YADD

no_stop_logo:

	sta	WSYNC


	;================================================
	; VBLANK scanline 44 -- adjust Y
	;================================================
; 0
	lda	LOGO_YADD					; 3
	clc							; 2
	adc	LOGO_Y						; 3
        sta	LOGO_Y						; 3
        cmp	#LOGO_BOUNCE_BOTTOM				; 2
; 13
        bcs	logo_invert_y			; bge		; 2/3
        cmp	#LOGO_BOUNCE_TOP				; 2
        bcs	logo_done_y			; bge		; 2/3
logo_invert_y:
	lda	LOGO_YADD					; 3
	eor	#$FF						; 2
	clc							; 2
	adc	#1						; 2
	sta	LOGO_YADD					; 3

logo_done_y:
        sta     WSYNC


	;=================================
	; VBLANK scanline 45
	;=================================
; 0
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3
; 5

	; update bg color
	lda	FRAMEL							; 3
	lsr								; 2
	lsr								; 2
	lsr								; 2
	and	#$7							; 2
	tax								; 2
	lda	bg_colors,X						; 4+
        sta	COLUBK							; 3
	sta	SAVED_COLUBK
; 25
	lda	#0							; 2
	sta	VDELP0							; 3
	sta	VDELP1		; turn off delay			; 3
; 33

;	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_8			; 2
;	sta	NUSIZ0							; 3
;	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_8			; 2
;	sta	NUSIZ1							; 3
; 43
	; move the logo

	clc								; 2
	lda	LOGO_Y							; 3
	adc	LOGO_YADD						; 3
	sta	LOGO_Y							; 3
; 54

	ldy	#0							; 2
	ldx	#0							; 2
; 58
	sta	WSYNC							; 3
; 61


	;=========================
	;=========================
	; kernel
	;=========================
	;=========================
	; 228 scanlines (192 on NTSC)

	; comes in at 3 cycles

	jmp	start_ahead						; 3

draw_playfield:
; 3

draw_logo:
	sta	WSYNC
; 0
	sta	COLUBK							; 3
; 3
	lda	desire_colors,Y						; 4
	sta	COLUPF							; 3
; 10
	lda	desire_playfield0_left,Y	; playfield pattern 0	; 4
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 17
	lda	desire_playfield1_left,Y	; playfield pattern 1	; 4
	sta	PF1			;				; 3
        ;  has to happen by 28 (GPU 84)
; 24
	lda	desire_playfield2_left,Y	; playfield pattern 2	; 4
	sta	PF2							; 3
        ;  has to happen by 38 (GPU 116)	;
; 31
	lda	desire_playfield0_right,Y	; left pf pattern 0     ; 4
	sta	PF0				;                       ; 3
	; has to happen 28-49 (GPU 84-148)
; 38
	lda	desire_playfield1_right,Y	; left pf pattern 1	; 4
	sta	PF1				;			; 3
	; has to happen 38-56 (GPU 116-170)
; 45
	lda	desire_playfield2_right,Y	; left pf pattern 2	; 4
	sta	PF2				;			; 3
	; has to happen 49-67 (GPU148-202)
; 52
	inx		; inc scanline					; 2
	txa								; 2
	lsr		; divide by 2					; 2
; 58
	bcc	noc	; skip if odd					; 2/3
	dey					; decrement logo count	; 2
	beq	done_logo						; 2/3
; 64
noc:
; 64 / 61
	lda	desire_bg_colors,Y					; 4
; 68
done_logo:
;	sta	WSYNC							; 3
	bne	draw_logo						; 2/3


; 2/3
draw_nothing:

	inx				; inc current scanline		; 2

start_ahead:
; 5 / 54

	lda	SAVED_COLUBK
	sta	COLUBK

	; see if line equals Y location?
	cpx	LOGO_Y							; 2
	bne	not_logo_start						; 2/3
	ldy	#LOGO_SIZE		; set logo height		; 2
not_logo_start:
; 5

	; finish 1 early so time to clear up

	cpx	#190							; 2

	bcs	done_playfield						; 2/3
; 9
	lda	desire_bg_colors+LOGO_SIZE
	cpy	#0
; 67
	bne	draw_logo		; if so, draw it		; 2/3
	sta	WSYNC							; 3
	beq	draw_nothing		; otherwise draw nothing	; 2/3





done_playfield:

done_kernel:


	sta	WSYNC

	jmp	effect_done



bg_colors:

	; ntsc
	.byte $60,$90,$70,$A0, $A0,$70,$90,$60



.align $100

.include "desire_logo.inc"
;.include "fine_adjust.inc"

	;=====================
	; other includes


.include "common_routines.s"
;.include "credits.inc"

.align $100
;.include "bitmap.inc"

.include "deetia2_trackdata.s"

.segment "IRQ_VECTORS"
	.word lb25	; NMI
	.word lb25	; RESET
	.word lb25	; IRQ
