; Parallax

; how this works:
;	mirrored display
;	left/right edge (PF0) is set to zigzag pattern based on scanline
;	center (PF2) is the wide checkerboard, drawn on top
;	two quad-sized sprites used for smaller background layer

; by Vince `deater` Weaver

; music based on tune by mA2E

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
;	$139 = 313 bytes	guess we're trying to do music
;	$132 = 306 bytes	try to simplify zigzag code

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

NUM_WSYNCS = 66

	ldx	#NUM_WSYNCS
delay_scanlines:
	cpx	#(NUM_WSYNCS-30)	; triggers at scanline 30
	beq	do_vsync
skip1:
	cpx	#(NUM_WSYNCS-33)	; triggers at scanline 34?
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

	lda	#$86			; medium blue			; 2
	sta	COLUP0							; 3
	sta	COLUP1			; color of sprite grid		; 3
; 12
	lda	#NUSIZ_QUAD_SIZE	; $07				; 2
	sta	NUSIZ0			; make sprite grid large	; 3
	sta	NUSIZ1							; 3
; 20
	lda	#CTRLPF_REF|CTRLPF_PFP	; priority/reflect ($05)	; 2
	sta	CTRLPF							; 3
; 25

	; setup sprite0/sprite1 xpos
	; SPRITE0_X always 48	(39+7 ??)
	;	note strobe happens 5 clocks later on player sprite
	;  (68+48)/3=116/3=38R2  39*3=117+5=122-7=115?
	lda	#$70		; -7					; 2
	sta	HMP0		; fine adjust				; 3
; 30
	; SPRITE1_X always 82	(49+5 ??)
	; (68+82)/3=150/3=50	49*3=147+5=152-5=147?
	lda	#$50		; -5					; 2
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



	;=========================
	; play music
	;=========================

play_frame:

	;============================
	; see if still counting down
; 3

song_countdown_smc:
	lda	SOUND_COUNTDOWN						; 3
	bpl	done_update_song					; 2/3

set_note_channel0:
; 8
	;==================
	; load next byte

	ldx	SOUND_POINTER						; 3
	inc	SOUND_POINTER						; 5
	lda	music+1,X						; 4+
; 20
	bne	not_end		; 0 means end				; 2/3

	;====================================
	; if at end, loop back to beginning
; 22
;	lda	#0							; 2
	sta	SOUND_POINTER						; 3
	beq	done_update_song	; bra				; 3

; 23
not_end:
	ldx	#0
	jsr	play_note

	ldx	SOUND_POINTER						; 3
	lda	music,X							; 4+
	ldx	#1
	jsr	play_note

	lda	#$8							; 2
	sta	SOUND_COUNTDOWN						; 3

	;============================
	; point to next

	; don't have to, PLA did it for us

done_update_song:
	dec	SOUND_COUNTDOWN						; 3

	lda	SOUND_COUNTDOWN						; 3
	cmp	#4
	bcc	quieter

	lda	#$f
	sta	AUDV0
	lda	#$A
	bne	done_volume	; bra

quieter:
	lda	#$A							; 2
	sta	AUDV0							; 3
	lda	#$8
done_volume:
	sta	AUDV1
	sta	WSYNC


	;=========================================
	; scanline 32/33 : setup zigzag
	;=========================================
; 0
	; zigzag when music hits?

	lda	#0			; load ?			; 2
;	ldx	FRAMEH			; get high frame		; 3
;	cpx	#4			; only start after 4 big frames	; 2
;	bcc	zigzag_start		; blt

	ldx	MUSIC_HIT		; check if a music hit (?)	; 3
	beq	zigzag_start		; if 0, start?			; 2/3

	dec	MUSIC_HIT		; countdown the hit		; 5
;	clc				;				; 2
;	adc	#$8			; offset is 16 instead		; 2
	lda	#$8

zigzag_start:
	sta	ZIGZAG_OFFSET
;	ldx	#8			; load countdown		; 2
;	tay				; move pointer to Y		; 2

;zigzag_loop:
;	lda	zigzag,Y		; copy offset into zero page	; 4
;	sta	ZIGZAG0,X						; 4
;	dey
;	dex								; 2
;	bne	zigzag_loop						; 2/3

;	; 2+ 13*8 -1 = 105

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

	;==============
	lda	FRAMEL
	lsr
	lsr
	sta	FRAMEL_DIV4

	;==============

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
	; comes in at 0/3 cycles

	; X=0, Y=0

; 3

	;============================
	; set sprite pattern
	;============================
	; if (scanline-(frame/4))&8 (every 8 on/off) flip

	ldy	#$AA		; load 1010 pattern			; 2
; 5
	txa			; load scanline				; 2
	sec								; 2
	sbc	FRAMEL_DIV4	; subtract off, moves at 1/4 speed	; 3
; 12
	and	#$8		; this controls height of tiny box	; 2
; 14
	beq	alternate_sprite0					; 2/3
	ldy	#$55		; 0101 pattern				; 2
alternate_sprite0:
; 18 worst case
	sty	GRP0		; store sprite0				; 3
	sty	GRP1		; store sprite1				; 3
; 24

	;============================
	; set playfield pattern
	;============================
	ldy	#$3C		; regular pattern			; 2
	txa			; get scanline				; 2
	sec								; 2
	sbc	FRAMEL		; subtract frame			; 2
	and	#$20		; only change every so often		; 2
; 34
	beq	alternate_pf0						; 2/3
	ldy	#$C3		; flipped pattern			; 2
alternate_pf0:
; 38 worst case
	sty	PF2		; set playfield				; 3
; 41

	;=================================
	; do zig-zags

	txa				; x is scanline			; 2
	adc	FRAMEL			; add in FRAME			; 3
	and	#$7			; mask				; 2
	adc	ZIGZAG_OFFSET		; which zigzag			; 3
; 51
	tay								; 2
	lda	zigzag,Y						; 4+
	sta	PF0							; 3
; 60 worst case

	inx								; 2
	cpx	#191							; 3

; 65
	sta	WSYNC							; 3
; 68/0
;
	bne	parallax_playfield					; 2/3

	jmp	tia_frame						; 3
; 5

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


	; which is in X
	; note in A
play_note:
	ldy	#$4

	rol
	bcc	do_c	; bra						; 3
do_12:
	;ldy	#4							; 2
	sty	MUSIC_HIT	; setup zigzag shift			; 3
	ldy	#12							; 2
do_c:
	sty	AUDC0,X							; 3

	ror
	and	#$1F							; 2
	sta	AUDF0,X							; 3
	rts



; alternate

music:
.byte	$80|(60-32)	; 12,19		; C3
.byte	$80|(60-32)	; 12,19		; C3
music2:
.byte	$80|(50-32)	; 12,12		; G3
.byte	$80|(45-32)	; 4,29		; C4
.byte	28		; 4,19		; G4
.byte	23		; 4,16		; A#4
.byte	20		; 4,14		; C5
.byte	28		; 4,19		; G4
.byte	31		; 4,21		; F4

.byte	$80|(60-32)	; 12,19		; C3
.byte	$80|(50-32)	; 12,12		; G3
.byte	$80|(45-32)	; 4,29		; C4
.byte	28		; 4,19		; G4
.byte	23		; 4,16		; A#4
.byte	20		; 4,14		; C5
.byte	28		; 4,19		; G4
.byte	31		; 4,21		; F4

.byte	$80|(60-32)	; 12,19		; C3
.byte	$80|(50-32)	; 12,12		; G3
.byte	$80|(45-32)	; 4,29		; C4
.byte	28		; 4,19		; G4
.byte	23		; 4,16		; A#4
.byte	20		; 4,14		; C5
.byte	28		; 4,19		; G4
.byte	31		; 4,21		; F4

.byte	$80|(60-32)	; 12,19		; C3
.byte	$80|(50-32)	; 12,12		; G3
.byte	$80|(45-32)	; 4,29		; C4
.byte	28		; 4,19		; G4
.byte	17		; 4,16		; A#4
.byte	18		; 4,14		; C5
.byte	23		; 4,19		; G4
.byte	28		; 4,21		; F4


.byte 0



.if 0
music:
.byte	$80|(60-32)	; 12,19		; C3
music2:
.byte	$80|(50-32)	; 12,12		; G3
.byte	$80|(45-32)	; 4,29		; C4
.byte	28		; 4,19		; G4
.byte	23		; 4,16		; A#4
.byte	20		; 4,14		; C5
.byte	28		; 4,19		; G4
.byte	31		; 4,21		; F4


;music:
.byte	$80|19		; 12,19		; C4
;music2:
.byte	$80|12		; 12,12		; G4
.byte	29		; 4,29		; C5
.byte	19		; 4,19		; G5
.byte	16		; 4,16		; A#5
.byte	14		; 4,14		; C6
.byte	19		; 4,19		; G5
.byte	21		; 4,21		; F5

.byte	$80|19		; 12,19		; C4
.byte	$80|12		; 12,12		; G4
.byte	29		; 4,29		; C5
.byte	19		; 4,19		; G5
.byte	16		; 4,16		; A#5
.byte	14		; 4,14		; C6
.byte	19		; 4,19		; G5
.byte	21		; 4,21		; F5

.byte	$80|19		; 12,19		; C4
.byte	$80|12		; 12,12		; G4
.byte	29		; 4,29		; C5
.byte	19		; 4,19		; G5
.byte	16		; 4,16		; A#5
.byte	14		; 4,14		; C6
.byte	19		; 4,19		; G5
.byte	21		; 4,21		; F5

.byte	$80|19		; 12,19		; C4
.byte	$80|12		; 12,12		; G4
.byte	29		; 4,29		; C5
.byte	19		; 4,19		; G5
.byte	11		; 4,16		; D#6
.byte	12		; 4,14		; D6
.byte	16		; 4,19		; A#5
.byte	19		; 4,21		; G5

.byte	0
.endif

; alternate F/9 volume channel 0
; alternate 9/5 volume channel 1

; C4/G4/C5/G5/D#6/D6/A#5/G5
;             11  12  16


.segment "IRQ_VECTORS"
	.word vcs_desire	; NMI
	.word vcs_desire	; RESET
	.word vcs_desire	; IRQ
