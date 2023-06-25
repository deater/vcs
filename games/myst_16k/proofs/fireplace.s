; fireplace puzzle proof of concept

.include "../../../vcs.inc"


; it's an 8x6 panel

;0123456789012345678901234567890123456789
;|||:XXX|XXX:XXX|XXX:XXX:XXX|XXX:XXX|||||
;

; $00 $EE $77 $70 $EE $07


FIREPLACE_ROW1	= $C0
FIREPLACE_ROW2	= $C1
FIREPLACE_ROW3	= $C2
FIREPLACE_ROW4	= $C3
FIREPLACE_ROW5	= $C4
FIREPLACE_ROW6	= $C5



fireplace:
	sei		; disable interrupts
	cld		; clear decimal bit

	; init zero page and addresses to 0

	ldx	#0
	txa
clear_loop:
	dex
	txs
	pha
	bne	clear_loop

	; S=$FF, A=$00, X=$00, Y=??

	lda	#34
	sta	COLUP0	; set sprite color brown

	lda	#NUSIZ_QUAD_SIZE
	sta	NUSIZ0

clock_frame:

	;============================
	; Start VBLANK
	;============================
	; in scanline 0

	jsr	common_vblank

	;=================================
	; 37 lines of vertical blank
	;=================================

	ldx	#29
	jsr	common_delay_scanlines

	;=============================
	; now at scanline 30

	; handle left being pressed
.if 0
	lda	SPRITE0_LEFT_X		;			3
	beq	after_check_left	;			2/3

	lda	#$40			; check left		2
	bit	SWCHA			;			3
	bne	after_check_left	;			2/3

left_pressed:
	dec	SPRITE0_LEFT_X		; move sprite left	5

after_check_left:
.endif
	sta	WSYNC			;			3
					;============================
					; 9 / 20 / 16 cycles

	;========================
	; now at scanline 31

	; handle right being pressed
.if 0
	lda	SPRITE0_RIGHT_X		;			3
	cmp	#160+SPRITE_WIDTH-3	;			2
	bcs	after_check_right	;			2/3

	lda	#$80			; check right		2
	bit	SWCHA			;			3
	bne	after_check_right	;			2/3

	inc	SPRITE0_LEFT_X		; move sprite right	5
after_check_right:
.endif
	sta	WSYNC			;			3
					;===========================
					; 11 / 22 / 18

	;=======================
	; now at scaline 32

	; see if up pressed
.if 0
	lda	SPRITE0_TOP_Y		;			3
	cmp	#1			;			2
	beq	after_check_up		;			2/3

	lda	#$10			; check up		2
	bit	SWCHA			;			3
	bne	after_check_up		;			2/3

	dec	SPRITE0_TOP_Y		; move sprite up	5

	jsr	spr0_moved_vertically	; 			6+17
after_check_up:
.endif
	sta	WSYNC			; 			3
					;=================================
					; 11 / 18 / 45

	;=====================
	; now scanline 33
.if 0
	lda	SPRITE0_BOTTOM_Y	;			3
	cmp	#192 - BOTTOM_LAYER_HEIGHT - 1	;		2
	bcs	after_check_down	;			2/3

	lda	#$20			;			2
	bit	SWCHA			;			3
	bne	after_check_down	;			2/3

	inc	SPRITE0_TOP_Y		; move sprite down	5
	jsr	spr0_moved_vertically	;			6+17
after_check_down:
.endif

	sta	WSYNC			;			3
					;==============================
					; 11 / 18 / 45

	;===================
	; now scanline 34

	; do this separately as too long to fit in with left/right code

;	jsr	spr0_moved_horizontally	;			6+49
	sta	WSYNC			;			3
					;============================
					;			58

	;====================
	; now scanline 35


	; set up sprite to be at proper X position
	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want


	ldx	#6
pad_x:
	dex
	bne	pad_x

	; beam is at proper place
	sta	RESP0

	sta	WSYNC
	sta	HMOVE		; adjust fine tune, must be after WSYNC

	;=======================
	; now scanline 36

.if 0

	clc					;	2
	lda	SPRITE0_PIXEL_OFFSET		;	3
	adc	SPRITE_HEIGHT			;	3
	cmp	SPRITE_TOTAL_FRAME_LINES	;	3
	bne	store_animation_frame		;	2/3

	lda	#0	; return to begin	;	2
store_animation_frame:
	sta	SPRITE0_PIXEL_OFFSET		;	3
done_frame_count:
	lda	#0				;	2
	sta	CURRENT_SCANLINE		;	3
	ldy	SPRITE0_PIXEL_OFFSET		;	3

.endif

	sta	WSYNC				;	3


	;=============================
	; now scanline 37

	lda	#0
	sta	VBLANK

	lda	#4
	sta	COLUBK

	lda	#0
	sta	COLUPF

	sta	WSYNC

	;=============================================
	; visible area: 192 lines (NTSC) / 228 (PAL)
	;=============================================

playfield_loop:

	ldx	#192
draw_loop:

; $00 $EE $77 $70 $EE $07

; 3
	lda	#$00						; 2
	sta	PF0						; 3
	; has to happen by 22 (GPU 68)
; 8
	lda	#$EE						; 2
	sta	PF1						; 3
	; has to happen by 28 (GPU 84)
; 13
	lda	#$77						; 2
	sta	PF2						; 3
	; has to happen by 38 (GPU 116)
; 18
	nop
	nop
	nop
	nop
; 26
	lda	#$70						; 2
	sta	PF0						; 3
; 31
	; has to happen 28-49

	nop
	nop
; 35
	lda	#$EE						; 2
	sta	PF1						; 3
; 40
	; has to happen 38-56

	nop
	nop
	nop
	nop

; 48
	lda	#$07						; 2
	sta	PF2						; 3
; 55
	; has to happen 49-67

	dex

	sta	WSYNC

	bne	draw_loop




	;===========================
	; overscan
	;===========================

	ldx	#30
	jsr	common_overscan



	jmp	clock_frame

;================================
;================================
; spr0 moved horizontally
;================================
;================================
; call after X changes
;	compute horiz fine adjust

spr0_moved_horizontally:
.if 0
	clc				;			2
	lda	SPRITE0_LEFT_X		;			3

	pha				;			3
	adc	SPRITE_WIDTH		;			3
	sta	SPRITE0_RIGHT_X		;			3
	pla				;			4

	; spritex DIV 16

	lsr				;			2
	lsr				;			2
	lsr				;			2
	lsr				;			2
	sta	SPRITE0_LEFT_X_COARSE	;			3

	; apply fine adjust
	lda	SPRITE0_LEFT_X		;			3
	and	#$0f			;			2
	tax				;			2
	lda	fine_adjust_table,X	;			4+
	sta	HMP0			;			3
	rts				;			6
					;==========================
					;			49


;================================
;================================
; spr0 moved vertically
;================================
;================================
; call after Y changes

spr0_moved_vertically:
	clc				;				2
	lda	SPRITE0_TOP_Y		;				3
	adc	SPRITE_HEIGHT		;				3
	sta	SPRITE0_BOTTOM_Y	;				3
	rts				;				6
					;=================================
					;				17

.align	$100

sprite_bitmap:
	.byte	$AA
	.byte	$55
	.byte	$AA
	.byte	$55
	.byte	$AA
	.byte	$55
	.byte	$AA
	.byte	$55
	.byte	$AA
	.byte	$55

sprite_bitmap2:
	.byte	$55
	.byte	$AA
	.byte	$55
	.byte	$AA
	.byte	$55
	.byte	$AA
	.byte	$55
	.byte	$AA
	.byte	$55
	.byte	$AA


fine_adjust_table:
	; left
	.byte $70
	.byte $60
	.byte $50
	.byte $40
	.byte $30
	.byte $20
	.byte $10
	.byte $00
	; right
	.byte $F0	; -1
	.byte $E0	; -2
	.byte $D0	; -3
	.byte $C0	; -4
	.byte $B0	; -5
	.byte $A0	; -6
	.byte $90	; -7
	.byte $80	; -8 (?)
.endif

.include "clock_sprites.inc"

.include "../common_routines.s"


.segment "IRQ_VECTORS"
	.word fireplace	; NMI
	.word fireplace	; RESET
	.word fireplace	; IRQ


