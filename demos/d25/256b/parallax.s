; Parallax

; how this works:
;	mirrored display
;	left/right edge (PF0) is set to zigzag pattern based on scanline
;	center (PF2) is the wide checkerboard, drawn on top
;	two quad-sized sprites used for smaller background layer

; by Vince `deater` Weaver

.include "../../../vcs.inc"

; zero page addresses

.include "zp.inc"


; size optimization
;	$15F = 351 bytes	original code
;	$14F = 335 bytes	low-hanging optimizations
;	$121 = 289 bytes	hard-code sprite xpos values
;	$FB  = 250 bytes	remove extraneous initialization
;	$F4  = 244 bytes	move overscan around
;	$DF  = 223 bytes	merge overscan/vsync/vblank
;	$D2  = 210 bytes	set sprite locations at same time

	;=============================
	; clear out mem / init things
	;=============================

	; can assume S starts at $FD on 6502

vcs_desire:

	sei			; disable interrupts			; 2
	cld			; clear decimal mode			; 2
	ldx	#0							; 2
	txa								; 2
clear_loop:
	dex								; 2
	txs								; 2
	pha								; 3
	bne	clear_loop						; 2/3
						;============================
	; S = $FF, A=$0, x=$0, Y=??		;	8+(256*10)-1=2567 / 10B


;======================================================================
; MAIN LOOP
;======================================================================


tia_frame:

	;====================================
	; handle overscan/vsync/vblank (NTSC)
	;====================================

	; so what we want to happen here is
	;	enable vblank:	write 2 to VBLANK
	;	overscan:	delay 30 scanlines
	;	enable vsync:	write 2 to VSYNC
	;	vsync:		delay 3 scanlines
	;	disable vsync:	write 0 to VSYNC
	;	do VBLANK:	37 scanlines, but we want to do stuff in some
	;	disable vblank:	write 0 to VBLANK

	;=============================
	; enable VBLANK

	ldy	#2		; we want this to happen in hblank	; 2
	sty	VBLANK		;					; 3

	;=============================
	; overscan

	; let's delay 63

	;  0  1 .. 30 .. 34 .. 63
	; 63 62 .. 33 .. 29 .. 0
	;
	;

NUM_WSYNCS = 66

	ldx	#NUM_WSYNCS
delay_scanlines:
	cpx	#(NUM_WSYNCS-30)	; triggers at scanline 30
	beq	do_vsync
skip1:
	cpx	#(NUM_WSYNCS-34)	; triggers at scanline 34?
	bne	skip_vsync
do_vsync:
	sty	VSYNC
	ldy	#0
skip_vsync:
	sta	WSYNC							; 3
	dex								; 2
	bne	delay_scanlines						; 2/3


	;========================
	; VBLANK scanlines 0..30
	;========================

	; already happened

; 4
	;================================================
	; VBLANK scanline 31 -- init
	;================================================

	; other init

	lda	#$86		; medium blue				; 2
	sta	COLUP0							; 3
	sta	COLUP1		; color of sprite grid			; 3
; 12
	lda	#NUSIZ_QUAD_SIZE					; 2
	sta	NUSIZ0		; make sprite grid large		; 3
	sta	NUSIZ1							; 3
; 20
	lda	#CTRLPF_REF|CTRLPF_PFP	; reflect			; 2
	sta	CTRLPF			; also playfield priority	; 3
; 25

	; setup sprite0/sprite1 xpos
	; SPRITE0_X always 48	(39+7 ??)
	lda	#$70		; +7					; 2
	sta	HMP0		; fine adjust				; 3
; 30
	; SPRITE1_X always 82	(49+5 ??)
	lda	#$50							; 2
	sta	a:HMP1		; force 4 cycles			; 4
; 36
	;===============================================================
	; set up sprite0/sprite1 to be at proper X position
	;===============================================================
	; sprite0 is always at 39 cycles
	; sprite1 is always at 49 cycles

; 36
        sta     RESP0			; set sprite0 xpos at 39	; 3
; 39
	pha	; combine for nop7
	pla

;	nop
;	nop
;	lda	$80	; nop3
; 46
        sta     RESP1			; set sprite1 xpos at 49	; 3
; 49

	sta	WSYNC
	sta	HMOVE		; finalize fine adjust



	;=========================================
	; scanline 32/33 : setup zigzag
	;=========================================
; 0
	; zigzag when music hits?
	lda	#8
	ldx	FRAMEH
	cpx	#4
	bcc	zigzag_start

	ldx	MUSIC_HIT		; check if music hit		; 2
	beq	zigzag_start		; if 
	dec	MUSIC_HIT
	clc
	adc	#$8
zigzag_start:
	ldx	#8
	tay
zigzag_loop:
	lda	zigzag,Y						; 4
	sta	ZIGZAG0,X						; 4
	dey
	dex								; 2
	bne	zigzag_loop						; 2/3

	; 2+ 13*8 -1 = 105

	sta	WSYNC

	;================================================
	; VBLANK scanline 36 -- init
	;================================================
; 3

	; increment frame
	inc	FRAMEL                                                  ; 5
	bne	no_frame_oflo						; 2/3
frame_oflo:
        inc	FRAMEH                                                  ; 5
no_frame_oflo:





	lda	FRAMEL
	rol
	lda	FRAMEH
	rol
	and	#$7
	tay
	lda	fg_colors,Y
	sta	COLUPF							; 3
; 37
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3
	tax				; scanline=0
	tay
; 41
	sta	WSYNC							; 3



	;=========================
	;=========================
	; kernel
	;=========================
	;=========================
	; 192 scanlines

parallax_playfield:
	; comes in at 3 cycles

; 3

	;============================
	; set sprite pattern
	;============================
	lda	FRAMEL							; 3
	lsr								; 2
	lsr								; 2
	sta	TEMP2							; 3
; 13
	ldy	#$AA							; 2
	txa								; 2
	sec								; 2
	sbc	TEMP2							; 2
	and	#$8							; 2
; 23
	beq	alternate_sprite0					; 2/3
	ldy	#$55							; 2
alternate_sprite0:
; 27
	sty	GRP0							; 3
	sty	GRP1							; 3
; 33

	;============================
	; set playfield pattern
	;============================
	ldy	#$3C							; 2
	txa								; 2
	sec								; 2
	sbc	FRAMEL							; 2
	and	#$20							; 2
; 43
	beq	alternate_pf0						; 2/3
	ldy	#$C3							; 2
alternate_pf0:
; 47
	sty	PF2							; 3
; 50

	txa								; 2
	adc	FRAMEL							; 3
	and	#$7							; 2
	tay								; 2
	lda	ZIGZAG0,Y						; 4+
	sta	PF0							; 3

; 63 worst case

	inx								; 2
	cpx	#191							; 1

; 67
	sta	WSYNC							; 3
; 70/0
;
	bne	parallax_playfield					; 2/3


done_parallax:
	sta	WSYNC

	jmp	tia_frame

zigzag:
	.byte $80,$40,$20,$10, $10,$20,$40,$80
zigzag2:
	.byte $40,$40,$20,$20, $40,$40,$20,$20

fg_colors:
	.byte $4E,$9E,$AE,$12, $4E,$9E,$AE,$7E

fine_adjust_table:
        ; left
;	.byte $70,$60,$50,$40,$30,$20,$10,$00
	; right -1 ... -8
;	.byte $F0,$E0,$D0,$C0,$B0,$A0,$90,$80


.segment "IRQ_VECTORS"
	.word vcs_desire	; NMI
	.word vcs_desire	; RESET
	.word vcs_desire	; IRQ
