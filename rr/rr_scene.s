
; =====================================================================
; Initialize music.
; Set tt_cur_pat_index_c0/1 to the indexes of the first patterns from
; tt_SequenceTable for each channel.
; Set tt_timer and tt_cur_note_index_c0/1 to 0.
; All other variables can start with any value.
; =====================================================================

	lda	#0
	sta	tt_cur_pat_index_c0
	lda	#12
	sta	tt_cur_pat_index_c1

	; the rest should be 0 already from startup code. If not,
	; set the following variables to 0 manually:
	; - tt_timer
	; - tt_cur_pat_index_c0
	; - tt_cur_pat_index_c1
	; - tt_cur_note_index_c0
	; - tt_cur_note_index_c1

;======================================================================
; MAIN LOOP
;======================================================================

rr_frame:

	;========================
	; start VBLANK
	;========================
	; in scanline 0

	jsr	common_vblank


	;=======================
	; 37 lines of VBLANK
	;=======================


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

.include "rr_player.s"

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

	; in theory we are 10 scanlines in, need to delay 27 more

	;=======================
	; wait the rest
	;=======================

	ldx	#23							; 2
le_vblank_loop:
	sta     WSYNC							; 3
	dex								; 2
	bne	le_vblank_loop						; 2/3


	;=========================
	; VBLANK scanline 33+34+35
	;=========================
; 4
	ldx	#15							; 2
copy_scene_data_loop:
	lda	scene_data,X						; 4+
	sta	LPF2_L,X						; 4
	dex								; 2
	bpl	copy_scene_data_loop					; 2/3
							;=====================
							; 2+(16*13)-1=209
; 213

	sta	WSYNC

	;=========================
	; VBLANK scanline 36
	;=========================
; 0
	nop
	nop
; 4
	inc	FRAME							; 5
; 9

	;==========================================
	; set up sprite0 to be at proper X position
	;==========================================

	ldx	#6
p0_pos_loop:
	dex
	bne	p0_pos_loop

	sta	RESP0
	sta	RESP1

	lda	#$30
	sta	HMP0
	lda	#$40
	sta	HMP1

	sta	WSYNC
	sta	HMOVE

	;=================================
	; VBLANK scanline 37
	;=================================

;
;	lda     #CTRLPF_REF		; reflect playfield		; 2
;	sta     CTRLPF							; 3
;

	lda	#0
	sta	VDELP0
	sta	VDELP1		; turn off delay


	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_8			; 2
	sta	NUSIZ0							; 3
	lda	#NUSIZ_QUAD_SIZE|NUSIZ_MISSILE_WIDTH_8			; 2
	sta	NUSIZ1							; 3

        lda	#6			; bg, light grey		; 2
        sta	COLUBK							; 3

	lda	#2							; 2
	sta	COLUPF			; fg, dark grey			; 3

;
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3

	sta	WSYNC							; 3


	sta	WSYNC


	;=========================
	;=========================
	; kernel
	;=========================
	;=========================
	; 192 cycles

	ldy	#0

kernel_loop:

	;==========================
	; scanline 0 (1/4)
	;==========================

	lda	#0		; always 0				; 2
	sta	PF0							; 3
	; has to happen by 22 (GPU 68)
; 5
	; also always 0
	sta	PF1							; 3
	; has to happen by 28 (GPU 84)
; 8
	lda	(LPF2_L),Y						; 5
	sta	PF2							; 3
	; has to happen by 38 (GPU 116)
; 16

	lda	(OV1SP_L),Y						; 5
	sta	GRP0							; 3
; 24
	lda	(OV1C_L),Y						; 5
	sta	COLUP0							; 3
; 32
	lda	(RPF0_L),Y						; 5
	tax								; 2
	sta	PF0							; 3
	; has to happen 28-49 (GPU 84-148)
; 42
	lda	(RPF1_L),Y						; 5
	sta	PF1							; 3
	; has to happen 39-56 (GPU 116-170)
; 50
	lda	(RPF2_L),Y						; 5
	sta	PF2							; 3
	sta	PF_TEMP							; 3
	; has to happen 50-67 (GPU 148-202)
; 61


	sta	WSYNC

	;==========================
	; scanline 1 (2/4)
	;==========================

	lda	#0		; always 0				; 2
	sta	PF0							; 3
	; has to happen by 22 (GPU 68)
; 5
	; also always 0
	sta	PF1							; 3
	; has to happen by 28 (GPU 84)
; 8
	lda	(LPF2_L),Y						; 5
	sta	PF2							; 3
	; has to happen by 38 (GPU 116)
; 16

	inc	TEMP1
	inc	TEMP1
	nop
	nop
	nop

;	lda	frame3_1_overlay_sprite,Y				; 5
;	sta	GRP0							; 3
; 24
;	lda	frame3_1_overlay_colors,Y				; 5
;	sta	COLUP0							; 3
; 32

;	lda	(RPF0_L),Y						; -
	stx	PF0							; 3
	; has to happen 28-49 (GPU 84-148)
; 35
	lda	(RPF1_L),Y						; 5
	sta	PF1							; 3
	; has to happen 39-56 (GPU 116-170)
; 43
;	lda	(RPF2_L),Y						; -
	lda	PF_TEMP							; 3
	sta	PF2							; 3
	; has to happen 50-67 (GPU 148-202)
; 49


	sta	WSYNC

	;==========================
	; scanline 2 (3/4)
	;==========================

	lda	#0		; always 0				; 2
	sta	PF0							; 3
	; has to happen by 22 (GPU 68)
; 5
	; also always 0
	sta	PF1							; 3
	; has to happen by 28 (GPU 84)
; 8
	lda	(LPF2_L),Y						; 5
	sta	PF2							; 3
	; has to happen by 38 (GPU 116)
; 16

	inc	TEMP1
	inc	TEMP1
	nop
	nop
	nop


;	lda	frame3_1_overlay_sprite,Y				; 5
;	sta	GRP0							; 3
; 24
;	lda	frame3_1_overlay_colors,Y				; 5
;	sta	COLUP0							; 3
; 32

;	lda	(RPF0_L),Y						; -
	stx	PF0							; 3
	; has to happen 28-49 (GPU 84-148)
; 35
	lda	(RPF1_L),Y						; 5
	sta	PF1							; 3
	; has to happen 39-56 (GPU 116-170)
; 43
;	lda	(RPF2_L),Y						; -
	lda	PF_TEMP							; 3
	sta	PF2							; 3
	; has to happen 50-67 (GPU 148-202)
; 49

	sta	WSYNC


	;==========================
	; scanline 3 (4/4)
	;==========================

	lda	#0		; always 0				; 2
	sta	PF0							; 3
	; has to happen by 22 (GPU 68)
; 5
	; also always 0
	sta	PF1							; 3
	; has to happen by 28 (GPU 84)
; 8
	lda	(LPF2_L),Y						; 5
	sta	PF2							; 3
	; has to happen by 38 (GPU 116)
; 16

	inc	TEMP1
	inc	TEMP1
	nop
	nop
	nop


;	lda	frame3_1_overlay_sprite,Y				; 5
;	sta	GRP0							; 3
; 24
;	lda	frame3_1_overlay_colors,Y				; 5
;	sta	COLUP0							; 3
; 32

;	lda	(RPF0_L),Y						; -
	stx	PF0							; 3
	; has to happen 28-49 (GPU 84-148)
; 35
	lda	(RPF1_L),Y						; 5
	sta	PF1							; 3
	; has to happen 39-56 (GPU 116-170)
; 43
;	lda	(RPF2_L),Y						; -
	lda	PF_TEMP							; 3
	sta	PF2							; 3
	; has to happen 50-67 (GPU 148-202)
; 49

	iny								; 2
; 51
	lda	(OV2SP_L),Y						; 5
	sta	GRP1							; 3
; 59
	lda	(OV2C_L),Y						; 5
	sta	COLUP1							; 3

; 67
	cpy	#48							; 2
	beq	done_kernel						; 2/3
	jmp	kernel_loop						; 3
; 76

done_kernel:

; 72

	;===========================
	;===========================
	; overscan (30 cycles)
	;===========================
	;===========================

	; turn off everything
	lda	#0							; 2
	sta	GRP0							; 3
; 1
	lda	#2		; we do this in common
	sta	VSYNC		; but want it to happen in hblank


	lda	#0
	sta	GRP1							; 3
	sta	PF0							; 3
	sta	PF1							; 3
	sta	PF2							; 3
; 13

	ldx     #30							; 2
	jsr	common_overscan						; 6

	jmp	rr_frame


;.include "rr3_graphics.inc"
;.include "rr4_graphics.inc"
.include "rr5_graphics.inc"

scene_data:
.if 1
scene_data4:
	.byte <frame5_playfield2_left
	.byte >frame5_playfield2_left
	.byte <frame5_playfield0_right
	.byte >frame5_playfield0_right
	.byte <frame5_playfield1_right
	.byte >frame5_playfield1_right
	.byte <frame5_playfield2_right
	.byte >frame5_playfield2_right
	.byte <frame5_1_overlay_sprite
	.byte >frame5_1_overlay_sprite
	.byte <frame5_1_overlay_colors
	.byte >frame5_1_overlay_colors
	.byte <frame5_2_overlay_sprite
	.byte >frame5_2_overlay_sprite
	.byte <frame5_2_overlay_colors
	.byte >frame5_2_overlay_colors
.endif


.if 0
scene_data3:
	.byte <frame3_playfield2_left
	.byte >frame3_playfield2_left
	.byte <frame3_playfield0_right
	.byte >frame3_playfield0_right
	.byte <frame3_playfield1_right
	.byte >frame3_playfield1_right
	.byte <frame3_playfield2_right
	.byte >frame3_playfield2_right
	.byte <frame3_1_overlay_sprite
	.byte >frame3_1_overlay_sprite
	.byte <frame3_1_overlay_colors
	.byte >frame3_1_overlay_colors
	.byte <frame3_2_overlay_sprite
	.byte >frame3_2_overlay_sprite
	.byte <frame3_2_overlay_colors
	.byte >frame3_2_overlay_colors
.endif

.if 0
scene_data4:
	.byte <frame4_playfield2_left
	.byte >frame4_playfield2_left
	.byte <frame4_playfield0_right
	.byte >frame4_playfield0_right
	.byte <frame4_playfield1_right
	.byte >frame4_playfield1_right
	.byte <frame4_playfield2_right
	.byte >frame4_playfield2_right
	.byte <frame4_1_overlay_sprite
	.byte >frame4_1_overlay_sprite
	.byte <frame4_1_overlay_colors
	.byte >frame4_1_overlay_colors
	.byte <frame4_2_overlay_sprite
	.byte >frame4_2_overlay_sprite
	.byte <frame4_2_overlay_colors
	.byte >frame4_2_overlay_colors
.endif
