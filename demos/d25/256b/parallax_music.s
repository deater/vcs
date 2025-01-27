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
;	$134 = 308 bytes	back to stable 262 scanlines
;	$12F = 303 bytes	optimize sound playback a bit
;	$11F = 287 bytes	use patterns for a mini tracker
;	$11B = 283 bytes	remove FRAMEH

; TODO: move music patterns later and re-use 0
;       optimize init code
;	generate zigzag2 from zigzag1?  lsr?
;	squish music player based on this song

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
	pha	; combine for nop7					; 3
	pla								; 4
; 46
        sta     RESP1			; set sprite1 xpos at 49	; 3
; 49

	;==========================
	; zigzag with music

	lda	#0			; default no zigzag		; 2

	ldx	MUSIC_HIT		; check if a music hit (?)	; 3
	beq	zigzag_start		; if 0, skip			; 2/3

	dec	MUSIC_HIT		; countdown the hit		; 5
	lda	#$8			; offset into zigzag table	; 2

zigzag_start:
	sta	ZIGZAG_OFFSET						; 3
; 17 / 11


; 66
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
	lda	SOUND_COUNTDOWN						; 3
	bpl	done_song_early						; 2/3

set_note_channel0:
; 8
	;==================
	; load next notes

	lda	LAST_NOTE		; chan1 is echo of chan0	; 3
	ldx	#1			; channel 1			; 2
	jsr	play_note		; play_note			; 6+27
; 46
	ldy	SOUND_POINTER						; 3
	inc	SOUND_POINTER		; point to next note		; 5
; 54
	lda	music,Y			; load note			; 4+
; 58
	bne	not_end			; 0 means end of pattern	; 2/3

	;====================================
	; if end of pattern, move to next
; 60
next_pattern:
	; FIXME: just use PATTERN_INDEX for FG_COUNT?
	inc	FG_COUNT		; update color			; 5
	inc	PATTERN_INDEX		; move to next pattern		; 5
	lda	PATTERN_INDEX						; 3
	and	#$3							; 2
	tax								; 2
	lda	music_patterns,X					; 4
	sta	SOUND_POINTER						; 3
; 84
	jmp	not_early		; bra				; 3

not_end:
; 61
	sta	LAST_NOTE		; save for later		; 3
	ldx	#0			; channel 0			; 2
	jsr	play_note		; play_note			; 6+27

; 99
	lda	#$8			; note 8 frames long		; 2
	sta	SOUND_COUNTDOWN						; 3
; 104
	bne	not_early		; bra				; 3

done_song_early:
; 9
	sta	WSYNC							; 3
not_early:
; 76 / 87 / 107

	dec	SOUND_COUNTDOWN	; count down the note			; 5
	lda	SOUND_COUNTDOWN	; also check value			; 3
; 115
	ldx	#$A		; preload useful constant		; 2
	cmp	#4							; 2
	bcc	quieter							; 2/3
; 121
louder:			; louder first half of note
	txa			; $A channel 1				; 2
	ldx	#$f		; $F channel 0				; 2
	bne	done_volume	; bra					; 3
quieter:
; 122
;	ldx	#$A		; channel 0				; 2
	lda	#$8		; channel 1				; 2
done_volume:
; 124 / 128
	stx	AUDV0		; set volume channel 0			; 3
	sta	AUDV1		; set volume channel 1			; 3
; 130 / 134
	sta	WSYNC

	;================================================
	; VBLANK scanline 36 -- init
	;================================================
; 0
	;========================
	; increment frame
	inc	FRAMEL                                                  ; 5

; 5
	;====================================
	; precalc FRAMEL/4 for drawing code

	lda	FRAMEL							; 3
	lsr								; 2
	lsr								; 2
	sta	FRAMEL_DIV4						; 3
; 15
	; rotate through the playfield colors

	ldy	FG_COUNT						; 3
	lda	vcs_desire,Y		; FIXME: look for best colors	; 4+
	sta	COLUPF							; 3

; 25
	lda	#0							; 2
	sta	VBLANK                  ; turn on beam			; 3
; 30

	tax				; scanline=0			; 2

; 32
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

;fg_colors:
;	.byte $4E,$9E,$AE,$12, $4E,$9E,$AE,$7E

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

music_patterns:
.byte 0,0,0,9

music:
.byte	$80|(60-32)	; 12,19		; C3
.byte	$80|(50-32)	; 12,12		; G3
.byte	$80|(45-32)	; 4,29		; C4
.byte	28		; 4,19		; G4
.byte	23		; 4,16		; A#4
.byte	20		; 4,14		; C5
.byte	28		; 4,19		; G4
.byte	31		; 4,21		; F4
.byte 0

music2:
.byte	$80|(60-32)	; 12,19		; C3
.byte	$80|(50-32)	; 12,12		; G3
.byte	$80|(45-32)	; 4,29		; C4
.byte	28		; 4,19		; G4
.byte	17		; 4,16		; A#4
.byte	18		; 4,14		; C5
.byte	23		; 4,19		; G4
.byte	28		; 4,21		; F4
.byte 0


.segment "IRQ_VECTORS"
	.word vcs_desire	; NMI
	.word vcs_desire	; RESET
	.word vcs_desire	; IRQ
