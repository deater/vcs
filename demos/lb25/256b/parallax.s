; Parallax

; 256 byte demo for Lovebyte 2025

; by Vince `deater` Weaver / dSr

; music based on tune by mA2E

; how this works:
;	mirrored display
;	left/right edge (PF0) is set to zigzag pattern based on scanline
;	center (PF2) is the wide checkerboard, drawn on top
;	two quad-sized sprites used for smaller background layer


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
;	$134 = 308 bytes	back to stable 262 scanlines
;	$12F = 303 bytes	optimize sound playback a bit
;	$11F = 287 bytes	use patterns for a mini tracker
;	$11B = 283 bytes	remove FRAMEH
;	$118 = 280 bytes	optimize init code
;	$115 = 277 bytes	reuse PATTERN_INDEX as FG_COUNT
;	$114 = 276 bytes	some minor reuses of 0'd registers
;	$112 = 274 bytes	shave a few more bytes off
;	$10E = 270 bytes	hard-code music note assumptions
;	$10A = 266 bytes	simplify zig-zag
;	$FD =  253 bytes	forgot to remove rest of zig-zag code
;	$FC =  252 bytes	optimize setting X=scanline=0
;	$FE =  254 bytes	init stack to 0, can't depend on $FD

vcs_desire:

	;=============================
	; clear out mem / init things
	;=============================
	; 5-byte version by Omegamatrix

	; can assume S starts at $FD on 6502
	;	note on stella need to disable random SP for this to happen
	;	also on real hardware with harmony cart it's not FD :(

	; A=??
	txa
clear_loop:
	dex
	txs
	pha
	bne	clear_loop


;	asl			; should clear to 0 within 8 iterations
;	pha			; push on stack
;	tsx			; check if stack hits 0
;	bne	clear_loop

; RIOT ram $80-$F6 clear, TIA clear except VSYNC
; SP=$00, X=0, A=0, carry is clear

;	pha			; clear VSYNC, SP=$FF
;	sei			; not really necssary?
	cld			; we do use adc/sbc



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

NUM_WSYNCS = 67

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


; Y=0

	;========================
	; VBLANK scanlines 0..32
	;========================

	; already happened

; 4

	;================================================
	; VBLANK scanline 33 -- init
	;================================================

	; other init
; 4
	lda	#$AA			; medium blue			; 2

;	lda	#$86			; medium blue			; 2
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
	;========================
	; increment frame
	inc	FRAMEL                                                  ; 5
	nop								; 2
; 46
        sta     RESP1			; set sprite1 xpos at 49	; 3
; 49

; Y=0?  TODO, tya

	;==========================
	; zigzag with music

;	tya								; 2
; 51
;	lda	#0			; default no zigzag		; 2

;	ldx	MUSIC_HIT		; check if a music hit (?)	; 3
;	beq	zigzag_start		; if 0, skip			; 2/3
; 56
;	dec	MUSIC_HIT		; countdown the hit		; 5
;	lda	#$8			; offset into zigzag table	; 2

;zigzag_start:
; 57 / 63
;	sta	ZIGZAG_OFFSET						; 3

; 60 / 66
	sta	WSYNC
	sta	HMOVE			; finalize fine adjust


	;=========================
	; VBLANK 34+35: play music
	;=========================

play_frame:

	;============================
	; see if still counting down
; 3

song_countdown_smc:
	lda	SOUND_POINTER						; 3
	and	#$7							; 2

	pha								; 3

; 11
	ldx	#$A		; preload useful constant		; 2
	cmp	#4							; 2
	bcc	quieter		; blt					; 2/3
louder:				; louder first half of note
; 17

	txa			; $A channel 1				; 2
	ldx	#$f		; $F channel 0				; 2
	bne	done_volume	; bra					; 3
quieter:
; 18
;	ldx	#$A		; channel 0				; 2
	lda	#$8		; channel 1				; 2
done_volume:
; 24 / 20
	stx	AUDV0		; set volume channel 0			; 3
	sta	AUDV1		; set volume channel 1			; 3
; 30 / 26

	pla								; 4

	bne	done_song_early						; 2/3

set_note_channel0:
; 36 / 32
	;==================
	; load next notes

	lda	LAST_NOTE		; chan1 is echo of chan0	; 3
	ldx	#1			; channel 1			; 2
	jsr	play_note		; play_note			; 6+27
; 74 / 70
	lda	SOUND_POINTER						; 3
	lsr								; 2
	lsr								; 2
	lsr				; have track+note		; 2
; 83 / 79
	pha				; save				; 3
	and	#7			; just get note			; 2
	tay				; put in y			; 2
	pla				; restore track+note		; 4
; 94 / 90
	and	#$18			; see if pattern 0		; 2
	beq	m2							; 2/3
m1:
; 
	lda	music,Y			; load note			; 4+
	bne	skip			; bra				; 3
m2:
; 
	lda	music2,Y		; load note			; 4+
skip:
; 
	sta	LAST_NOTE		; save for later		; 3
	ldx	#0			; channel 0			; 2
	jsr	play_note		; play_note			; 6+27

; 
;	jmp	not_early						; 3
	; A never 0
	bne	not_early		; bra


done_song_early:
; 37 / 33
	sta	WSYNC							; 3
not_early:
;

	inc	SOUND_POINTER						; 5
; 


	sta	WSYNC

	;================================================
	; VBLANK scanline 36 -- init
	;================================================
; 0

	;====================================
	; precalc FRAMEL/4 for drawing code

	lda	FRAMEL							; 3
	lsr								; 2
	lsr								; 2
	sta	FRAMEL_DIV4						; 3
; 10
	;=======================================
	; rotate through the playfield colors

	lda	FRAMEL							; 3
	and	#$e0							; 2
	tay								; 2

	; this does $00, $20, $40, $60, ... $E0

	; 5, 4, D, F not horrible

	; TODO: find optimal offset for colors
	lda	vcs_desire+$8,Y						; 4+
	sta	COLUPF							; 3

; 24
	ldx	#0			; also scanline=0		; 2
	stx	VBLANK                  ; turn on beam			; 3
; 29

	ldy	#$AA			; load alternating 1010 pattern	; 2
	sty	GRP0			; put in both sprits		; 3
	sty	GRP1							; 3

; 37
	sta	WSYNC							; 3



	;=========================
	;=========================
	; kernel
	;=========================
	;=========================
	; 192 scanlines

parallax_playfield:
	; comes in at 0/3 cycles

	; X=0

; 3

	;============================
	; set sprite pattern
	;============================
	; if (scanline-(frame/4))&8 (every 8 on/off) flip

	txa			; load scanline				; 2
	sec								; 2
	sbc	FRAMEL_DIV4	; subtract off, moves at 1/4 speed	; 3
; 10
	and	#$8		; this controls height of tiny box	; 2

	sta	REFP0		; set earlier to $AA, reflect		; 3
	sta	REFP1							; 3
; 18

	;============================
	; set playfield pattern
	;============================
	ldy	#$3C		; regular pattern			; 2
	txa			; get scanline				; 2
	sec								; 2
	sbc	FRAMEL		; subtract frame			; 2
	and	#$20		; only change every so often		; 2
; 28
	beq	alternate_pf0						; 2/3
	ldy	#$C3		; flipped pattern			; 2
alternate_pf0:
; 32 worst case
	sty	PF2		; set playfield				; 3
; 35

	;=================================
	; do zig-zags

	txa				; x is scanline			; 2
	adc	FRAMEL			; add in FRAME			; 3
	ldy	LAST_NOTE						; 3
	bpl	oops							; 2/3
	ror								; 2
oops:
	and	#$7			; mask				; 2
;	adc	ZIGZAG_OFFSET		; which zigzag			; 3
;
	tay								; 2
	lda	zigzag,Y						; 4+
	sta	PF0							; 3
;
	inx								; 2
	cpx	#191							; 3

;
	sta	WSYNC							; 3
;
;
	bne	parallax_playfield					; 2/3

	jmp	tia_frame						; 3
; 5

zigzag:
	.byte $80,$40,$20,$10, $10,$20,$40,$80

;zigzag2:
;	.byte $40,$40,$20,$20, $40,$40,$20,$20

	;===============================
	; play note
	;===============================
	; which channel is in X
	; note in A
; 0
play_note:
	ldy	#$4		; pre-load instrument	(want 4 or 12)	; 2
	rol			; put high bit in C			; 2
; 4
	bcc	do_c		; if not set, then instrument 4		; 2/3
do_12:
; 6
	sty	MUSIC_HIT	; set 4 long musical hit for elsewhere	; 3
	ldy	#12		; want instrument 12			; 2
do_c:
; 7 / 11
	sty	AUDC0,X		; store out instrument			; 4
; 11/15
	lsr			; strips off top bit, so no mask	; 2
	sta	AUDF0,X		; set frequency				; 4
	rts								; 6
; 23/27



; alternate F/9 volume channel 0
; alternate 9/5 volume channel 1

music:
.byte	$80|(60-32)	; 12,19		; C3
.byte	$80|(50-32)	; 12,12		; G3
.byte	$80|(45-32)	; 4,29		; C4
.byte	28		; 4,19		; G4
.byte	23		; 4,16		; A#4
.byte	20		; 4,14		; C5
.byte	28		; 4,19		; G4
.byte	31		; 4,21		; F4

music2:
.byte	$80|(60-32)	; 12,19		; C3
.byte	$80|(50-32)	; 12,12		; G3
.byte	$80|(45-32)	; 4,29		; C4
.byte	28		; 4,19		; G4
.byte	17		; 4,16		; A#4
.byte	18		; 4,14		; C5
.byte	23		; 4,19		; G4
.byte	28		; 4,21		; F4


.word	vcs_desire-2	; RESET vector
;.word	$0		; IRQ vector (unused)
	ldx	#0

;.segment "IRQ_VECTORS"
;	.word vcs_desire	; NMI
;	.word vcs_desire	; RESET
;	.word vcs_desire	; IRQ

