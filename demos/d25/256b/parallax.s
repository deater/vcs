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

	;================================
	; 3 lines of veritcal sync
	;================================
	; our code actually does 4?
	;=====================
	; our code takes 4 scanlines, clears out old one first
	; this makes sure we get a full 3 scanlines of VSYNC

	;=================================
	; wait for 3 scanlines of VSYNC
	;=================================

	lda	#2		; value to write for vsync
	sta	WSYNC		; wait until end of scanline
	sta	VSYNC

	sta	WSYNC
	sta	WSYNC
	lda	#0		; done beam reset			; 2
	sta	WSYNC
	sta	VSYNC							; 3
; 3 cycles in

	;================================
	; 37 lines of VBLANK
	;================================

	;========================
	; VBLANK scanlines 1..29
	;========================

	ldx	#30
	jsr	common_delay_scanlines

	;================================================
	; VBLANK scanline 31 -- init
	;================================================

	; increment frame
	;

	inc	FRAMEL                                                  ; 5
	bne	no_frame_oflo						; 2/3
frame_oflo:
        inc	FRAMEH                                                  ; 5
no_frame_oflo:

	; setup sprite0/sprite1 xpos

;	lda	#48		; SPRITE0_X always 48			; 2
;	lda	#3		; SPRITE0_X DIV 16 is 3
;       sta	SPRITE0_X_COARSE					; 3

	; apply fine adjust
	lda	#$70
	sta	HMP0							; 3

	; SPRITE1_X=82 = $52
; 31
        ; spritex DIV 16 = 5

;	lda	#$5
 ;       sta	SPRITE1_X_COARSE					; 3
; 42
	; apply fine adjust
	lda	#$50
	sta	HMP1							; 3

	sta	WSYNC

	;=========================================
	; scanline 32/33 : setup zigzag
	;=========================================
; 0

	lda	#8
	ldx	FRAMEH
	cpx	#$4		; not start music response until partway in
	bcc	zigzag_start


	ldx	IS_DRUM
	beq	zigzag_start
	dec	IS_DRUM
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

	;=======================================================
	; scanline 34: set up sprite0 to be at proper X position
	;=======================================================
	; value will be 0..9

; 0

;	ldx	a:SPRITE0_X_COARSE	; force 4-cycle version		; 4
	ldx	#3
	nop
; 4

	nop								; 2
	nop								; 2

; 8
	inx                     ;                                       ; 2
	inx                     ;                                       ; 2
; 12 (want to be 12 here)


	; X is 2..12 here
par_pad_x:
	dex                     ;                                       2
	bne	par_pad_x           ;                                       2/3
                                ;===========================================
                                ;       5*(coarse_x+2)-1
                                ; COARSE_X is 0..9 so
				;   9 .. 54 cycles

; up to 66
        ; beam is at proper place
        sta     RESP0                                                   ; 3
; up to 69

	sta	WSYNC


	;=======================================================
	; scanline 35: set up sprite1 to be at proper X position
	;=======================================================

; 0

;	ldx	a:SPRITE1_X_COARSE	; force 4-cycle version		; 4
	ldx	#5
	nop
; 4

	nop								; 2
	nop								; 2

; 8
	inx                     ;                                       ; 2
	inx                     ;                                       ; 2
; 12 (want to be 12 here)


par_pad_x1:
	dex			;					; 2
	bne	par_pad_x1	;					; 2/3
                                ;===========================================
                                ;       5*(coarse_x+2)-1
                                ; COARSE_X is 0..9 so
				;   9 .. 54 cycles
; up to 66
        ; beam is at proper place
	sta     RESP1                                                   ; 3
; up to 69

	sta	WSYNC
	sta	HMOVE		; finalize fine adjust



	;================================================
	; VBLANK scanline 36 -- init
	;================================================
; 3
	; other init

	lda	#$86							; 2
	sta	COLUP0							; 3
	sta	COLUP1		; color of sprite grid			; 3

; 19
	lda	#NUSIZ_QUAD_SIZE					; 2
	sta	NUSIZ0		; make sprite grid large		; 3
	sta	NUSIZ1							; 3

; 27
	lda	#CTRLPF_REF|CTRLPF_PFP	; reflect			; 2
	sta	CTRLPF			; also playfield priority	; 3
; 32


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

	jmp	effect_done

zigzag:
	.byte $80,$40,$20,$10, $10,$20,$40,$80
zigzag2:
	.byte $40,$40,$20,$20, $40,$40,$20,$20

fg_colors:
	.byte $4E,$9E,$AE,$12, $4E,$9E,$AE,$7E



	;============================
	; handle overscan
	;============================
	; NTSC 30
	; should arrive 3 cycles after a WSYNC

effect_done:

; 3
	lda	#2		; we want this to happen in hblank	; 2
	sta	VBLANK		;					; 3
; 8

	;=============================
	; overscan
	;=============================

	ldx	#30
	jsr	common_delay_scanlines

	jmp	tia_frame


fine_adjust_table:
        ; left
;        .byte $70,$60,$50,$40,$30,$20,$10,$00
        ; right -1 ... -8
 ;       .byte $F0,$E0,$D0,$C0,$B0,$A0,$90,$80

	;=====================
	; other includes




	;=============================
	; overscan
	;=============================
	; amount of scanlines to wait is in X

common_overscan:
	lda	#$2		; turn off beam
	sta	VBLANK

common_delay_scanlines:
	sta	WSYNC							; 3
	dex								; 2
	bne	common_delay_scanlines					; 2/3
	rts								; 6

; 10

.segment "IRQ_VECTORS"
	.word vcs_desire	; NMI
	.word vcs_desire	; RESET
	.word vcs_desire	; IRQ
