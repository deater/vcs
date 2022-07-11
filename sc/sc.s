; secret collect.
;
; based on the Videlectrix game from Homestarrunner.com
;

; by Vince `deater` Weaver	<vince@deater.net>

; 10 pixels for score
; 10 pixels for MANS
; 10 pixels for time bar
; 152 pixels for playfield?
; 10 pixels for VIDELECTRIX


.include "../vcs.inc"

SPRITE_WIDTH	=	8
SPRITE_HEIGHT	=	10
BOTTOM_LAYER_HEIGHT =	20
SPRITE_ANIMATION_FRAME_COUNT = 1
SPRITE_TOTAL_FRAME_LINES = SPRITE_ANIMATION_FRAME_COUNT * SPRITE_HEIGHT

VID_LOGO_START	=	182

; zero page addresses

STRONGBAD_X		=	$80
STRONGBAD_Y		=	$81
STRONGBAD_END_Y		=	$82
SPRITE0_RIGHT_X		=	$83
STRONGBAD_X_COARSE	=	$84
SPRITE0_PIXEL_OFFSET	=	$85
CURRENT_SCANLINE	=	$86
FRAME			=	$87

TEMP1			=	$90
TEMP2			=	$91

start:
	;============================
	;============================
	; initial init
	;============================
	;============================

	cld			; clear decimal mode

	ldx	#$FF		; set stack to $1FF (mirrored at $FF)
	txs

	lda	#$00				; set initial x position
	sta	STRONGBAD_X
	jsr	spr0_moved_horizontally		;		6+49

	lda	#1				; initial sprite Y
	sta	STRONGBAD_Y
	jsr	spr0_moved_vertically

	lda	#0
	sta	SPRITE0_PIXEL_OFFSET
	sta	FRAME


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

	; now in VSYNC scanline 3

	lda	#0			; done beam reset
	sta	VSYNC

	;=================================
	;=================================
	; 37 lines of vertical blank
	;=================================
	;=================================

.repeat 28
	sta	WSYNC
.endrepeat

	;=============================
	; now at VBLANK scanline 28
	;=============================
	; reset back to strongbad sprite

	lda	#$40		; dark red				; 2
	sta	COLUP0		; set sprite color			; 3

	lda	#NUSIZ_ONE_COPY						; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

	lda	#0							; 2
	sta	VDELP0							; 3
	sta	VDELP1							; 3

	sta	WSYNC							; 3
								;============
								;	24
	;=============================
	; now at VBLANK scanline 29
	;=============================
	; handle left being pressed

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

	lda	SPRITE0_RIGHT_X		;				; 3
	cmp	#160+SPRITE_WIDTH-3	;				; 2
	bcs	after_check_right	;				; 2/3

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

	lda	STRONGBAD_Y		;				; 3
	cmp	#1			;				; 2
	beq	after_check_up		;				; 2/3

	lda	#$10			; check up			; 2
	bit	SWCHA			;				; 3
	bne	after_check_up		;				; 2/3

	dec	STRONGBAD_Y		; move sprite up		; 5

	jsr	spr0_moved_vertically	; 				; 6+17
after_check_up:
	sta	WSYNC			; 				; 3
					;	===============================
					; 			11 / 18 / 45

	;==========================
	; now VBLANK scanline 32
	;==========================
	; handle down being pressed

	lda	STRONGBAD_END_Y		;				; 3
	cmp	#VID_LOGO_START		;				; 2
	bcs	after_check_down	;				; 2/3

	lda	#$20			;				; 2
	bit	SWCHA			;				; 3
	bne	after_check_down	;				; 2/3

	inc	STRONGBAD_Y		; move sprite down		; 5
	jsr	spr0_moved_vertically	;				; 6+17
after_check_down:
	sta	WSYNC			;				; 3
					;	==============================
					; 			11 / 18 / 45

	;==========================
	; now VBLANK scanline 33
	;==========================
	; update horizontal position

	; do this separately as too long to fit in with left/right code

	jsr	spr0_moved_horizontally	;				6+49
	sta	WSYNC			;				3
					;====================================
					;				58

	;========================
	; now VBLANK scanline 34
	;========================
	; set up sprite to be at proper X position

	; we can do this here and the sprite will be drawn as a long
	; vertical column
	; later we only enable it for the lines we want

	ldx	#0		; sprite 0 display nothing		2
	stx	GRP0		; (FIXME: this already set?)		3

	ldx	STRONGBAD_X_COARSE	;				3
	inx			;					2
	inx			;					2
pad_x:
	dex			;					2
	bne	pad_x		;					2/3
				;===========================================
				;	12-1+5*(coarse_x+2)
				; FIXME: describe better what's going on

	; beam is at proper place
	sta	RESP0							; 3

	sta	WSYNC							; 3
	sta	HMOVE		; adjust fine tune, must be after WSYNC	; 3
				; also draws black artifact on left of
				; screen

	;=======================
	; now scanline 35
	;========================
	; increment frame
	; handle any frame-related activity

	inc	FRAME							; 5
;	lda	#15							; 2
;	bit	FRAME							; 3

;	bne	done_frame_count					; 2/3

	sta	WSYNC							; 3


	;=============================
	; now VBLANK scanline 36
	;=============================

	sta	WSYNC

	; now scanline 37

	;=============================================
	;=============================================
	; visible area: 192 lines (NTSC) / 228 (PAL)
	;=============================================
	;=============================================

	ldx	#$80
	stx	COLUBK		; set background
	lda	#0
	sta	CURRENT_SCANLINE

visible_loop:

	;========================================
	; activate strongbad sprite if necessary
	;========================================

	; A = current scanline
	cmp	STRONGBAD_END_Y
	bcs	turn_off_sprite0
	cmp	STRONGBAD_Y
	bcc	turn_off_sprite0
turn_on_sprite0:
	lda	#$F0			; load sprite data
	sta	GRP0			; and display it
	iny				; increment
	jmp	after_sprite
turn_off_sprite0:
	lda	#0			; turn off sprite
	sta	GRP0
after_sprite:

	inc	CURRENT_SCANLINE
	lda	CURRENT_SCANLINE
	cmp	#VID_LOGO_START		; draw 182 lines
	sta	WSYNC
	bne	visible_loop



	;=========================================
	;=========================================
	; draw Videlectrix Logo sprite (10 lines)
	;=========================================
	;=========================================

	;====================
	; Now scanline 182
	;====================
	; configure 48-pixel sprite code

	; set color

	lda	#$2F							; 2
	sta	COLUP0	; set sprite color				; 3
	sta	COLUP1	; set sprite color				; 3

	; ?

	lda	#0							; 2
	sta	SPRITE0_PIXEL_OFFSET					; 3

	; set to be 48 adjacent pixels

	lda	#NUSIZ_THREE_COPIES_CLOSE				; 2
	sta	NUSIZ0							; 3
	sta	NUSIZ1							; 3

	; turn on delay

	lda	#1							; 2
	sta	VDELP0							; 3
	sta	VDELP1							; 3

	; number of lines to draw
	ldx	#7							; 2
	stx	TEMP2							; 3

	sta	WSYNC							; 3
								;===========


	;===================
	; now scanline 183
	;===================
	; center the sprite position
	; needs to be right after a WSYNC

	; to center exactly would want sprite0 at
	;	CPU cycle 41.3
	; and sprite1 at
	;	GPU cycle 44


	ldx	#0		; sprite 0 display nothing		; 2
	stx	GRP0		;					; 3

	ldx	#6		;					; 2
vpad_x:
	dex			;					; 2
	bne	vpad_x		;					; 2/3
	; 3 + 5*X each time through

	; beam is at proper place
	sta	RESP0							; 3
	; 41 (GPU=123, want 124) +1
	sta	RESP1							; 3
	; 44 (GPU=132, want 132) 0

	lda	#$F0		; opposite what you'd think		; 2
	sta	HMP0							; 3
	lda	#$00							; 2
	sta	HMP1							; 3

	sta	WSYNC
	sta	HMOVE		; adjust fine tune, must be after WSYNC


	;===================
	; now scanline 184
	;===================

	ldx	TEMP2		; restore length of sprite

	sta	WSYNC

	;===================
	; now scanline 185
	;===================

spriteloop:
	; 0
	lda	vid_bitmap0,X	; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
	; 7
	lda	vid_bitmap1,X	; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	; 14
	lda	vid_bitmap2,X	; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
	; 21

	lda	vid_bitmap5,X					; 4+
	sta	TEMP1							; 3
	; 28
	lda	vid_bitmap4,X					; 4+
	tay								; 2
	; 34
	lda	vid_bitmap3,X	;				; 4+
	ldx	TEMP1							; 3
	; 41

	sta	GRP1			; 3->[GRP1], [GRP0 (2)]-->GRP0	; 3
	; 44 (need this to be 44 .. 46)

	sty	GRP0			; 4->[GRP0], [GRP1 (3)]-->GRP1	; 3
	; 47 (need this to be 47 .. 49)

	stx	GRP1			; 5->[GRP1], [GRP0 (4)]-->GRP0	; 3
	; 50 (need this to be 50 .. 51)

	sty	GRP0			; ?->[GRP0], [GRP1 (5)]-->GRP1 	; 3
	; 53 (need this to be 52 .. 54)

	nop								; 2
	nop								; 2
	nop								; 2
	nop								; 2
	nop								; 2
	nop								; 2

	; 65

	dec	TEMP2							; 5
	ldx	TEMP2							; 3
	bpl	spriteloop						; 2/3
	; 76  (goal is 76)


	;
	; done drawing line
	;

	ldy	#0
	sty	GRP1
	sty	GRP0
	sty	GRP1


	;=============================================
	; vertical blank
	;=============================================
vertical_blank:
	lda	#$42		; enable INPT4/INPT5, turn off beam
	sta	VBLANK

	;===========================
	;===========================
	; overscan (30 cycles)
	;===========================
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
	lda	STRONGBAD_X		;			3

	pha				;			3
	adc	SPRITE_WIDTH		;			3
	sta	SPRITE0_RIGHT_X		;			3
	pla				;			4

	; spritex DIV 16

	lsr				;			2
	lsr				;			2
	lsr				;			2
	lsr				;			2
	sta	STRONGBAD_X_COARSE	;			3

	; apply fine adjust
	lda	STRONGBAD_X		;			3
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
	lda	STRONGBAD_Y		;				3
	adc	SPRITE_HEIGHT		;				3
	sta	STRONGBAD_END_Y	;				3
	rts				;				6
					;=================================
					;				17

.align	$100


;===================
; videlectrix logo

vid_bitmap0:	.byte	$18,$24,$24,$5A,$DB,$A5,$42,$C3
vid_bitmap1:	.byte	$00,$4e,$52,$4e,$02,$42,$80,$80
vid_bitmap2:	.byte	$00,$74,$a5,$95,$74,$04,$00,$00
vid_bitmap3:	.byte	$00,$e7,$48,$28,$e6,$00,$00,$00
vid_bitmap4:	.byte	$00,$34,$44,$44,$f7,$40,$00,$00
vid_bitmap5:	.byte	$00,$29,$26,$A6,$09,$20,$00,$00


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
