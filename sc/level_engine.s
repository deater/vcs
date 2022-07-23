	;=====================
	; the "game engine"
	;=====================
	; ideally called with VBLANK disabled

	; comes in with 3 cycles from loop
level_frame:

	;============================
	; Start Vertical Blank
	;============================

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	;=================================
	; wait for 3 scanlines of VSYNC
	;=================================

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC
	sta	WSYNC

	; now in VSYNC scanline 3

	lda	#0			; done beam reset		; 2
	sta	VSYNC							; 3



	;=================================
	;=================================
	; 37 lines of vertical blank
	;=================================
	;=================================

	ldx	#14
le_vblank_loop:
	sta	WSYNC							; 3
	dex								; 2
	bne	le_vblank_loop						; 2/3

	;=============================
	; now at VBLANK scanline 14
	;=============================
	; update score/mans/level values
; 4
	; 14 scanlines
	.include "update_score.s"
; 0
	;=============================
	; now at VBLANK scanline 28
	;=============================
	; stuff for collision detection

	; save old X/Y in case we have a collision
	lda	STRONGBAD_X						; 3
	sta	OLD_STRONGBAD_X						; 3
	lda	STRONGBAD_Y						; 3
	sta	OLD_STRONGBAD_Y						; 3

;	lda	STRONGBAD_X_END						; 3
;	sta	OLD_STRONGBAD_X_END					; 3
	lda	STRONGBAD_Y_END						; 3
	sta	OLD_STRONGBAD_Y_END					; 3
; 24

	sta	WSYNC							; 3

	;=============================
	; now at VBLANK scanline 29
	;=============================
	; handle left being pressed
; 0
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
; 0
;	lda	STRONGBAD_X_END		;				; 3
;	cmp	#167			;				; 2
;	bcs	after_check_right	;				; 2/3

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

	; FIXME: needed? always a wall?
;	lda	STRONGBAD_Y		;				; 3
;	cmp	#1			;				; 2
;	beq	after_check_up		;				; 2/3

	lda	#$10			; check up			; 2
	bit	SWCHA			;				; 3
	bne	after_check_up		;				; 2/3

	dec	STRONGBAD_Y		; move sprite up		; 5
;	dec	STRONGBAD_Y		; move sprite up		; 5

	jsr	strongbad_moved_vertically	; 			; 6+16
after_check_up:
	sta	WSYNC			; 				; 3
					;	===============================
					; 			11 / 18 / 44

	;==========================
	; now VBLANK scanline 32
	;==========================
	; handle down being pressed

	; FIXME: needed?
;	lda	STRONGBAD_Y_END		;				; 3
;	cmp	#181			;				; 2
;	bcs	after_check_down	;				; 2/3

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
	; empty for now

;	jsr	strongbad_moved_horizontally

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

	ldx	ZAP_BASE						; 3
	and	#$1							; 2
; 13
	beq	done_rotate_zap						; 2/3

	dec	ZAP_BASE						; 5
	ldx	ZAP_BASE						; 3
	cpx	#$7f							; 2
; 25
	bcs	done_rotate_zap						; 2/3
	ldx	#$AF							; 2
	stx	ZAP_BASE						; 3
; 32
done_rotate_zap:
; 16 / 28 / 32
	stx	ZAP_COLOR						; 3
dont_rotate_zap:


                                                                ;============
                                                                ; 35 worst case


	sta	WSYNC							; 3


	;=============================
	; now VBLANK scanline 36
	;=============================
	; do some init
; 0
	lda	#0							; 2
	sta	VBLANK			; turn on beam			; 3
	sta	CURRENT_SCANLINE	; reset scanline counter	; 3
	sta	COLUBK			; set background color to black	; 3

	sta	WSYNC

	;==============================
	; now VBLANK scanline 37
	;==============================

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

	;============================
	; now at VISIBLE scanline 8

	;=============================
	;=============================
	; draw playfield level # for 2 scanlines
	;=============================
	;=============================
	; FIXME: make this a loop?

	lda	#$0						; 2
	sta	PF0						; 3
; 5
	; need to write after 28
	inc	TEMP1						; 5
	inc	TEMP1						; 5
	inc	TEMP1						; 5
	inc	TEMP1						; 5
	inc	TEMP1						; 5
	lda	LEVEL_SPRITE8					; 3
	sta	PF0						; 3
; 36
	sta	WSYNC

	; draw part of the playfield level #
; 0
	lda	#$0						; 2
	sta	PF0						; 3
; 5
	; need to write after 28
	inc	TEMP1						; 5
	inc	TEMP1						; 5
	inc	TEMP1						; 5
	inc	TEMP1						; 5
	inc	TEMP1						; 5
	lda	LEVEL_SPRITE9					; 3
	sta	PF0						; 3
; 31

	.include "adjust_horiz.s"

;	jsr	strongbad_moved_horizontally			; 6+36
;36
	sta	WSYNC

	;===========================
	; now at VISIBLE scanline 10


	;============================
	;============================
	; draw MANS, 7 scanlines
	;============================
	;============================

	.include "mans.s"
	sta	WSYNC

	;===========================
	; now at VISIBLE scanline 17

	;============================
	;============================
	; draw timer bar, (6 scanlines)
	;============================
	;============================

	.include	"timer_bar.s"

	;===========================
	; now at VISIBLE scanline 23

	;============================================================
	; draw playfield (4 scanlines setup + 152 scanlines display)
	;============================================================

	.include "level_playfield.s"

	;=========================================
	;=========================================
	; draw Videlectrix Logo sprite (11 lines)
	;=========================================
	;=========================================

	.include "vid_logo.s"

; 10

	sta	WSYNC

	;=============================================
	; turn off beam
	;=============================================
beam_off:
	lda	#$42		; enable INPT4/INPT5, turn off beam
	sta	VBLANK

	;===========================
	;===========================
	; overscan (30 cycles)
	;===========================
	;===========================

	ldx	#24							; 2
le_overscan_loop:
	sta	WSYNC							; 3
	dex								; 2
	bne	le_overscan_loop					; 2/3


	;==================================
	; overscan 25, setup
	;==================================
	ldy	#0
	sty	TRIGGER_SOUND
	sta	WSYNC

	;==================================
	; overscan 26, collision detection
	;==================================
; 0
	lda	CXPPMM			; check if p0/p1 collision	; 3
	bpl	no_collision_secret					; 2/3
collision_secret:
; 5
	lda	#LEVEL_OVER_SC						; 2
	sta	LEVEL_OVER						; 3
	ldy	#SFX_COLLECT						; 2
	sty	TRIGGER_SOUND						; 3
	jmp	collision_done						; 3
; 18

no_collision_secret:
; 6
	lda	CXP0FB			; check if p0/pf collision	; 3
; 9
	bpl	no_collision_wall					; 2/3
collision_wall:
; 11
	; if STRONGBAD_Y>ZAP_BEGIN && STRONGBAD_Y<ZAP_END
	;	 and STRONGBAD_X>1 and STRONGBAD_X<150 we got zapped!

	lda	STRONGBAD_X						; 3
	cmp	#12							; 2
; 16
	bcc	regular_collision	; blt				; 2/3
; 18
	cmp	#150	; $9E						; 2
; 20
	bcs	regular_collision	; bge				; 2/3
; 22
	lda	STRONGBAD_Y						; 3
	cmp	#64	; $40						; 2
; 27
	bcc	regular_collision					; 2/3
; 29
	cmp	#134	; $86						; 2
; 31
	bcs	regular_collision					; 2/3
; 33
got_zapped:
	lda	#LEVEL_OVER_ZAP						; 2
	sta	LEVEL_OVER						; 3
	jmp	collision_done						; 3
; 41

regular_collision:
; 19 / 23 / 30 / 34
	; reset strongbad position
	lda	OLD_STRONGBAD_X						; 3
	sta	STRONGBAD_X						; 3
	lda	OLD_STRONGBAD_Y						; 3
	sta	STRONGBAD_Y						; 3

;	lda	OLD_STRONGBAD_X_END					; 3
;	sta	STRONGBAD_X_END						; 3
	lda	OLD_STRONGBAD_Y_END					; 3
	sta	STRONGBAD_Y_END						; 3
; +24
	ldy	#SFX_COLLIDE						; 2
	sty	TRIGGER_SOUND						; 3
; + 29

no_collision_wall:
; 12

collision_done:
; 18 / 41 / 12 / 59 (worst case)

	sta	WSYNC

	;==================================
	; overscan 27, setup/trigger sounds
	;==================================

	lda	LEVEL_OVER						; 3
check_zap:
	cmp	#LEVEL_OVER_ZAP
	bne	check_oot
	ldy	#SFX_ZAP
	jmp	do_a_sound
check_oot:
	cmp	#LEVEL_OVER_TIME					; 2
	bne	done_setup
	ldy	#SFX_GAMEOVER
do_a_sound:
	sty	TRIGGER_SOUND
done_setup:
;	sta	WSYNC


	;==============================
	; overscan 27, trigger sound

	ldy	TRIGGER_SOUND						; 3
	beq	end_no_trigger_sound					; 2/3
	jsr	trigger_sound						; 6+40
end_no_trigger_sound:
	sta	WSYNC

	;==================================
	; overscan 28+29, update sound

	jsr	update_sound

	sta	WSYNC


	;==================================
	; overscan 30, handle end
	;==================================

handle_end_level:
	lda	LEVEL_OVER						; 3
	beq	nothing_special						; 2/3
; 5
	bmi	goto_sc							; 2/3
; 7
	cmp	#LEVEL_OVER_ZAP						; 2
; 9
	beq	goto_zap						; 2/3
; 11
	cmp	#LEVEL_OVER_TIME					; 2
; 13
	beq	goto_oot						; 2/3

nothing_special:
; 5 / 15
	sta	WSYNC
	jmp	level_frame		; do another frame

goto_sc:
; 8
	jmp	secret_collect_animation

goto_go:
	; game over

	jmp	game_over_animation

goto_zap:
	; zapped by wall
; 12
	jsr	reinit_strongbad	; reset position		; 6+!!!

	lda	#0			; reset game over
	sta	LEVEL_OVER
	jmp	level_frame

goto_oot:
	; out of time
; 16
	dec	MANS			; done one life
	bmi	goto_go			; if negative, game over

	jsr	init_level		; restart level			;6+!!!

	jmp	level_frame
