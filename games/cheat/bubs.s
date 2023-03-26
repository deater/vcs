; Bubs' Concession Stand

bubs_start:

	pha
	lda	#20
	sta	TITLE_COUNTDOWN
	lda	#120			; set initial Y position
	sta	CHEAT_Y
	pla
	jsr	init_level		; 1 scanline


bubs_loop:

	;=========================
	; Start Vertical Blank
	;=========================

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	;================================
	; wait for 3 scanlines of VSYNC

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC

	lda	CHEAT_DIRECTION
	sta	REFP0
	sta	REFP1

	; mirror playfield
	lda	#CTRLPF_REF|CTRLPF_BALL_SIZE4
	sta	CTRLPF

	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	;===============================
	;===============================
	; 37 lines of vertical blank
	;===============================
	;===============================

	ldx	#20
	jsr	scanline_wait		; Leaves X zero
; 10
	sta	WSYNC

	;===========================
	; scanline 20
	;===========================
	; takes 10 scanlines

	jsr	update_score
	sta	WSYNC

	;===========================
	; scanline 30-31
	;===========================
	; update overlay horizontal

update_bubs_overlay_horizontal:
; 0
	lda	#74						; 3
	ldx	#0			; P0			; 2
	jsr	set_pos_x		; 2 scanlines		; 6+62
	sta	WSYNC

	;==========================
	; scanline 32
	;==========================
bwait_pos3:
	dey								; 2
	bpl	bwait_pos3	; 5-cycle loop (15 TIA color clocks)	; 2/3

	sta	RESP0							; 4
	sta	WSYNC

	;==========================
	; scanline 33-34
	;==========================
; 0
	lda	SHADOW_X						; 3
	ldx	#1			; P1				; 2
	jsr	set_pos_x		; 2 scanlines			; 6+62
	sta	WSYNC

	;==========================
	; scanline 35
	;==========================
bwait_pos2:
	dey                                                             ; 2
	bpl	bwait_pos2	; 5-cycle loop (15 TIA color clocks)    ; 2/3

	sta	RESP1							; 4
	sta	WSYNC
        sta     HMOVE

	;================================
	; scanline 36
	;================================

	sta     WSYNC

	;=============================
	; scanline 37
	;=============================

	lda	#NUSIZ_DOUBLE_SIZE	; for overlay
	sta	NUSIZ0
	lda	#NUSIZ_ONE_COPY		; for cheat
	sta	NUSIZ1

	lda	#$0		; turn off delay
	sta	VDELP0
	sta	VDELP1
	sta	GRP0		; turn off sprites
	sta	GRP1

	sta	PF0		; clear playfield
	sta	PF1
	sta	PF2

	sta	REFP0

;	lda	#$00		; black cheat
;	sta	COLUP0
	lda	#$1C		; yellow cheat
	sta	COLUP1

	lda	#$AE		; blue sky
	sta	COLUBK

	sta	WSYNC

	ldx	#0
	stx	VBLANK		; turn on beam (X=0)


	;===========================
	;===========================
	; playfield
	;===========================
	;===========================
	; draw 192 lines

	ldx	#0
	ldy	#0

	;===========================
	; 60 lines of bushes
	;===========================
	; Hills?  I always thought those were bushes...
	;	(figurative)
bbushes_top_loop:
; 3
;	lda	bushes_bg_colors,X					; 4+
	sta	COLUBK							; 3
; 6
	lda	bushes_colors,X						; 4+
	sta	COLUPF							; 3
; 13
	lda	bushes_playfield0_left,X				; 4+
	sta	PF0							; 3
	; must write by CPU 22 [GPU 68]
; 20
	lda	bushes_playfield1_left,X				; 4+
	sta	PF1							; 3
	; must write by CPU 28 [GPU 84]
; 27
	lda	bushes_playfield2_left,X				; 4+
	sta	PF2							; 3
	; must write by CPU 38 [GPU 116]
; 34



; 62
	inx								; 2
	lda	bushes_bg_colors,X					; 4+
	cpx	#60							; 2
; 70
	sta	WSYNC
	bne	bbushes_top_loop


	lda	#$D4							; 2
	sta	COLUBK							; 3

	ldx	#0

	;===========================
	; scanline 60 -- bubs
	;===========================
	; 48 lines of bubs + overlay
	;===========================
bubs_top_loop:
; 3
	lda	bubs_colors,X						; 4+
	sta	COLUPF							; 3
; 10
	lda	#$00							; 2
	sta	PF0							; 3
	; must write by CPU 22 [GPU 68]
; 15
	sta	PF1							; 3
	; must write by CPU 28 [GPU 84]
; 18
	lda	bubs_playfield2_left,X					; 4+
	sta	PF2							; 3
	; must write by CPU 38 [GPU 116]
; 25

	lda	stand_overlay_colors,X					; 4+
	sta	COLUP0							; 3
; 32
	lda	stand_overlay_sprite,X					; 4+
	sta	GRP0							; 3
; 39

	inx								; 2
	cpx	#48							; 2
; 70
	sta	WSYNC
	bne	bubs_top_loop

	;===========================
	; scanline 108 -- grass
	;===========================

	lda	#NUSIZ_ONE_COPY
	sta	NUSIZ0

	lda	CHEAT_DIRECTION
	sta	REFP0

	lda	#0
	sta	HMP1
	sta	CXCLR

	lda	#$1E
	sta	COLUPF

	sta	WSYNC

	;===========================
	; scanline 109
	;===========================
	; update cheat horizontal
bupdate_cheat_horizontal:
; 0
	lda	CHEAT_X						; 3
	ldx	#0						; 2
	jsr	set_pos_x		; 2 scanlines		; 6+62
	sta	WSYNC

	;==========================
	; scanline 110
	;==========================
bwait_pos1:
	dey								; 2
	bpl	bwait_pos1	; 5-cycle loop (15 TIA color clocks)	; 2/3

	sta	RESP0							; 4
	sta	WSYNC
	sta	HMOVE

	;===========================
	; bottom of screen
	;===========================
	; at scanline 112

	ldy	#0
	ldx	#112
bbottom_loop:

; 3
	; activate cheat sprite

	cpx	CHEAT_Y							; 2
	bne	bdone_activate_cheat					; 2/3
bactivate_cheat:
	ldy	#10							; 2
bdone_activate_cheat:

	lda	cheat_sprite_black,Y
	sta	GRP0
	lda	cheat_sprite_yellow,Y
	sta	GRP1

	tya
	beq	blevel_no_cheat

	dey

blevel_no_cheat:

	inx

	sta	WSYNC

;	txa				; 150		; 100	;125
;	sec				; - 120		; -120	;-120
;	sbc	STRONGBAD_Y		;=======	;=====	;====
;	cmp	#28			; 30		; -20	; 5
;	bcs	no_strongbad

;	stx	TEMP1
;	tax
;	lda	strongbad_colors,X
;	sta	COLUPF
;	ldx	TEMP1

;	lda	#2
;	bne	done_strongbad
;no_strongbad:
;	lda	#0
;done_strongbad:
;	sta	ENABL

	inx
	cpx	#184
	sta	WSYNC
	bne	bbottom_loop

	;===================
	; 8 scanlines
	;===================

	jsr	draw_score


	;============================
	; overscan
	;============================
bubs_overscan:
	lda	#$2		; turn off beam
	sta	VBLANK

	; wait 30 scanlines

	ldx	#22
	jsr	scanline_wait

        ;===============================
	; 22 scanlines -- trigger sound
	;===============================

	ldy	SFX_NEW
	beq	bskip_sound
	jsr	trigger_sound           ; 52 cycles
	lda	#0
	sta	SFX_NEW
bskip_sound:
	sta	WSYNC

	;=============================
	; 23-24 scanlines -- update sound
	;=============================
	; takes two scanlines

        jsr     update_sound            ; 2 scanlines

        sta     WSYNC

        ;===================================
        ; 25 scanlines -- check button press
	;===================================

	lda	TITLE_COUNTDOWN
	beq	bubs_waited_enough
	dec	TITLE_COUNTDOWN
	bne	bubs_done_check_input

bubs_waited_enough:
	lda     INPT4		; check joystick button pressed 	; 3
	bmi	bubs_done_check_input

	; make sure in front of stand

	lda	CHEAT_Y
	cmp	#120
	bcs	bubs_done_check_input

	lda	CHEAT_X
	cmp	#90
	bcs	bubs_done_check_input
	cmp	#64
	bcc	bubs_done_check_input

	bcs	show_bubs						; 2/3

bubs_done_check_input:

	sta	WSYNC

	;============================
	; 26 scanlines -- movement
	;============================
	; takes 4 scanlines

	jsr	common_movement

	sta	WSYNC                   ;                               ; 3

	jmp	bubs_loop


show_bubs:
	sta	WSYNC		; timing
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	jmp	big_bubs
