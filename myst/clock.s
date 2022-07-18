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

	ldx	#29
le_vblank_loop:
	sta	WSYNC
	dex
	bne	le_vblank_loop

;.repeat 14
;	sta	WSYNC
;.endrepeat
								;	15
	;=============================
	; now at VBLANK scanline 29
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
	; now at VBLANK scanline 30
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
	; now at VBLANK scanline 31
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
	; now VBLANK scanline 32
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

	;==========================
	; now VBLANK scanline 33
	;==========================
	; set up playfield

	lda	LEVEL
	lsr
	bcc	setup_level2
setup_level1:
	lda	#<l1_playfield0_left
	sta	PF0_ZPL
	lda	#>l1_playfield0_left
	sta	PF0_ZPH

	lda	#<l1_playfield1_left
	sta	PF1_ZPL
	lda	#>l1_playfield1_left
	sta	PF1_ZPH

	lda	#<l1_playfield2_left
	sta	PF2_ZPL
	lda	#>l1_playfield2_left
	jmp	done_setup_level
setup_level2:

	lda	#<l2_playfield0_left
	sta	PF0_ZPL
	lda	#>l2_playfield0_left
	sta	PF0_ZPH

	lda	#<l2_playfield1_left
	sta	PF1_ZPL
	lda	#>l2_playfield1_left
	sta	PF1_ZPH

	lda	#<l2_playfield2_left
	sta	PF2_ZPL
	lda	#>l2_playfield2_left


done_setup_level:
	sta	PF2_ZPH

	sta	WSYNC

	;========================
	; now VBLANK scanline 34
	;========================
	; empty for now

	sta	WSYNC



	;=======================
	; now scanline 35
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
	; now VBLANK scanline 36
	;=============================
	; do some init

	ldx	#$00
	stx	COLUBK		; set background color to black

	lda	#0
	sta	CURRENT_SCANLINE	; reset scanline counter

	sta	WSYNC

	; now scanline 37

	;===============================
	;===============================
	;===============================
	; visible area: 192 lines (NTSC)
	;===============================
	;===============================
	;===============================


	;============================================================
	; draw playfield (4 scanlines setup + 152 scanlines display)
	;============================================================


	; Level 1 Playfield


	;===============================
	; set up playfield (4 scanlines)
	;===============================

	jmp	blurgh3
.align	$100

huge_hack:
	jmp	not_blue
blurgh3:

	; now in setup scanline 0
	; WE CAN DO STUFF HERE


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

	;=======================================
	; update strongbad horizontal position
	;=======================================
	; now in setup scanline 1

	; do this separately as too long to fit in with left/right code

	jsr	strongbad_moved_horizontally	;			6+48
	sta	WSYNC			;				3
					;====================================
					;				57

	;==========================================
	; set up sprite to be at proper X position
	;==========================================
	; now in setup scanline 2
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
	; Final setup before going
	;==========================================
	; now in setup scanline 3
; 3 (from HMOVE)
	ldx	#28			; current scanline?		; 2

	lda	#$0							; 2
	sta	PF0			; disable playfield		; 3
	sta	PF1							; 3
	sta	PF2							; 3

	lda	#$C2			; green				; 2
	sta	COLUPF			; playfield color		; 3

	lda	#CTRLPF_REF		; reflect playfield		; 2
	sta	CTRLPF							; 3
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
; 54
	sta	CXCLR	; clear collisions				; 3
; 57

	lda	(PF0_ZPL),Y		;				; 5+
 ;       sta	PF0			;				; 3

	sta	WSYNC							; 3
								;============
								;============
								;	60

	;===========================================
	;===========================================
	;===========================================
	; draw playfield, 192-28-12 = 152 scanlines (38 4-line blocks)
	;===========================================
	;===========================================
	;===========================================

draw_playfield:

draw_playfield_even:

	;===================
	; draw playfield
	;===================
; 0
	sta	PF0							; 3
;	lda	l1_playfield0_left,Y	;				;
;	lda	(PF0_ZPL),Y		;				; 5+
;       sta	PF0			;				; 3
	;   has to happen by 22
; 3

        lda	(PF1_ZPL),Y		;				; 5+
        sta	PF1			;				; 3
	;  has to happen by 31
; 11

	; has to happen by 30-3




	;=======================
	; set bad stuff to blue

;	cpy	#9							; 2
;	bcc	not_blue_waste12					; 2/3
;	cpy	#29							; 2
;	bcs	not_blue_waste8						; 2/3
;	lda	ZAP_COLOR	; blue					; 3
;	sta	COLUPF							; 3
;	jmp	done_blue						; 3
;not_blue_waste12:
;	nop
;	nop
;not_blue_waste8:
;	nop
;	nop
;	nop
;	nop
;done_blue:
								;============
								;  5 / 9 / 17



	lda	ZAP_COLOR	; blue					; 3
	cpy	#9							; 2
	bcc	huge_hack						; 2/3
	cpy	#29							; 2
	bcc	yes_blue						; 2/3
not_blue:
	.byte	$2C	; bit trick, 4 cycles
yes_blue:
	sta	COLUPF							; 3


							;==================
							; 12 / 15 /15
; 26

	;  has to happen by
        lda	(PF2_ZPL),Y		;				; 5
        sta	PF2			;				; 3


; 34

	;==============================
	; activate secret sprite

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

; 50
	inc	ZAP_COLOR	; increment color			; 5
	lda	ZAP_COLOR						; 3
	and	#$9F		; keep in $80-$90 range			; 2
	sta	ZAP_COLOR						; 3
; 63

	nop
	nop
; 67

	; turn playfield back to green for edge
	; this needs to happen before cycle 70
	lda	#$C2		; green					; 2
	sta	COLUPF							; 3
; 72

	inx								; 2

; 74
	lda	$80							; 3
;	nop
; 77

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
; 1
	inc	TEMP1					; 5
	inc	TEMP1					; 5
						;============
						;	10
; 11

	;=======================
	; set bad stuff to blue
	; really want this to start at least cycle 10

	lda	ZAP_COLOR	; blue					; 3
	cpy	#9							; 2
	bcc	huge_hack2						; 2/3
	cpy	#29							; 2
	bcc	oyes_blue						; 2/3
onot_blue:
	.byte	$2C	; bit trick, 4 cycles
oyes_blue:
	sta	COLUPF							; 3


								;==========
								; 15 / 15 /15

;	cpy	#9							; 2
;	bcc	onot_blue_waste12					; 2/3
;	cpy	#29							; 2
;	bcs	onot_blue_waste8					; 2/3
;	lda	ZAP_COLOR	; blue					; 3
;	sta	COLUPF							; 3
;	jmp	odone_blue						; 3
;onot_blue_waste12:
;	nop								; 2
;	nop								; 2
;onot_blue_waste8:
;	nop								; 2
;	nop								; 2
;	nop								; 2
;	nop								; 2
;odone_blue:
								;============
								;  5 / 9 / 17

	; has to happen by 30-3 but after 24-3

; 26

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

; 44

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

; 55
	lda	(PF0_ZPL),Y		;				; 5+
	sta	TEMP1							; 3

; 63

	; this needs to happen before cycle 70
	lda	#$C2		; restore green wall			; 2
	sta	COLUPF							; 3
; 68

	lda	TEMP1							; 3
	cpx	#180		; see if hit end			; 2
	bne	draw_playfield						; 2/3
done_playfield:
								;=============
								; 10 / 10

; 76
	jmp	skip

huge_hack2:
	jmp	onot_blue

skip:

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
