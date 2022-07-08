; trying to make a 48-pixel wide super-sprite

.include "../vcs.inc"

SPRITE_WIDTH	=	8
SPRITE_HEIGHT	=	10
BOTTOM_LAYER_HEIGHT =	20
SPRITE_ANIMATION_FRAME_COUNT = 2
SPRITE_TOTAL_FRAME_LINES = SPRITE_ANIMATION_FRAME_COUNT * SPRITE_HEIGHT

; zero page addresses

SPRITE0_LEFT_X		=	$82
SPRITE0_RIGHT_X		=	$83
SPRITE0_LEFT_X_COARSE	=	$84
SPRITE0_PIXEL_OFFSET	=	$85
CURRENT_SCANLINE	=	$86
FRAME_COUNTER		=	$87
TEMP1			=	$90
TEMP2			=	$91



start:
	cld		; clear decimal mode
	ldx	#$FF
	txs		; set stack to $FF

	lda	#$0F
	sta	COLUP0	; set sprite color
	lda	#$0D
	sta	COLUP1	; set sprite color

	lda	#$00				; set initial x position
	sta	SPRITE0_LEFT_X
;	jsr	spr0_moved_horizontally		;		6+49

	lda	#0
	sta	SPRITE0_PIXEL_OFFSET
	sta	FRAME_COUNTER

	lda	#NUSIZ_THREE_COPIES_CLOSE
	sta	NUSIZ0
	lda	#NUSIZ_THREE_COPIES_CLOSE
	sta	NUSIZ1

start_frame:

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

	lda	#0			; done beam reset
	sta	VSYNC

	;=================================
	;=================================
	; 37 lines of vertical blank
	;=================================
	;=================================

.repeat 29
	sta	WSYNC
.endrepeat

	;=============================
	; now at scanline 30

	sta	WSYNC

	;========================
	; now at scanline 31

	sta	WSYNC			; 			3

	;=======================
	; now at scaline 32

	sta	WSYNC			; 			3

	;=====================
	; now scanline 33

	sta	WSYNC			; 			3

	;===================
	; now scanline 34

	sta	WSYNC

	; set up sprite to be at proper X position
	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want

	ldx	#0		; sprite 0 display nothing	2
	stx	GRP0		;				3

	ldx	#5 ; SPRITE0_LEFT_X_COARSE	;			3
	inx			;				2
	inx			;				2
pad_x:
	dex			;				2
	bne	pad_x		;				2/3
				;==================================
				;	12-1+5*(coarse_x+2)
				; FIXME: what's going on here

	; beam is at proper place
	sta	RESP0
	sta	RESP1

	ldx	#14			;			2
	lda	fine_adjust_table,X	;			4+
	sta	HMP1			;			3

	sta	WSYNC
	sta	HMOVE		; adjust fine tune, must be after WSYNC

	;====================
	; now scanline 35


	; set up sprite to be at proper X position
	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want

;	ldx	#0		; sprite 0 display nothing	2
;	stx	GRP1		;				3
;
;	ldx	#1
;
;	ldx	SPRITE0_LEFT_X_COARSE	;			3
;	inx			;				2
;	inx			;				2
;pad_x1:
;	dex			;				2
;	bne	pad_x1		;				2/3
				;==================================
				;	12-1+5*(coarse_x+2)
				; FIXME: what's going on here

	; beam is at proper place
;	sta	RESP1

	sta	WSYNC
;	sta	HMOVE		; adjust fine tune, must be after WSYNC

	;=======================
	; now scanline 36

	; handle animated sprite
;	inc	FRAME_COUNTER	;			5
;	lda	#15		;			2
;	bit	FRAME_COUNTER	;			3

;	bne	done_frame_count	;		2/3

	; advance frame

;	clc					;	2
;	lda	SPRITE0_PIXEL_OFFSET		;	3
;	adc	SPRITE_HEIGHT			;	3
;	cmp	SPRITE_TOTAL_FRAME_LINES	;	3
;	bne	store_animation_frame		;	2/3

;	lda	#0	; return to begin	;	2
;store_animation_frame:
;	sta	SPRITE0_PIXEL_OFFSET		;	3
;done_frame_count:
;	lda	#0				;	2
;	sta	CURRENT_SCANLINE		;	3
;	ldy	SPRITE0_PIXEL_OFFSET		;	3

	sta	WSYNC				;	3
done_animation_frame:



	;=============================
	; now scanline 37

	sta	WSYNC

	;=============================================
	; visible area: 192 lines (NTSC) / 228 (PAL)
	;=============================================

	lda	#1
	sta	VDELP0
	sta	VDELP1

	ldx	#$80
	stx	COLUBK		; set background
	ldy	#0

	lda	#0			; turn off sprite
	sta	GRP0
	sta	GRP1

	ldx	#9
	stx	TEMP2

.repeat 150
	sta	WSYNC
.endrepeat

spriteloop:
	ldx	TEMP2							; 3
	; 3
	lda	sprite_bitmap0,X	; load sprite data		; 4+
	sta	GRP0			; [GRP0]			; 3
	; 10
	lda	sprite_bitmap1,X	; load sprite data		; 4+
	sta	GRP1			; [GRP1], [GRP0]-->GRP0		; 3
	; 17
	lda	sprite_bitmap2,X	; load sprite data		; 4+
	sta	GRP0			; [GRP0], [GRP1]-->GRP1		; 3
	; 24

	lda	sprite_bitmap5,X					; 4+
	sta	TEMP1							; 3
	; 31
	lda	sprite_bitmap4,X					; 4+
	tay								; 2
	; 37
	lda	sprite_bitmap3,X	;				; 4+
	ldx	TEMP1							; 3
	; 44

	nop
	nop
	nop


	sta	GRP1			; [GRP1], [GRP0]-->GRP0		; 3
	sty	GRP0			; [GRP0], [GRP1]-->GRP1		; 3
	stx	GRP1			; [GRP1], [GRP0]->GRP0		; 3
	sty	GRP0			; [GRP0], [GRP1]->GRP1 		; 3
	; 56


;	nop								; 2
;	nop								; 2
;	nop								; 2
	nop								; 2
	nop								; 2
	nop								; 2

	; 68

	dec	TEMP2							; 5
	bpl	spriteloop						; 2/3
	; 76  (goal is 76)

	ldy	#0
	sty	GRP1
	sty	GRP0
	sty	GRP1

	lda	#161
	sta	CURRENT_SCANLINE

	; draw bottom graphics
	ldx	#$B1
bottom_scan:
	cmp	#192
	beq	vertical_blank
	inx
	inx
	inx
	inx
	stx	COLUBK

	inc	CURRENT_SCANLINE
	lda	CURRENT_SCANLINE
	sta	WSYNC
	bne	bottom_scan			; bra

vertical_blank:
	lda	#$42		; enable INPT4/INPT5, start vert blank
	sta	VBLANK

	;===========================
	; overscan
	;===========================

	ldx	#0
overscan_loop:
	sta	WSYNC
	inx
	cpx	#30
	bne	overscan_loop

	jmp	start_frame

;================================
;================================
; spr0 moved horizontally
;================================
;================================
; call after X changes
;	compute horiz fine adjust

spr0_moved_horizontally:
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



.align	$100

sprite_bitmap0:			; checker
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

sprite_bitmap1:		; left triangle
	.byte	$80
	.byte	$C0
	.byte	$E0
	.byte	$F0
	.byte	$F8
	.byte	$FC
	.byte	$FE
	.byte	$FF
	.byte	$FF
	.byte	$FF

sprite_bitmap2:		; right triangle
	.byte	$01
	.byte	$03
	.byte	$07
	.byte	$0f
	.byte	$1f
	.byte	$3f
	.byte	$7f
	.byte	$FF
	.byte	$FF
	.byte	$FF

sprite_bitmap3:
	.byte	$FF
	.byte	$00
	.byte	$FF
	.byte	$00
	.byte	$FF
	.byte	$00
	.byte	$FF
	.byte	$00
	.byte	$FF
	.byte	$00

sprite_bitmap4:
	.byte	$FF
	.byte	$FF
	.byte	$FF
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$FF
	.byte	$FF
	.byte	$FF
	.byte	$00

sprite_bitmap5:
	.byte	$FF
	.byte	$81
	.byte	$81
	.byte	$81
	.byte	$81
	.byte	$FF
	.byte	$81
	.byte	$81
	.byte	$81
	.byte	$FF




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



.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ


