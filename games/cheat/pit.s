; In a pit

the_pit:

	lda	#30
	sta	CHEAT_Y

	lda	#136		; x pos, center

	jsr	init_level

pit_loop:

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

	ldx	#21
	jsr	scanline_wait		; Leaves X zero
; 10
	sta	WSYNC

	;====================
	; 10 scanlines

	jsr	update_score
	sta	WSYNC


	;===========================
	; scanline 32
	;===========================
	; update cheat horizontal
pupdate_cheat_horizontal:
; 0
	lda	CHEAT_X						; 3
	ldx	#0						; 2
	jsr	set_pos_x		; 2 scanlines		; 6+62
	sta	WSYNC

	;==========================
	; scanline 33
	;==========================
pwait_pos1:
	dey								; 2
	bpl	pwait_pos1	; 5-cycle loop (15 TIA color clocks)	; 2/3

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
pwait_pos2:
	dey                                                             ; 2
	bpl	pwait_pos2	; 5-cycle loop (15 TIA color clocks)    ; 2/3

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

	lda	#NUSIZ_ONE_COPY
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

	lda	#$00		; black cheat
	sta	COLUP0
	lda	#$1C		; yellow cheat
	sta	COLUP1

	ldx	#0

	sta	WSYNC

	stx	VBLANK		; turn on beam (X=0)


	;===========================
	;===========================
	; playfield
	;===========================
	;===========================
	; draw 192 lines

	lda	#$00		; black
	sta	COLUBK

	lda	#$04		; grey
	sta	COLUPF

	ldy	#0

	sta	WSYNC


	jmp	pit_bg_loop

	;===========================
	; 184 lines of title
	;===========================
pit_bg_loop:
; 3
	lda	#0							; 2
	sta	PF0							; 3
	; must write by CPU 22 [GPU 68]
; 8
	lda	pit_playfield1_left,X					; 4+
	sta	PF1							; 3
	; must write by CPU 28 [GPU 84]
; 15
	lda	pit_playfield2_left,X					; 4+
	sta	PF2							; 3
	; must write by CPU 38 [GPU 116]
; 22

	; activate cheat sprite

	cpx	CHEAT_Y                                                 ; 2
	bne	pdone_activate_cheat					; 2/3
pactivate_cheat:
	ldy	#10                                                     ; 2
	bne	pdone_activate_cheat_skip	; bra			; 3
pdone_activate_cheat:
	nop								; 2
	nop								; 2
pdone_activate_cheat_skip:
	; 9/9

; 31
	; put sprite

	lda	cheat_sprite_black,Y					; 4
	sta	GRP0							; 3
	lda	cheat_sprite_yellow,Y					; 4
	sta	GRP1							; 3

	tya								; 2
	beq	plevel_no_cheat						; 2/3
	dey								; 2
plevel_no_cheat:
	; 6/5


	inx								; 2
	cpx	#184							; 2

	sta	WSYNC
	bne	pit_bg_loop


;	ldx	#184
;	jsr	scanline_wait


	;======================
	; draw score
	;======================
	; 8 scanlines

	jsr	draw_score

	;============================
	; overscan
	;============================
pit_overscan:
	lda	#$2             ; turn off beam
	sta	VBLANK

	; wait 30 scanlines

	ldx	#26
	jsr	scanline_wait

	jsr	common_movement

	sta	WSYNC                   ;                               ; 3

	jmp	pit_loop


