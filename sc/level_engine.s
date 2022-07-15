
	;=====================
	; the "game engine"
	;=====================

level_frame:

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

.repeat 14
	sta	WSYNC
.endrepeat

	;=============================
	; now at VBLANK scanline 18
	;=============================
	; update score/mans/level values

	; 14 scanlines
	.include "update_score.s"

	;=============================
	; now at VBLANK scanline 28
	;=============================
	; stuff for collision detection

	; save old X/Y in case we have a collision
	lda	STRONGBAD_X						; 3
	sta	OLD_STRONGBAD_X						; 3
	lda	STRONGBAD_Y						; 3
	sta	OLD_STRONGBAD_Y						; 3

	lda	STRONGBAD_X_END						; 3
	sta	OLD_STRONGBAD_X_END					; 3
	lda	STRONGBAD_Y_END						; 3
	sta	OLD_STRONGBAD_Y_END					; 3

	sta	WSYNC							; 3
								;============
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
	; check if level over

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

	;============================
	;============================
	; draw score, 8 scanlines
	;============================
	;============================

	.include "score.s"

	; at VISIBLE scanline 8

	;============================
	;============================
	; draw MANS, 7 scanlines
	;============================
	;============================

	; draw part of the playfield level #

	lda	#$0	; 2
	sta	PF0	; 3
	; after 28
	inc	TEMP1
	inc	TEMP1
	inc	TEMP1
	inc	TEMP1
	inc	TEMP1
	lda	LEVEL_SPRITE8
	sta	PF0

	sta	WSYNC

	; draw part of the playfield level #

	lda	#$0	; 2
	sta	PF0	; 3
	; after 28
	inc	TEMP1
	inc	TEMP1
	inc	TEMP1
	inc	TEMP1
	inc	TEMP1
	lda	LEVEL_SPRITE9
	sta	PF0

	sta	WSYNC
	.include "mans.s"
	sta	WSYNC

	; at VISIBLE scanline 10

	;============================
	;============================
	; draw timer bar, (6 scanlines)
	;============================
	;============================

	.include	"timer_bar.s"

	;============================================================
	; draw playfield (4 scanlines setup + 152 scanlines display)
	;============================================================

	.include "level1_playfield.s"

	;=========================================
	;=========================================
	; draw Videlectrix Logo sprite (11 lines)
	;=========================================
	;=========================================

	.include "vid_logo.s"

	sta	WSYNC

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

	.repeat 27
	sta	WSYNC
	.endrepeat

	;==================================
	; overscan 28, trigger sound

	ldy	SOUND_TO_PLAY
	beq	no_sound_to_play

	jsr	trigger_sound		; 6+40

	ldy	#0
	sty	SOUND_TO_PLAY
no_sound_to_play:
	sta	WSYNC

	;==================================
	; overscan 29, update sound

	.include "sound_update.s"
	sta	WSYNC

	;==================================
	; overscan 30, collision detection

	lda	CXPPMM			; check if p0/p1 collision	; 3
	bpl	no_collision_secret					; 2/3
collision_secret:
; 5
	lda	#LEVEL_OVER_SC						; 2
	sta	LEVEL_OVER						; 3
	ldy	#SFX_COLLECT						; 2
	sty	SOUND_TO_PLAY						; 3
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
	sty	SOUND_TO_PLAY

no_collision_wall:


collision_done:

	lda	LEVEL_OVER
	beq	nothing_special
	bmi	goto_sc
	cmp	#LEVEL_OVER_ZAP
	beq	goto_zap

nothing_special:
	sta	WSYNC

	jmp	level_frame

goto_sc:
	jmp	secret_collect_animation

goto_go:
	jmp	game_over_animation

goto_zap:
	ldy	#SFX_ZAP
	sty	SOUND_TO_PLAY
	jsr	init_strongbad	; reset position
	lda	#0
	sta	LEVEL_OVER

	jmp	level_frame
