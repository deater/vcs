	;===========================
	; do some Snake Boxing!
	;===========================
	; ideally called with VBLANK disabled


	lda	#CTRLPF_REF|CTRLPF_BALL_SIZE4				; 2
							; reflect playfield
	sta	CTRLPF                                                  ; 3

	lda	#100
	sta	BOXER_X

level_frame:

	; comes in with 3 cycles from loop


	;============================
	; Start Vertical Blank
	;============================
	; actually takes 4 scanlines, clears out current then three more

	jsr	common_vblank

; 9



	;=================================
	;=================================
	; 37 lines of vertical blank
	;=================================
	;=================================

	ldx	#33
	jsr	common_delay_scanlines

	;==============================
	; now VBLANK scanline 34+35
	;==============================

	lda	#0
	sta	HMCLR

	lda	BOXER_X			; position		; 3
        ldx     #0			; 0=sprite1		; 2
        jsr     set_pos_x               ; 2 scanlines           ; 6+62
        sta     WSYNC
swait_pos1:
	dey
	bpl	swait_pos1
	sta	RESP0

	sta	WSYNC
	sta	HMOVE

	;==============================
	; now VBLANK scanline 36
	;==============================

	lda	#$FF
	sta	PF1
	sta	PF2

	lda	#0
	sta	PF0
	sta	COLUPF

	sta	GRP0
	sta	GRP1

	sta	COLUBK
	sta	VBLANK	; enable beam




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


	;===============================
	; 12 lines of score	(0..11)
	;===============================

	; draw_score here is 8 lines

.include "draw_score.s"

;	lda	#$E
;	sta	COLUPF

;	ldx	#11
;	jsr	common_delay_scanlines

	; done with score, set up rest

	lda	#$0
	sta	COLUPF
	lda	#NUSIZ_DOUBLE_SIZE
	sta	NUSIZ0
	sta	NUSIZ1


	sta	WSYNC


	;===============================
	; 8 lines of rope  (12..19)
	;===============================

	lda	#$e			; white
	sta	COLUPF

	lda	#$BF			; pattern for ropes
	sta	PF1

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

;	sta	WSYNC
;	sta	WSYNC
;	sta	WSYNC
;	sta	WSYNC

	lda	#$40			; other pattern
	sta	PF1
	lda	#$00
	sta	PF2

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	;===============================
	; 76 lines of snake (20..95)
	;===============================

	lda	#$BF
	sta	PF1
	lda	#$FF
	sta	PF2

	lda	#$6			; medium grey
	sta	COLUPF

	ldx	#76
	jsr	common_delay_scanlines

	;===============================
	; 4 lines to set up boxer
	;===============================

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	;===============================
	; 52 lines of boxer (100..151)
	;===============================


.if 0
	ldy	#0
	ldx	#24
ring_loop:
	cpx	#100
	bne	done_activate_boxer
activate_boxer:
	ldy	#11
	jmp	done_really
done_activate_boxer:
	nop
	nop
done_really:
	lda	boxer_sprite_left,Y
	sta	GRP0
	lda	boxer_sprite_right,Y
	sta	GRP1

	tya

	beq	level_no_cheat
	dey
	jmp	level_no_cheat2
level_no_cheat:
	nop
	nop
level_no_cheat2:


	inx
	sta	WSYNC
	inx
	cpx	#152
	sta	WSYNC
	bne	ring_loop
.endif

	ldx	#52
	jsr	common_delay_scanlines

	;====================================
	; 8 lines of rope (bottom) (152..159)
	;====================================

	lda	#$e			; white
	sta	COLUPF

	lda	#$40
	sta	PF1
	lda	#$00
	sta	PF2

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	lda	#$BF
	sta	PF1
	lda	#$FF
	sta	PF2

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	;====================================
	; 4 lines of blank (160..163)
	;====================================

	lda	#$0			; black
	sta	COLUPF

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	;===============================
	; 28 lines of health (164..191)
	;===============================

	lda	#134		; blue
	sta	COLUBK		; set background

	lda	#$00		; set playfield empty

	sta	PF0
	sta	PF1
	sta	PF2

	sta	WSYNC		; 4 lines of blue
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	lda	#(99*2)		; green
	sta	COLUPF

	lda	#$ff
	sta	PF1
	sta	PF2

	; 8 lines
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	; 4 lines

	lda	#$00
	sta	PF1
	sta	PF2

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	; 8 lines

	lda	#(34*2)		; red
	sta	COLUPF

	lda	#$ff
	sta	PF1
	sta	PF2

	; 8 lines
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC

	; 4 lines

	lda	#$00
	sta	PF1
	sta	PF2

	sta	WSYNC
	sta	WSYNC
	sta	WSYNC
	sta	WSYNC



	;==================================
	;==================================
	;==================================
	; overscan 30, handle end
	;==================================
	;==================================
	;==================================
	;==================================

	ldx	#28
	jsr	common_overscan


	;=============================
	; now at VBLANK scanline 29
	;=============================
	; handle left being pressed
; 0
	lda	#$40			; check left			; 2
	bit	SWCHA			;				; 3
	bne	after_check_left	;				; 2/3
left_pressed:
	lda	#32
	cmp	BOXER_X
	bcs	cant_dec
can_dec:
	dec	BOXER_X
cant_dec:

update_left:
	clc
	lda	BOXER_X
	adc	#8
	sta	RBOXER_X

after_check_left:
	sta	WSYNC


	;==================================
	; overscan 30, handle end
	;==================================
	; handle right being pressed
; 0
	lda	#$80                    ; check right                    ; 2
	bit	SWCHA                   ;                               ; 3
	bne	after_check_right       ;                               ; 2/3
right_pressed:
	lda     #104
	cmp	BOXER_X
	bcc	cant_inc
can_inc:
	inc	BOXER_X
cant_inc:

update_right:
	clc
	lda	BOXER_X
	adc	#8
	sta	RBOXER_X

after_check_right:

	jmp	level_frame




boxer_sprite_left:
	.byte	$00
	.byte	$07	; .....XXX
	.byte	$6f	; .XX.XXXX
	.byte	$6f	; .XX.XXXX
	.byte	$6f	; .XX.XXXX
	.byte	$6f	; .XX.XXXX
	.byte	$22	; .I....I.
	.byte	$60	; .II.....
	.byte	$71	; .XXX...X
	.byte	$79	; .XXXX..X
	.byte	$78	; .XXXX...
	.byte	$30	; ..XX....

boxer_sprite_right:
	.byte	$00
	.byte	$00	; .....XXX ........
	.byte	$B0	; .XX.XXXX X.XX....
	.byte	$B8	; .XX.XXXX X.XXX...
	.byte	$B8	; .XX.XXXX X.XXX...
	.byte	$98	; .XX.XXXX X..XX...
	.byte	$30	; .I....I. ..XX....
	.byte	$E0	; .II..... XXX.....
	.byte	$E0	; .XXX...X XXX.....
	.byte	$E0	; .XXXX..X XXX.....
	.byte	$C0	; .XXXX... XX......
	.byte	$00	; ..XX.... ........





;	.byte	$30	; ..XX.... ........
;	.byte	$78	; .XXXX... XX......
;	.byte	$79	; .XXXX..X XXX.....
;	.byte	$71	; .XXX...X XXX.....
;	.byte	$60	; .II..... XXX.....
;	.byte	$22	; .I....I. ..XX....
;	.byte	$6f	; .XX.XXXX X..XX...
;	.byte	$6f	; .XX.XXXX X.XXX...
;	.byte	$6f	; .XX.XXXX X.XXX...
;	.byte	$6f	; .XX.XXXX X.XX....
;	.byte	$07	; .....XXX ........
;	.byte	$00

.include "position.s"


.include "ko.inc"
