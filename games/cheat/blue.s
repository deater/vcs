; blue land

blue_land:

	pha
	lda	CHEAT_Y
	lsr
	sta	CHEAT_Y
	pla

	jsr	init_level

blue_loop:

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

	; no mirror playfield, sprites behind
	lda	#CTRLPF_PFP
	sta	CTRLPF

	lda	#$80
	sta	COLUBK

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
bupdate_cheat_horizontal:
; 0
	lda	CHEAT_X						; 3
	ldx	#0						; 2
	jsr	set_pos_x		; 2 scanlines		; 6+62
	sta	WSYNC

	;==========================
	; scanline 33
	;==========================
bwait_pos1:
	dey								; 2
	bpl	bwait_pos1	; 5-cycle loop (15 TIA color clocks)	; 2/3

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
bwait_pos2:
	dey                                                             ; 2
	bpl	bwait_pos2	; 5-cycle loop (15 TIA color clocks)    ; 2/3

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

;	sta	REFP0

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

	lda	#$72		; dark blue
	sta	COLUBK

	lda	#$08		; grey
	sta	COLUPF

	ldy	#0

	sta	WSYNC
	jmp	blue_bg_loop

	;===========================
	; 184 lines of title
	;===========================
blue_bg_loop:
; 3
	lda	#0							; 2
	sta	PF0							; 3
	; must write by CPU 22 [GPU 68]
; 8
	lda	blue_playfield1_left,X					; 4+
	sta	PF1							; 3
	; must write by CPU 28 [GPU 84]
; 15
	lda	blue_playfield2_left,X					; 4+
	sta	PF2							; 3
	; must write by CPU 38 [GPU 116]
; 22

	; activate cheat sprite

	cpx	CHEAT_Y                                                 ; 2
	bne	bdone_activate_cheat					; 2/3
bactivate_cheat:
	ldy	#10                                                     ; 2
	bne	bdone_activate_cheat_skip	; bra			; 3
bdone_activate_cheat:
	nop								; 2
	nop								; 2
bdone_activate_cheat_skip:
	; 9/9

; 31

	inc	TEMP1	; nop5
	lda	TEMP1	; nop3



; 39
	lda	blue_playfield0_right,X					; 4+
	sta	PF0                                                     ; 3
	; must write by CPU 49 [GPU 148]
; 46
	lda	blue_playfield1_right,X					; 4+
	sta	PF1							; 3
	; must write by CPU 54 [GPU 164]
; 53
	lda	blue_playfield2_right,X					; 4+
	sta	PF2							; 3
	; must write by CPU 65 [GPU 196]

; 60

	sta	WSYNC

; 0

	lda	$0	; nop3						; 3
	lda	#0							; 2
	sta	PF0							; 3
	; must write by CPU 22 [GPU 68]
; 8
	lda	blue_playfield1_left,X					; 4+
	sta	PF1							; 3
	; must write by CPU 28 [GPU 84]
; 15
	lda	blue_playfield2_left,X					; 4+
	sta	PF2							; 3
	; must write by CPU 38 [GPU 116]
; 22

	; put sprite

	lda	cheat_sprite_black,Y					; 4
	sta	GRP0							; 3
	lda	cheat_sprite_yellow,Y					; 4
	sta	GRP1							; 3

; 36

	lda	$00	; nop3



; 39
	lda	blue_playfield0_right,X					; 4+
	sta	PF0                                                     ; 3
	; must write by CPU 49 [GPU 148]
; 46
	lda	blue_playfield1_right,X					; 4+
	sta	PF1							; 3
	; must write by CPU 54 [GPU 164]
; 53
	lda	blue_playfield2_right,X					; 4+
	sta	PF2							; 3
	; must write by CPU 65 [GPU 196]
; 60

	tya								; 2
	beq	blevel_no_cheat						; 2/3
	dey								; 2
blevel_no_cheat:
	; 6/5

; 66

	inx								; 2
	cpx	#92							; 2
; 70
	sta	WSYNC
	bne	blue_bg_loop





	;======================
	; draw score
	;======================
	; 8 scanlines

	jsr	draw_score

	;============================
	; overscan
	;============================
blue_overscan:
	lda	#$2             ; turn off beam
	sta	VBLANK

	; wait 30 scanlines

	ldx	#26
	jsr	scanline_wait

	jsr	common_movement

.if 0

	;=============================
	; now at VBLANK scanline 27
	;=============================
	; handle down being pressed
; 0
	lda	#$20			; check down			; 2
	bit	SWCHA                   ;				; 3
	bne	bafter_check_down        ;				; 2/3
bdown_pressed:
        inc	CHEAT_Y
        inc	CHEAT_Y

bafter_check_down:
	sta	WSYNC                   ;                               ; 3

	;=============================
	; now at VBLANK scanline 28
	;=============================
	; handle up being pressed
; 0
	lda	#$10			; check up			; 2
	bit	SWCHA                   ;				; 3
	bne	bafter_check_up		;				; 2/3
bup_pressed:
        dec	CHEAT_Y
        dec	CHEAT_Y

bafter_check_up:
	sta	WSYNC                   ;                               ; 3


	;=============================
	; now at VBLANK scanline 29
	;=============================
	; handle left being pressed
; 0
	lda	#$40                    ; check left                    ; 2
	bit	SWCHA                   ;                               ; 3
	bne	bafter_check_left        ;                               ; 2/3
bleft_pressed:
        dec	CHEAT_X

	lda	#$0
	sta	CHEAT_DIRECTION

	sec
	lda	CHEAT_X
	sbc	#2
	sta	SHADOW_X


bafter_check_left:
	sta	WSYNC                   ;                               ; 3

	;=============================
	; now at VBLANK scanline 30
	;=============================
	; handle right being pressed
; 0
	lda	#$80			; check right                    ; 2
	bit	SWCHA			;                               ; 3
	bne	bafter_check_right	;                               ; 2/3
bright_pressed:
	inc	CHEAT_X
	lda	#$8
	sta	CHEAT_DIRECTION

	clc
	lda	CHEAT_X
	adc	#2
	sta	SHADOW_X


bafter_check_right:
.endif
	sta	WSYNC                   ;                               ; 3

	jmp	blue_loop


