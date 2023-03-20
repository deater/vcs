; strongbadia

; min=2? max=152?

; o/~ come to the place where tropical breezes blow o/~


	lda	#50				; set X position
	ldy	#DESTINATION_STRONGBADIA	; destination

strongbadia_start:

	pha
	lda	#120				; set initial Y position
	sta	CHEAT_Y
	pla
	jsr	init_level		; 1 scanline

strongbadia_loop:

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
update_flag_horizontal:
; 0
	lda	#78						; 3
	ldx	#0						; 2
	jsr	set_pos_x		; 2 scanlines		; 6+62
	sta	WSYNC

	;==========================
	; scanline 33
	;==========================
wait_pos3:
	dey								; 2
	bpl	wait_pos3	; 5-cycle loop (15 TIA color clocks)	; 2/3

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
wait_pos2:
	dey                                                             ; 2
	bpl	wait_pos2	; 5-cycle loop (15 TIA color clocks)    ; 2/3

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
bushes_top_loop:
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
	txa								; 2
	cmp	#22							; 2
	bcc	no_incy							; 2/3
	and	#$1							; 2
	bne	no_incy							; 2/3
	iny								; 2
no_incy:
; 48 (worst case)

	lda	sbadia_overlay_colors,Y					; 4+
	sta	COLUP0							; 3
	lda	sbadia_overlay_sprite,Y					; 4+
	sta	GRP0							; 3
; 62
	inx								; 2
	lda	bushes_bg_colors,X					; 4+
	cpx	#60							; 2
; 70
	sta	WSYNC
	bne	bushes_top_loop


	ldx	#0
	ldy	#0

	;===========================
	; 48 lines of strongbadia
	;===========================
strongbadia_top_loop:
; 3
	lda	#$D4							; 2
	sta	COLUBK							; 3
; 8
	lda	strongbadia_colors,X					; 4+
	sta	COLUPF							; 3
; 15
	lda	#$00							; 2
	sta	PF0							; 3
	; must write by CPU 22 [GPU 68]
; 20
	lda	strongbadia_playfield1_left,X				; 4+
	sta	PF1							; 3
	; must write by CPU 28 [GPU 84]
; 27
	lda	strongbadia_playfield2_left,X				; 4+
	sta	PF2							; 3
	; must write by CPU 38 [GPU 116]
; 34

	nop


	txa								; 2
	and	#$1							; 2
	bne	no_incy2						; 2/3
	iny								; 2
no_incy2:
	lda	below_fence_colors,Y					; 4+
	sta	COLUP0							; 3
	lda	below_fence_sprite,Y					; 4+
	sta	GRP0							; 3


	inx								; 2
	cpx	#48							; 2
; 70
	sta	WSYNC
	bne	strongbadia_top_loop

	;===========================
	; scanline 48
	;===========================

	lda	CHEAT_DIRECTION
	sta	REFP0

	lda	#0
	sta	HMP1

	sta	WSYNC

	;===========================
	; scanline 49
	;===========================
	; update cheat horizontal
update_cheat_horizontal:
; 0
	lda	CHEAT_X						; 3
	ldx	#0						; 2
	jsr	set_pos_x		; 2 scanlines		; 6+62
	sta	WSYNC

	;==========================
	; scanline 52
	;==========================
wait_pos1:
	dey								; 2
	bpl	wait_pos1	; 5-cycle loop (15 TIA color clocks)	; 2/3

	sta	RESP0							; 4
	sta	WSYNC
	sta	HMOVE

	;===========================
	; bottom of screen
	;===========================
	; at scanline 112

	ldy	#0
	ldx	#112
bottom_loop:

; 3
	; activate cheat sprite

	cpx	CHEAT_Y							; 2
	bne	done_activate_cheat					; 2/3
activate_cheat:
	ldy	#10							; 2
done_activate_cheat:

	lda	cheat_sprite_black,Y
	sta	GRP0
	lda	cheat_sprite_yellow,Y
	sta	GRP1

	tya
	beq	level_no_cheat

	dey

level_no_cheat:

	inx

	sta	WSYNC

	inx
	cpx	#184
	sta	WSYNC
	bne	bottom_loop

	;===================
	; 8 scanlines
	;===================

	jsr	draw_score


	;============================
	; overscan
	;============================
strongbadia_overscan:
	lda	#$2		; turn off beam
	sta	VBLANK

	; wait 30 scanlines

	ldx	#26
	jsr	scanline_wait


        ;==================
        ; 23


        ldy     SFX_NEW
        beq     skip_sound
        jsr     trigger_sound           ; 52 cycles
        lda     #0
        sta     SFX_NEW
skip_sound:
        sta     WSYNC

        jsr     update_sound            ; 2 scanlines
        sta     WSYNC

	;============================
	;

	jsr	common_movement

	sta	WSYNC                   ;                               ; 3

	jmp	strongbadia_loop


cheat_sprite_yellow:
	.byte $00
	.byte $00
	.byte $7D
	.byte $3F
	.byte $7E
	.byte $7F
	.byte $7D
	.byte $7F
	.byte $3E
	.byte $57
	.byte $FC

cheat_sprite_black:
	.byte $00
	.byte $00
	.byte $0A
	.byte $00
	.byte $04
	.byte $01
	.byte $0B
	.byte $02
	.byte $04
	.byte $A2
	.byte $04
