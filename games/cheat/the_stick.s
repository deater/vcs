; the stick

; o/~ bread is a good time for me o/~

the_stick:

stick_start:

	pha
	lda	#120				; set initial Y position
	sta	CHEAT_Y
	pla
	jsr	init_level		; 1 scanline

stick_loop:

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
	lda	#CTRLPF_REF
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


	jsr	update_score
	sta	WSYNC

	;===========================
	; scanline 32
	;===========================
	; update flag horizontal
update_stick_horizontal:
; 0
	lda	#78						; 3
	ldx	#0						; 2
	jsr	set_pos_x		; 2 scanlines		; 6+62
	sta	WSYNC

	;==========================
	; scanline 33
	;==========================
wait_pos4:
	dey								; 2
	bpl	wait_pos4	; 5-cycle loop (15 TIA color clocks)	; 2/3

	sta	RESP0							; 4
	sta	WSYNC

	;==========================
	; scanline 34
	;==========================
; 0
	lda	SHADOW_X						; 3
	ldx	#1							; 2
	jsr	set_pos_x		; 2 scanlines			; 6+62
	sta	WSYNC

	;==========================
	; scanline 35
	;==========================
wait_pos5:
	dey                                                             ; 2
	bpl	wait_pos5	; 5-cycle loop (15 TIA color clocks)    ; 2/3

	sta	RESP1							; 4
	sta	WSYNC


	;================================
	; scanline 36
	;================================

	lda	CHEAT_Y
	clc
	adc	#18
	sta	CHEAT_Y_END

	sta     WSYNC
        sta     HMOVE

	;=============================
	; 37
	;=============================

	lda	#NUSIZ_ONE_COPY ; NUSIZ_DOUBLE_SIZE
	sta	NUSIZ0
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

	lda	#$00		; black cheat
	sta	COLUP0
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
sbushes_top_loop:
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

	inx								; 2
	lda	bushes_bg_colors,X					; 4+
	cpx	#60							; 2
; ??
	sta	WSYNC
	bne	sbushes_top_loop


	ldx	#0
	ldy	#0

	;===========================
	; 40 lines of green
	;===========================
stick_top_loop:
; 3
	lda	#$D4							; 2
	sta	COLUBK							; 3

; 15
	lda	#$00							; 2
	sta	PF0							; 3
	sta	PF1							; 3
	sta	PF2							; 3
	; must write by CPU 38 [GPU 116]
; 34

	nop


	txa								; 2
	and	#$1							; 2
	bne	no_incy22						; 2/3
	iny								; 2
no_incy22:
	lda	stick_overlay_colors,Y					; 4+
	sta	COLUP0							; 3
	lda	stick_overlay_sprite,Y					; 4+
	sta	GRP0							; 3


	inx								; 2
	cpx	#40							; 2
; 70
	sta	WSYNC
	bne	stick_top_loop

	;===========================
	; scanline 40
	;===========================

	lda	CHEAT_DIRECTION
	sta	REFP0

	lda	#0
	sta	CXCLR		; clear collision
	sta	HMP1

	sta	WSYNC

	;===========================
	; scanline 41
	;===========================
	; update cheat horizontal
supdate_cheat_horizontal:
; 0
	lda	CHEAT_X						; 3
	ldx	#0						; 2
	jsr	set_pos_x		; 2 scanlines		; 6+62
	sta	WSYNC

	;==========================
	; scanline 42
	;==========================
swait_pos1:
	dey								; 2
	bpl	swait_pos1	; 5-cycle loop (15 TIA color clocks)	; 2/3

	sta	RESP0							; 4
	sta	WSYNC
	sta	HMOVE

	;===========================
	; bottom of screen
	;===========================
	; at scanline 104

	ldy	#0
	ldx	#104
sbottom_loop:


; 3
	; activate cheat sprite

	cpx	CHEAT_Y							; 2
	bne	sdone_activate_cheat					; 2/3
sactivate_cheat:
	ldy	#10							; 2
	jmp	sdone_really						; 3
sdone_activate_cheat:
	nop
	nop
sdone_really:
;	9/9

; 12
	lda	cheat_sprite_black,Y					; 4+
	sta	GRP0							; 3
	lda	cheat_sprite_yellow,Y					; 4+
	sta	GRP1							; 3
; 26

	tya								; 2
; 28
	beq	slevel_no_cheat						; 2/3
	dey								; 2
	jmp	slevel_no_cheat2					; 3
slevel_no_cheat:
	nop
	nop
slevel_no_cheat2:
;		7/7

; 35

	; draw the pits
	sec								; 2
	txa								; 2
	sbc	#140							; 2
	cmp	#10							; 2
	bcs	stick_nopit						; 2/3
	lda	#$ff							; 2
	bne	stick_yespit		; bra				; 3
stick_nopit:
	lda	#$00							; 2
	nop
stick_yespit:
	sta	PF1							; 3
; 16 / 16

; 51
	inx								; 2

	sta	WSYNC

	inx
	cpx	#184
	sta	WSYNC
	bne	sbottom_loop

	;===================
	; 8 scanlines
	;===================

	jsr	draw_score


	;============================
	; overscan
	;============================
stick_overscan:
	lda	#$2		; turn off beam
	sta	VBLANK

	; wait 30 scanlines

	ldx	#22
	jsr	scanline_wait

	;==================
        ; 22

	lda	CXP0FB		; p0 with field/ball
	bpl	no_fall_in_pit

	; play sound
	lda     #SFX_SPEED
	sta     SFX_NEW

	jmp	stick_to_pit

no_fall_in_pit:

	sta	WSYNC

	;==================
        ; 23


	ldy	SFX_NEW
	beq	sskip_sound
	jsr	trigger_sound           ; 52 cycles
	lda	#0
	sta	SFX_NEW
sskip_sound:
	sta     WSYNC

	jsr	update_sound            ; 2 scanlines
	sta	WSYNC

	;==================
        ; 23


	jsr	common_movement

	sta	WSYNC                   ;                               ; 3

	jmp	stick_loop

stick_to_pit:

	lda	#DESTINATION_STICK
	sta	LAST_LEVEL

	ldy	#DESTINATION_PIT

	jmp	done_level
