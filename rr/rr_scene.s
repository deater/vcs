
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

	ldx	#26							; 2
le_vblank_loop:
	sta     WSYNC							; 3
	dex								; 2
	bne	le_vblank_loop						; 2/3


	;=========================
	; VBLANK scanline 36
	;=========================
; 5
	inc	FRAME							; 5
; 10

	;==========================================
	; set up sprite0 to be at proper X position
	;==========================================

	ldx	#21
p0_pos_loop:
	dex
	bne	p0_pos_loop

	sta	RESP0
	sta	RESP1

	lda	#$0
	sta	HMP0
	lda	#$10
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
	lda	frame3_playfield2_left,Y				; 4
	sta	PF2							; 3
	; has to happen by 38 (GPU 116)
; 15

	lda	frame3_1_overlay_sprite,Y				; 4
	sta	GRP0							; 3
; 22
	lda	frame3_1_overlay_colors,Y				; 4
	sta	COLUP0							; 3
; 29

	lda	frame3_playfield0_right,Y				; 4
	sta	PF0							; 3
	; has to happen 28-49 (GPU 84-148)
; 36
	lda	frame3_playfield1_right,Y				; 4
	sta	PF1							; 3
	; has to happen 39-56 (GPU 116-170)
; 43
	lda	frame3_playfield2_right,Y				; 4
	sta	PF2							; 3
	; has to happen 50-67 (GPU 148-202)
; 50

	lda	frame3_2_overlay_sprite,Y				; 4
	sta	GRP1							; 3
; 57
	lda	frame3_2_overlay_colors,Y				; 4
	sta	COLUP1							; 3
; 64
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
	lda	frame3_playfield2_left,Y				; 4
	sta	PF2							; 3
	; has to happen by 38 (GPU 116)
; 15

	lda	frame3_1_overlay_sprite,Y				; 4
	sta	GRP0							; 3
; 22
	lda	frame3_1_overlay_colors,Y				; 4
	sta	COLUP0							; 3
; 29

	lda	frame3_playfield0_right,Y				; 4
	sta	PF0							; 3
	; has to happen 28-49 (GPU 84-148)
; 36
	lda	frame3_playfield1_right,Y				; 4
	sta	PF1							; 3
	; has to happen 39-56 (GPU 116-170)
; 43
	lda	frame3_playfield2_right,Y				; 4
	sta	PF2							; 3
	; has to happen 50-67 (GPU 148-202)
; 50


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
	lda	frame3_playfield2_left,Y				; 4
	sta	PF2							; 3
	; has to happen by 38 (GPU 116)
; 15

	lda	frame3_1_overlay_sprite,Y				; 4
	sta	GRP0							; 3
; 22
	lda	frame3_1_overlay_colors,Y				; 4
	sta	COLUP0							; 3
; 29

	lda	frame3_playfield0_right,Y				; 4
	sta	PF0							; 3
	; has to happen 28-49 (GPU 84-148)
; 36
	lda	frame3_playfield1_right,Y				; 4
	sta	PF1							; 3
	; has to happen 39-56 (GPU 116-170)
; 43
	lda	frame3_playfield2_right,Y				; 4
	sta	PF2							; 3
	; has to happen 50-67 (GPU 148-202)
; 50

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
	lda	frame3_playfield2_left,Y				; 4
	sta	PF2							; 3
	; has to happen by 38 (GPU 116)
; 15

	lda	frame3_1_overlay_sprite,Y				; 4
	sta	GRP0							; 3
; 22
	lda	frame3_1_overlay_colors,Y				; 4
	sta	COLUP0							; 3
; 29

	lda	frame3_playfield0_right,Y				; 4
	sta	PF0							; 3
	; has to happen 28-49 (GPU 84-148)
; 36
	lda	frame3_playfield1_right,Y				; 4
	sta	PF1							; 3
	; has to happen 39-56 (GPU 116-170)
; 43
	lda	frame3_playfield2_right,Y				; 4
	sta	PF2							; 3
	; has to happen 50-67 (GPU 148-202)
; 50

	inc	TEMP1
	inc	TEMP1
	inc	TEMP1
	nop

; 67
	iny								; 2
	cpy	#48							; 2
	beq	done_kernel						; 2/3
	jmp	kernel_loop						; 3

; 76

done_kernel:
	;===========================
	;===========================
	; overscan (30 cycles)
	;===========================
	;===========================

	ldx     #30
	jsr	common_overscan

	jmp	rr_frame


.include "rr3_graphics.inc"
