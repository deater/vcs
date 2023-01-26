; Make the Apple II logo on an Atari 2600
; try to fit in 1k?

; by Vince `deater` Weaver <vince@deater.net>

; $830 -- original code
; $730 -- remove playfield_right2 (always 0)
; $530 -- remove playfield_left0 (always 0)
; $486 -- skip first 9 lines (always 0)
; $3ff -- only read color every 1/3 line
; $38D -- only read playfield_left1 every 1/3 line
; $31A -- only read playfield_right1 every 1/3 line

; TODO: Music?
;	Animated sine wave down sides?
;	Forever text

.include "../../vcs.inc"

; zero page addresses

TEXT_COLOR		=	$80
TEMP1			=	$90
TEMP2			=	$91
DIV3			=	$92
XSAVE			=	$93
COLOR_OFFSET		=	$94

apple_tiny_start:

	;=======================
	; clear registers/ZP/TIA
	;=======================

	sei			; disable interrupts
	cld			; clear decimal mode
	ldx	#0
	txa
clear_loop:
	dex
	txs
	pha
	bne	clear_loop

	; S = $FF, A=$0, x=$0, Y=??

start_frame:

	;=========================
	; Start Vertical Blank
	;=========================

	lda	#2			; reset beam to top of screen
	sta	VSYNC

	; wait for 3 scanlines of VSYNC

	sta	WSYNC			; wait until end of scanline
	sta	WSYNC

	inc	TEXT_COLOR		; update text color

	sta	WSYNC

	lda	#0			; done beam reset
	sta	VSYNC

	; 37 lines of vertical blank

	ldx	#36
	jsr	scanline_wait
; 10
	sta	WSYNC

	lda	#0			; turn on beam
	sta	VBLANK

	;===========================
	;===========================
	; playfield
	;===========================
	;===========================
	; draw 192 lines



	;===========================
	; first 9 lines black
	;===========================

	lda	#0
	sta	COLUPF
	ldx	#8
	jsr	scanline_wait

	; FIXME: X already 0 here?
; 10
	tsx
	stx	XSAVE

	lda	#0
	sta	PF0
	ldy	#0
	ldx	#171
	sta	DIV3
	lda	#2
	sta	COLOR_OFFSET

	sta	WSYNC

colorful_loop:
; 3
	txs
	lda	colors,Y		;				4+
	sta	COLUPF			; set playfield color		3
	lda	row_lookup,X		;				4+
	tax
; 10/11
;	lda	#0			; always 0			2
;	sta	PF0			;				3
	; has to happen by 22
; 15/16
	lda	playfield1_left,X	;				4+
	sta	PF1			;				3
	; has to happen by 28
; 22/23
	lda	playfield2_left,X	;				4+
	sta	PF2			;				3
	; has to happen by 38
; 29/30
	lda	playfield0_right,X	;				4+
	sta	PF0			;				3
	; has to happen 28-49
; 36/37
	lda	playfield1_right,X	;				4+
	sta	PF1			;				3
	; has to happen 38-56
; 43/44
	lda	#0			; always 0			2
	sta	PF2			;				3
	sta	PF0
	; has to happen 49-67
; 52/53

	dec	DIV3	; 5
	bpl	not3	; 2/3

	lda	#2		; 2
	sta	DIV3		; 3
	iny			; 2
not3:
; 66/67
;	ldy	COLOR_OFFSET		;				3

; 70/71

	tsx				;				2
	dex				;				2
;	cpx	#171			;				2
; 74/75

	sta	WSYNC			;				3
; 80
	bne	colorful_loop		;				2/3


	ldx	XSAVE
	txs


	;==============================================================
	; 48-pixel sprite!!!!
	;==============================================================

	;================
	; scanline 180
	;	set things up

	lda	TEXT_COLOR
	sta	COLUP0	; set sprite color
	sta	COLUP1	; set sprite color

	lda	#NUSIZ_THREE_COPIES_CLOSE
	sta	NUSIZ0
	sta	NUSIZ1

	lda	#0		; turn off sprite
	sta	GRP0
	sta	GRP1

	lda	#1		; turn on delay
	sta	VDELP0
	sta	VDELP1

	sta	WSYNC

	;=================
	; scanline 181

	; to center exactly would want sprite0 at
	;	CPU cycle 41.3
	; and sprite1 at
	;	GPU cycle 44

	ldx	#7		;				2
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

	; wait 30 scanlines

	ldx	#30
	jsr	scanline_wait

	jmp	start_frame


	;====================
	; scanline wait
	;====================
	; scanlines to wait in X

scanline_wait:
	sta	WSYNC
	dex						; 2
	bne	scanline_wait				; 2/3
	rts						; 6


;.align $100

; multiples of 3 except very last

colors:
	.byte $CE	;$CE,$CE,$CE
	.byte $CC	;$CC,$CC,$CC
	.byte $CA	;$CA,$CA,$CA
	.byte $C8	;$C8,$C8,$C8
	.byte $C6	;$C6,$C6,$C6
	.byte $C4	;$C4,$C4,$C4
	.byte $C2	;$C2,$C2,$C2
	.byte $C4	;$C4,$C4,$C4
	.byte $C6	;$C6,$C6,$C6
	.byte $C8	;$C8,$C8,$C8
	.byte $CA	;$CA,$CA,$CA
	.byte $CC	;$CC,$CC,$CC
	.byte $CE	;$CE,$CE,$CE
	.byte $CE	;$CE,$CE,$CE
	.byte $CC	;$CC,$CC,$CC
	.byte $CA	;$CA,$CA,$CA
	.byte $C8	;$C8,$C8,$C8
	.byte $C6	;$C6,$C6,$C6
	.byte $C4	;$C4,$C4,$C4
	.byte $C2	;$C2,$C2,$C2
	.byte $1E	;$1E,$1E,$1E
	.byte $1C	;$1C,$1C,$1C
	.byte $1A	;$1A,$1A,$1A
	.byte $18	;$18,$18,$18
	.byte $16	;$16,$16,$16
	.byte $14	;$14,$14,$14
	.byte $12	;$12,$12,$12
	.byte $2E	;$12,$2E,$2E
	.byte $2C	;$2E,$2C,$2C
	.byte $2A	;$2C,$2A,$2A
	.byte $28	;$2A,$28,$28
	.byte $26	;$28,$26,$26
	.byte $24	;$26,$24,$24
	.byte $22	;$24,$22,$22
	.byte $4E	;$22,$4E,$4E
	.byte $4C	;$4E,$4C,$4C
	.byte $4A	;$4C,$4A,$4A
	.byte $48	;$4A,$48,$48
	.byte $46	;$48,$46,$46
	.byte $44	;$46,$44,$44
	.byte $42	;$44,$42,$42
	.byte $42	;$42,$42,$5E
	.byte $5E	;$5E,$5E,$5C
	.byte $5C	;$5C,$5C,$5A
	.byte $5A	;$5A,$5A,$58
	.byte $58	;$58,$58,$56
	.byte $56	;$56,$56,$54
	.byte $54	;$54,$54,$52
	.byte $52	;$52,$52,$AE
	.byte $AE	;$AE,$AE,$AC
	.byte $AC	;$AC,$AC,$AA
	.byte $AA	;$AA,$AA,$A8
	.byte $A8	;$A8,$A8,$A6
	.byte $A6	;$A6,$A6,$A4
	.byte $A4	;$A4,$A4,$A2
	.byte $A2	;$A2,$A2,$A2
	.byte $00	;$00,$00,$00



row_lookup:
;.byte	0,0,0,0,0,0,0,0,0,0,0,0,
.byte 0,0,0,36,35,34,33,32,31,30,29,28,28,28,28,27,27,27,27,17,17,17,17,17,18,18,18,18,18,19,19,19,19,19,19,20,20,20,20,20,20,26,26,26,26,26,26,26,26,26,25,25,25,25,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,22,22,21,21,21,21,21,20,20,20,20,20,19,19,19,19,18,18,18,17,16,15,14,13,12,11,10,9,8,8,8,7,7,7,7,7,7,6,6,6,6,6,6,6,6,6,5,4,4,4,4,4,4,4,4,3,3,3,3,3,3,2,2,2,1,1
;.byte 0,0,0,0,0,0,0,0,0
.if 0
row_lookup:
;.byte	0,0,0,0,0,0,0,0,0,
.byte	1,1,2,2,2,3,3,3,3,3,3,4,4,4,4,4
.byte	4,4,4,5,6,6,6,6,6,6,6,6,6,7,7,7
.byte	7,7,7,8,8,8,9,10,11,12,13,14,15
.byte	16,17,18,18,18,19,19,19,19,20,20
.byte	20,20,20,21,21,21,21,21,22,22,23
.byte	23,23,23,23,23,23,23,23,23,23,23
.byte	23,23,23,23,23,24,24,24,24,24,24
.byte	24,24,24,24,23,23,23,23,23,23,23
.byte	23,23,23,23,23,23,23,23,23,23,22
.byte	22,22,22,22,22,22,25,25,25,25,26
.byte	26,26,26,26,26,26,26,26,20,20,20
.byte	20,20,20,19,19,19,19,19,19,18,18
.byte	18,18,18,17,17,17,17,17,27,27,27
.byte	27,28,28,28,28,29,30,31,32,33,34
.byte	35,36,0,0,0
;.byte 0,0,0,0,0,0,0,0,0,0,0,0
.endif

playfield1_left:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$01,$01,$03,$03
	.byte $03,$03,$01,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00
playfield2_left:
	.byte $00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$18,$3C,$3C,$7C,$7E,$FE
	.byte $FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF
	.byte $FF,$FF,$FF,$FE,$FC,$FC,$FC,$7C
	.byte $78,$38,$38,$38,$10
playfield0_right:
	.byte $00,$00,$80,$C0,$E0,$E0,$F0,$70
	.byte $30,$10,$10,$00,$80,$80,$C0,$C0
	.byte $E0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	.byte $F0,$F0,$F0,$F0,$F0,$F0,$C0,$C0
	.byte $80,$80,$80,$00,$00
playfield1_right:
	.byte $00,$80,$80,$80,$80,$00,$00,$00
	.byte $00,$00,$E0,$E0,$F0,$F0,$F0,$F0
	.byte $F8,$F8,$F8,$FC,$FC,$F8,$F8,$F0
	.byte $E0,$FC,$FE,$F0,$F0,$E0,$E0,$E0
	.byte $E0,$E0,$C0,$C0,$C0


;.align	$100

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
	.word apple_tiny_start	; NMI
	.word apple_tiny_start	; RESET
	.word apple_tiny_start	; IRQ

