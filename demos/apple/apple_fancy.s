; Make the Apple II logo on an Atari 2600

; by Vince `deater` Weaver <vince@deater.net>

; Draws an asymmetric playfield in a very inefficient manner


.include "../../vcs.inc"

; zero page addresses

TEXT_COLOR		=	$80
TEMP1			=	$90
TEMP2			=	$91


start:
	sei		; disable interrupts
	cld		; clear decimal bit
	ldx	#$ff
	txs		; point stack to top of zero page

	; clear out the Zero Page (RAM and TIA registers)

	ldx	#0
	txa
clear_loop:
	sta	$0,X
	inx
	bne	clear_loop


start_frame:

	; Start Vertical Blank

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	; wait for 3 scanlines of VSYNC

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC

	inc	TEXT_COLOR

	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	; 37 lines of vertical blank

	ldx	#0
vblank_loop:
	sta	WSYNC
	inx
	cpx	#37
	bne	vblank_loop

	lda	#0			; turn on beam
	sta	VBLANK

	; draw 192 lines
	; need to race beam to draw other playfield

	ldx	#0
colorful_loop:
	lda	colors,X		;				4+
	sta	COLUPF			; set playfield color		3

	lda	playfield0_left,X	;				4+
	sta	PF0			;				3
	lda	playfield1_left,X	;				4+
	sta	PF1			;				3
	lda	playfield2_left,X	;				4+
	sta	PF2			;				3

	; at this point we're at 28 cycles

	nop				;				2
	lda	playfield0_right,X	;				4+
	sta	PF0			;				3

	; now at 37
	nop				;				2
	nop				;				2
	lda	playfield1_right,X	;				4+
	sta	PF1			;				3

	; now at 48

	nop				;				2
	lda	playfield2_right,X	;				4+
	sta	PF2			;				3

	; now at 57

	inx				;				2
	cpx	#180			;				2

	sta	WSYNC			;				3
	bne	colorful_loop		;				2/3

	;==============================================================
	; 48-pixel sprite!!!!
	;==============================================================

	;================
	; scanline 180
	;	set things up

	lda	TEXT_COLOR
;	lda	#$0F
	sta	COLUP0	; set sprite color
;	lda	#$2F
	sta	COLUP1	; set sprite color

	lda	#NUSIZ_THREE_COPIES_CLOSE
	sta	NUSIZ0
	lda	#NUSIZ_THREE_COPIES_CLOSE
	sta	NUSIZ1

	lda	#0		; turn off sprite
	sta	GRP0
	sta	GRP1

	lda	#1
	sta	VDELP0
	sta	VDELP1

	sta	WSYNC

	;=================
	; scanline 181

	; to center exactly would want sprite0 at
	;	CPU cycle 41.3
	; and sprite1 at
	;	GPU cycle 44


	ldx	#0		; sprite 0 display nothing	2
	stx	GRP0		;				3
	; 5


	ldx	#6		;				2
pad_x:
	dex			;				2
	bne	pad_x		;				2/3
	; 3 + 5*X each time through

	; beam is at proper place
	sta	RESP0						; 3
	; 41 (GPU=123, want 124) +1
	sta	RESP1						; 3
	; 44 (GPU=132, want 132) 0

	lda	#$F0		; opposite what you'd think
	sta	HMP0			;			3
	lda	#$00
	sta	HMP1			;			3

	sta	WSYNC
	sta	HMOVE		; adjust fine tune, must be after WSYNC

	ldx	#7		; init X
	stx	TEMP2

	; scanline 182

	sta	WSYNC

	; scanline 183

spriteloop:
	; 0
	lda	sprite_bitmap0,X	; load sprite data		; 4+
	sta	GRP0			; 0->[GRP0] [GRP1 (?)]->GRP1	; 3
	; 7
	lda	sprite_bitmap1,X	; load sprite data		; 4+
	sta	GRP1			; 1->[GRP1], [GRP0 (0)]-->GRP0	; 3
	; 14
	lda	sprite_bitmap2,X	; load sprite data		; 4+
	sta	GRP0			; 2->[GRP0], [GRP1 (1)]-->GRP1	; 3
	; 21

	lda	sprite_bitmap5,X					; 4+
	sta	TEMP1							; 3
	; 28
	lda	sprite_bitmap4,X					; 4+
	tay								; 2
	; 34
	lda	sprite_bitmap3,X	;				; 4+
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

	ldy	#0		; clear out sprites
	sty	GRP1
	sty	GRP0
	sty	GRP1

	sta	WSYNC

	; scanline 192

	;===========================
	; overscan
	;============================

	lda	#$2		; turn off beam
	sta	VBLANK

	ldx	#0
overscan_loop:
	sta	WSYNC
	inx
	cpx	#30
	bne	overscan_loop

	jmp	start_frame

.include "playfield.inc"





.align	$100

; Sprites (upside down)

sprite_bitmap0:		; AP
	.byte	$00
	.byte	$8A
	.byte	$8A
	.byte	$FA
	.byte	$8B
	.byte	$8A
	.byte	$52
	.byte	$23

sprite_bitmap1:
	.byte	$00	; PP
	.byte	$08
	.byte	$08
	.byte	$08
	.byte	$cf
	.byte	$28
	.byte	$28
	.byte	$cf

sprite_bitmap2:		; L
	.byte	$00
	.byte	$3E
	.byte	$20
	.byte	$20
	.byte	$20
	.byte	$A0
	.byte	$A0
	.byte	$20

sprite_bitmap3:		; E
	.byte	$00
	.byte	$F8
	.byte	$80
	.byte	$80
	.byte	$F0
	.byte	$80
	.byte	$80
	.byte	$F8

sprite_bitmap4:		; ]
	.byte	$00
	.byte	$0F
	.byte	$01
	.byte	$01
	.byte	$01
	.byte	$01
	.byte	$01
	.byte	$0F

sprite_bitmap5:		; [
	.byte	$00
	.byte	$BE
	.byte	$B0
	.byte	$B0
	.byte	$B0
	.byte	$B0
	.byte	$B0
	.byte	$BE

.segment "IRQ_VECTORS"
	.word start	; NMI
	.word start	; RESET
	.word start	; IRQ


