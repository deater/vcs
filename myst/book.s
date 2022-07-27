	;=====================
	; Linking Book
	;=====================

	jmp	book_frame
.align	$100
book_frame:

	;============================
	; start VBLANK
	;============================
	; in scanline 0

	jsr	common_vblank

	;=================================
	;=================================
	; 37 lines of vertical blank
	;=================================
	;=================================

; in VBLANK scanline 0

	ldx	#25
book_vblank_loop:
	sta	WSYNC
	dex
	bne	book_vblank_loop


	;=============================
	; now at VBLANK scanline 25
	;=============================
	; copy in hand sprite
	ldx	#15							; 2
hand_copy_loop:
	lda	hand_sprite,X						; 4+
	sta	HAND_SPRITE,X						; 4
	dex								; 2
	bpl	hand_copy_loop						; 2/3

	; 2+(13*16)-1 = 209
	;	around 2.75 scanlines
	sta	WSYNC

	;=============================
	; now at VBLANK scanline 28
	;=============================
	; 4 scanlines of handling input

	jsr	hand_motion

; 6

	;=======================
	; now scanline 32
	;========================
	; increment frame
	; setup missile
	inc	FRAME							; 5

	lda	#$2
	sta	ENAM0	; enable missile 0



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
zpad_x:
	dex			;					2
	bne	zpad_x		;					2/3
				;===========================================
				;	12-1+5*(coarse_x+2)
				; FIXME: describe better what's going on

	; beam is at proper place
	sta	RESP1							; 3


	sta	WSYNC

	;======================================
	; now vblank 35
	;=======================================
	; update pointer horizontal position
	;=======================================

	; do this separately as too long to fit in with left/right code

	jsr	pointer_moved_horizontally	;			6+48
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

	ldx	POINTER_X_COARSE	;				3
	inx			;					2
	inx			;					2
; 12

zzpad_x:
	dex			;					2
	bne	zzpad_x		;					2/3
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
	; setup hand sprite

	lda	#$24		; middle orange				; 2
	sta	COLUP0		; set hand color (sprite0)		; 3

	lda	#$1E		; yellow				; 2
	sta	COLUP1		; set secret color (sprite1)		; 3

	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

	ldy	#0		; X=current block			; 2
								;============
								;	28

	lda	#0
	sta	VBLANK			; turn on beam
	sta	POINTER_ON

	lda	#CTRLPF_REF		; reflect playfield
	sta	CTRLPF


;	lda	#$0E			; book color (grey)		; 2
;	sta	COLUPF							; 3
	lda	#0			; bg color			; 2
	sta	COLUBK							; 3

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

	;==========================
	; draw top eight lines

	;==========================
	; black line
	lda	#$00		; black
	sta	COLUPF
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	;==========================
	; grey line
	lda	#$04		; dark grey				; 2
	sta	COLUPF							; 3
	lda	#$7F		; overhanging page			; 2
	sta	PF1							; 3
	lda	#$FF							; 2
	sta	PF2							; 3
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC




	jmp	book_draw_playfield_plus_3				; 3

book_draw_playfield:

book_draw_playfield_even:

	;===================
	; draw playfield 1/4
	;===================
	;

; 3
book_draw_playfield_plus_3:

	lda	#$0E		; reset book color (lgrey)		; 2
	sta	COLUPF		; store playfield color			; 3
; 8
;	lda	#$0		; always 0				; 2
;	sta	PF0							; 3
	; has to happen by 22 (GPU 68)
; 13
	lda	#$3F
;	lda	book_playfield1_left,Y	;				; 4
	sta	PF1			;				; 3
	;  has to happen by 28 (GPU 84)
; 20
;	lda	book_playfield2_left,Y	;				; 4
	lda	#$FF
        sta	PF2							; 3
	;  has to happen by 38 (GPU 116)	;
; 27

	;==============================
	; activate sprite1

	; X = current scanline
	lda	#$F0			; load sprite data		; 2
	cpx	#80							; 2
	bcs	book_turn_off_secret_delay4				; 2/3
	cpx	#72							; 2
	bcc	book_turn_off_secret					; 2/3
book_turn_on_secret:
	sta	GRP1			; and display it		; 3
	jmp	book_after_secret					; 3
book_turn_off_secret_delay4:
	nop								; 2
	nop								; 2
book_turn_off_secret:
	lda	#0			; turn off sprite		; 2
	sta	GRP1							; 3
book_after_secret:
								;============

; 43								; 12 / 16 / 16

	inc	CURRENT_SCANLINE					; 5
	sta	WSYNC
; 76

	;===================
	; draw playfield 2/4
	;===================
; 0

	; activate hand sprite if necessary
	ldx	CURRENT_SCANLINE					; 3
	; X = current scanline
	lda	HAND_SPRITE,X		; load sprite data		; 4
	cpx	POINTER_Y_END						; 3
	bcs	book_turn_off_hand_delay5				; 2/3
	cpx	POINTER_Y						; 3
	bcc	book_turn_off_hand					; 2/3
book_turn_on_hand:
	sta	GRP0			; and display it		; 3
	jmp	book_after_hand						; 3
book_turn_off_hand_delay5:
	inc	TEMP1							; 5
book_turn_off_hand:
	lda	#0			; turn off sprite		; 2
	sta	GRP0							; 3
book_after_hand:
								;============
								; 23 / 23 / 23
; 23

;	inc	CURRENT_SCANLINE					; 5
; 28

;	sta	WSYNC

	;===================
	; draw playfield 3/4
	;===================
; 0
;	inc	CURRENT_SCANLINE					; 5
;	sta	WSYNC

	;===================
	; draw playfield 4/4
	;===================
; 0
;	inc	CURRENT_SCANLINE

	lda	CURRENT_SCANLINE					; 3
	and	#$1							; 2
	beq	yes_inc4						; 2/3
	.byte	$A5     ; begin of LDA ZP				; 3
yes_inc4:
	iny             ; $E8 should be harmless to load		; 2
done_inc_block:
                                                                ;===========
                                                                ; 10/10

	cpy	#44		; see if hit end			; 2
; 72
	beq	book_done_playfield					; 2/3
; 74
	sta	WSYNC
	jmp	book_draw_playfield					; 3
; 77
book_done_playfield:


	;==========================
	; grey line
	lda	#$04		; dark grey				; 2
	sta	COLUPF							; 3
	lda	#$7F		; overhanging page			; 2
	sta	PF1							; 3
	lda	#$FF		; needed???				; 2
	sta	PF2							; 3
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC


	;==========================
	; black line
	lda	#$00		; black					; 2
	sta	PF0							; 3
	sta	PF1							; 3
	sta	PF2							; 3
	sta	COLUPF							; 3

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC




	; extra for some reason?
	sta	WSYNC

	;===========================
	;===========================
	; overscan (30 cycles)
	;===========================
	;===========================

	ldx	#25
	jsr	common_overscan

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

	lda	POINTER_X						; 3
	cmp	#12							; 2
	bcc	regular_collision					; 2/3
; 18
	cmp	#150	; $9E						; 2
	bcs	regular_collision					; 2/3
; 22
	lda	POINTER_Y						; 3
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
	lda	OLD_POINTER_X
	sta	POINTER_X
	lda	OLD_POINTER_Y
	sta	POINTER_Y

	lda	OLD_POINTER_X_END
	sta	POINTER_X_END
	lda	OLD_POINTER_Y_END
	sta	POINTER_Y_END

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

	jmp	book_frame

book_goto_sc:
;	jmp	secret_collect_animation

book_goto_go:
;	jmp	game_over_animation

book_goto_zap:
;	ldy	#SFX_ZAP
;	jsr	trigger_sound
;	jsr	init_strongbad	; reset position
;	lda	#0
;	sta	LEVEL_OVER

;	jmp	level_frame

book_goto_oot:
;	ldy	#SFX_GAMEOVER
;	jsr	trigger_sound

;	dec	MANS
;	bmi	goto_go

;	jsr	init_level
	jmp	book_frame
