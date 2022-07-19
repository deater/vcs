	;=====================
	; the clock
	;=====================

clock_frame:

	;============================
	; Start Vertical Blank
	;============================

	lda	#0
	sta	VBLANK			; turn on beam

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	;=================================
	; wait for 3 scanlines of VSYNC
	;=================================

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC
	sta	WSYNC

	; now in VSYNC scanline 3

	lda	#0			; done beam reset
	sta	VSYNC



	;=================================
	;=================================
	; 37 lines of vertical blank
	;=================================
	;=================================

	ldx	#28
le_vblank_loop:
	sta	WSYNC
	dex
	bne	le_vblank_loop

								;	15
	;=============================
	; now at VBLANK scanline 28
	;=============================
	; handle left being pressed

	lda	STRONGBAD_X		;				; 3
	beq	after_check_left	;				; 2/3

	lda	#$40			; check left			; 2
	bit	SWCHA			;				; 3
	bne	after_check_left	;				; 2/3

left_pressed:
	dec	STRONGBAD_X		; move sprite left		; 5

after_check_left:
	sta	WSYNC			;				; 3
					;	============================
					;	 		9 / 20 / 16

	;=============================
	; now at VBLANK scanline 29
	;=============================
	; handle right being pressed

	lda	STRONGBAD_X_END		;				; 3
	cmp	#167			;				; 2
	bcs	after_check_right	;				; 2/3

	lda	#$80			; check right			; 2
	bit	SWCHA			;				; 3
	bne	after_check_right	;				; 2/3

	inc	STRONGBAD_X		; move sprite right		; 5
after_check_right:
	sta	WSYNC			;				; 3
					;	===========================
					; 			11 / 22 / 18

	;===========================
	; now at VBLANK scanline 30
	;===========================
	; handle up being pressed

	lda	STRONGBAD_Y		;				; 3
	cmp	#1			;				; 2
	beq	after_check_up		;				; 2/3

	lda	#$10			; check up			; 2
	bit	SWCHA			;				; 3
	bne	after_check_up		;				; 2/3

	dec	STRONGBAD_Y		; move sprite up		; 5

	jsr	strongbad_moved_vertically	; 			; 6+16
after_check_up:
	sta	WSYNC			; 				; 3
					;	===============================
					; 			11 / 18 / 44

	;==========================
	; now VBLANK scanline 31
	;==========================
	; handle down being pressed

	lda	STRONGBAD_Y_END		;				; 3
	cmp	#VID_LOGO_START		;				; 2
	bcs	after_check_down	;				; 2/3

	lda	#$20			;				; 2
	bit	SWCHA			;				; 3
	bne	after_check_down	;				; 2/3

	inc	STRONGBAD_Y		; move sprite down		; 5
	jsr	strongbad_moved_vertically	;			; 6+16
after_check_down:
	sta	WSYNC			;				; 3
					;	==============================
					; 			11 / 18 / 44


	;=======================
	; now scanline 32
	;========================
	; increment frame
	; handle any frame-related activity
; 0
	inc	FRAME							; 5
	lda	FRAME							; 3
; 8
.if 0

	; update zap color
	; every other frame?

	ldx	ZAP_BASE

	and	#$1
	beq	done_rotate_zap

	dec	ZAP_BASE						; 5
	ldx	ZAP_BASE						; 3
	cpx	#$7f							; 2
	bcs	done_rotate_zap						; 2/3
	ldx	#$AF							; 2
	stx	ZAP_BASE						; 3
done_rotate_zap:
	stx	ZAP_COLOR						; 3
dont_rotate_zap:

;	dec	ZAP_BASE
;	lda	ZAP_BASE
;	and	#$3F
;	sta	ZAP_BASE
;	sta	ZAP_COLOR

                                                                ;============
                                                                ; 20 worse case
.endif

	sta	WSYNC							; 3


	;=============================
	; now VBLANK scanline 33
	;=============================
	; do some init

	ldx	#$00
	stx	COLUBK		; set background color to black

	lda	#0
	sta	CURRENT_SCANLINE	; reset scanline counter

	sta	WSYNC

	;======================
	; now VBLANK scanline 34
	;======================

	;==========================================
	; set up sprite1 to be at proper X position
	;==========================================
	; now in setup scanline 0

	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want
; 3
	ldx	#0		; sprite 0 display nothing		2
	stx	GRP1		; (FIXME: this already set?)		3
; 8
	ldx	#6		;					3
	inx			;					2
	inx			;					2
qpad_x:
	dex			;					2
	bne	qpad_x		;					2/3
				;===========================================
				;	12-1+5*(coarse_x+2)
				; FIXME: describe better what's going on

	; beam is at proper place
	sta	RESP1							; 3


	sta	WSYNC

	;======================================
	; now vblank 35
	;=======================================
	; update strongbad horizontal position
	;=======================================

	; do this separately as too long to fit in with left/right code

	jsr	strongbad_moved_horizontally	;			6+48
	sta	WSYNC			;				3
					;====================================
					;				57

	;=========================================
	; now vblank 36
	;==========================================
	; set up sprite to be at proper X position
	;==========================================
; 0
	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want

	ldx	#0		; sprite 0 display nothing		2
	stx	GRP0		; (FIXME: this already set?)		3

	ldx	STRONGBAD_X_COARSE	;				3
	inx			;					2
	inx			;					2
; 12

pad_x:
	dex			;					2
	bne	pad_x		;					2/3
				;===========================================
				;	12-1+5*(coarse_x+2)
;

	; beam is at proper place
	sta	RESP0							; 3

	sta	WSYNC							; 3
	sta	HMOVE		; adjust fine tune, must be after WSYNC	; 3
				; also draws black artifact on left of
				; screen

	;==========================================
	; now vblank 37
	;==========================================
	; Final setup before going
	;==========================================

; 3 (from HMOVE)
	ldx	#0			; current scanline?		; 2

	lda	#$0							; 2
	sta	PF0			; disable playfield		; 3
	sta	PF1							; 3
	sta	PF2							; 3

								;===========
								;        23
; 26
	; reset back to strongbad sprite

	lda	#$40		; dark red				; 2
	sta	COLUP0		; set strongbad color (sprite0)		; 3

	lda	#$1E		; yellow				; 2
	sta	COLUP1		; set secret color (sprite1)		; 3

	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

	lda	#0							; 2
	sta	VDELP0							; 3
	sta	VDELP1							; 3
	tay			; X=current block			; 2
								;============
								;	28

	sta	WSYNC							; 3
								;============
								;============
								;	60

	;===========================================
	;===========================================
	;===========================================
	; draw playfield, 192 scanlines
	;===========================================
	;===========================================
	;===========================================

draw_playfield:

draw_playfield_even:

	;===================
	; draw playfield
	;===================

; FIXME: move this into previous loop, A/X?

; 0
	lda	clock_colors,Y						; 4+
	sta	COLUPF							; 3
; 7
	lda	clock_bg_colors,Y					; 4+
	sta	COLUBK							; 3
; 14
	lda	clock_playfield0_left,Y	;				; 4+
	sta	PF0			;				; 3
	;   has to happen by 22 (GPU 68)
; 21

	lda	clock_playfield1_left,Y	;				; 4+
        sta	PF1			;				; 3
	;  has to happen by 24 (GPU 72)
; 28
	lda	clock_playfield2_left,Y	;				; 4+
        sta	PF2
	;  has to happen by 26 (GPU 80)	;				; 3
; 35
	; has to happen by 30-3

        lda	clock_playfield0_right,Y	;			; 4
        sta	PF0				;			; 3
; 42
        lda	clock_playfield1_right,Y	;			; 4
        sta	PF1				;			; 3
; 49
        lda	clock_playfield2_right,Y	;			; 4
        sta	PF2				;			; 3
; 56


	;==============================
	; activate sprite1

	; X = current scanline
	lda	#$F0			; load sprite data		; 2
	cpx	#80							; 2
	bcs	turn_off_secret_delay4					; 2/3
	cpx	#72							; 2
	bcc	turn_off_secret						; 2/3
turn_on_secret:
	sta	GRP1			; and display it		; 3
	jmp	after_secret						; 3
turn_off_secret_delay4:
	nop								; 2
	nop								; 2
turn_off_secret:
	lda	#0			; turn off sprite		; 2
	sta	GRP1							; 3
after_secret:
								;============
								; 12 / 16 / 16

; 72

	inx								; 2
; 74
	nop
; 76

	;=============================================
	;=============================================
	;=============================================
	; draw playfield odd
	;=============================================
	;=============================================
	;=============================================


draw_playfield_odd:

	;===================
	; draw playfield
; 0

	; activate strongbad sprite if necessary

	; X = current scanline
	lda	#$F0			; load sprite data		; 2
	cpx	STRONGBAD_Y_END						; 3
	bcs	turn_off_strongbad_delay5				; 2/3
	cpx	STRONGBAD_Y						; 3
	bcc	turn_off_strongbad					; 2/3
turn_on_strongbad:
	sta	GRP0			; and display it		; 3
	jmp	after_sprite						; 3
turn_off_strongbad_delay5:
	inc	TEMP1							; 5
turn_off_strongbad:
	lda	#0			; turn off sprite		; 2
	sta	GRP0							; 3
after_sprite:
								;============
								; 13 / 18 / 18

; 18

	inx								; 2
	txa								; 2
	and	#$3							; 2
	beq	yes_inc4						; 2/3
	.byte	$A5     ; begin of LDA ZP				; 3
yes_inc4:
	iny             ; $E8 should be harmless to load		; 2
done_inc_block:
                                                                ;===========
                                                                ; 11/11


	cpx	#192		; see if hit end			; 2
	sta	WSYNC
	bne	draw_playfield						; 2/3
done_playfield:
								;=============
								; 10 / 10



	;=============================================
	; vertical blank
	;=============================================
vertical_blank:
	lda	#$42		; enable INPT4/INPT5, turn off beam
	sta	VBLANK

	;===========================
	;===========================
	; overscan (30 cycles)
	;===========================
	;===========================

	ldx	#26
le_overscan_loop:
	sta	WSYNC
	dex
	bne	le_overscan_loop

;	.repeat 26
;	sta	WSYNC
;	.endrepeat

	;==================================
	; overscan 27, trigger sound

;	ldy	SOUND_TO_PLAY
;	beq	no_sound_to_play

;	jsr	trigger_sound		; 6+40

;	ldy	#0
;	sty	SOUND_TO_PLAY
;no_sound_to_play:
	sta	WSYNC

	;==================================
	; overscan 28+29, update sound

;	jsr	update_sound

	sta	WSYNC
	sta	WSYNC

	;==================================
	; overscan 30, collision detection

.if 0
	lda	CXPPMM			; check if p0/p1 collision	; 3
	bpl	no_collision_secret					; 2/3
collision_secret:
; 5
	lda	#LEVEL_OVER_SC						; 2
	sta	LEVEL_OVER						; 3
	ldy	#SFX_COLLECT						; 2
	jsr	trigger_sound
;	sty	SOUND_TO_PLAY						; 3
	jmp	collision_done						; 3
; 18

no_collision_secret:
; 6
	lda	CXP0FB			; check if p0/pf collision	; 3
	bpl	no_collision_wall					; 2/3
collision_wall:
; 11
	; if between Y>9*4 && Y<29*4 X and X>1 and Y<150 we got zapped!

	lda	STRONGBAD_X						; 3
	cmp	#12							; 2
	bcc	regular_collision					; 2/3
; 18
	cmp	#150	; $9E						; 2
	bcs	regular_collision					; 2/3
; 22
	lda	STRONGBAD_Y						; 3
	cmp	#64	; $40						; 2
	bcc	regular_collision					; 2/3
; 29
	cmp	#134	; $86						; 2
	bcs	regular_collision					; 2/3
;33
got_zapped:
	lda	#LEVEL_OVER_ZAP
	sta	LEVEL_OVER
	jmp	collision_done

regular_collision:
	; reset strongbad position
	lda	OLD_STRONGBAD_X
	sta	STRONGBAD_X
	lda	OLD_STRONGBAD_Y
	sta	STRONGBAD_Y

	lda	OLD_STRONGBAD_X_END
	sta	STRONGBAD_X_END
	lda	OLD_STRONGBAD_Y_END
	sta	STRONGBAD_Y_END

	ldy	#SFX_COLLIDE
	;sty	SOUND_TO_PLAY
	jsr	trigger_sound

no_collision_wall:


collision_done:

	lda	LEVEL_OVER
	beq	nothing_special
	bmi	goto_sc
	cmp	#LEVEL_OVER_ZAP
	beq	goto_zap
	cmp	#LEVEL_OVER_TIME
	beq	goto_oot

nothing_special:
.endif

	sta	WSYNC

	jmp	clock_frame

goto_sc:
;	jmp	secret_collect_animation

goto_go:
;	jmp	game_over_animation

goto_zap:
;	ldy	#SFX_ZAP
;	jsr	trigger_sound
;	jsr	init_strongbad	; reset position
;	lda	#0
;	sta	LEVEL_OVER

;	jmp	level_frame

goto_oot:
;	ldy	#SFX_GAMEOVER
;	jsr	trigger_sound

;	dec	MANS
;	bmi	goto_go

;	jsr	init_level
	jmp	clock_frame
