; Purple Beat -- 128 byte Atari 2600 demo

; some byte beat, with valid NTSC vsync timings

; by vince `deater` weaver / dSr

; this is based off of Tjoppen's 128 byte demo (w/o sync)
; which is based off of viznut's combination of xpansive's
; and varjohukka's stuff from the pouet thread
; http://pouet.net/topic.php?which=8357&page=4
; (t>>7|t|t>>6)*10+4*(t&t>>13|t>>6)


	; takes roughly 2 lines = 76*2 = 152 cycles
	; 8kHz (bytebeat frequency) = 125us
	; Atari 2600 = 1.19MHz = .84us = ~150 cycles

	; NTSC scyn timings, ideally
	; VSYNC on at 0
	; VSYNC off at 3
	; VBLANK off at 40	/ 2 = 20 $14
	; VBLANK on at 232	/ 2 =116 $74

.include "../../../vcs.inc"

; zero page RAM addresses

COUNTER1	= $80   ; t
COUNTER2	= $81	; t >> 6
COUNTER3	= $82	; t >> 7
COUNTER4	= $83	; t >> 13
TEMP	 	= $84

VSYNC_VALUE	= $86

.org $FF80

demo_start:
	; try to get consistent start so we can center sprite

	sta	WSYNC

	; can assume S starts at $FD on 6502
	;       note on stella need to disable random SP for this to happen

clear_loop:
	asl			; should clear to 0 within 8 iterations
	pha			; push on stack

	stx	CTRLPF		; set playfield to reflect (1)

	tsx			; check if stack hits 0
	bne	clear_loop

	; RIOT ram $80-$F6 clear, TIA clear except VSYNC
	; SP=$00, X=0, A=0, carry is clear

;	pha			; make stack workable for jsr
;	sei			; not really necssary?

	cld			; clear decimal mode (we do use adc/sbc)

	lda	#NUSIZ_QUAD_SIZE
	sta	NUSIZ0				; set sprite size to large

	; nops to get sprite position in right place
	inc	TEMP
	nop
	nop

	sta	RESP0				; set sprite position

; 41
sample_loop:
	; repeat 64 times (COUNTER1)
	ldx	#64							; 2

; 13 / 43
output_loop:

	;==============================
	; enable VBLANK at right time
	;==============================
	; want to write 2 if <20 || >116, 0 otherwise

	; frame count in Y
	cpy	#116	; carry clear if greater			; 2
	rol								; 2
	cpy	#20	; carry clear if less				; 2
	rol		;                                     +11 want	; 2
	clc		; xxxx xx00                <116  <20   X11  1X	; 2
	adc	#3	;        01 fine           <116  >20   100  0X	; 2
			;        10 not possible?  >116  <20   101  XX
			;        11                >116  >20   110  1X

	sta	VBLANK							; 3

; 28 / 58

	;==========================
	; reset counters
	;==========================
	; when framecount = 0
	; also start VSYNC

	dey				; dec frame count		; 2
	bne	skip_reset_vsync					; 2/3
reset_vsync:
; 32 / 62
	ldy	#131		; ($83) reset to 131*2 = 262 scanlines	; 2
	lda	#$38		;					; 2
	sta	VSYNC_VALUE						; 3
; 39 / 69 / 33 / 63
skip_reset_vsync:
	lsr	VSYNC_VALUE						; 5
	lda	VSYNC_VALUE						; 3
; 46 / 77 / 41 / 71
	sta	WSYNC							; 3
; 49 / 80 / 44 / 74

; 0
	sta	VSYNC							; 3

; 3
	; (t>>7|t|t>>6)*10+4*(t&t>>13|t>>6)
	; (COUNTER1 | COUNTER2 | COUNTER3)*5 +
	;	2*(COUNTER1 & COUNTER4 | COUNTER2) >> 3

	lda	COUNTER1						; 3
	ora	COUNTER2						; 3
	ora	COUNTER3						; 3
	sta	TEMP		; temp=counter1|counter2|counter3	; 3
; 15
	asl			; A=temp*4				; 2
	asl								; 2
	clc								; 2
	adc	TEMP							; 3
	sta	TEMP		; temp = (c1|c2|c3)*5			; 3
; 27
	lda	COUNTER1						; 3
	and	COUNTER4						; 3
	ora	COUNTER2	; A=(c1&c4)|c2				; 3
	asl			; *2					; 2
	clc								; 2
	adc	TEMP		; A=(c1|c2|c3)*5 + ((c1&c4)|c2)*2	; 3
	lsr								; 2
	lsr								; 2
; 47
	.byte	$4B,$1F		; and #$1F, lsr	(asr #1F)		; 2
				; A is final value, masked with $1F
; 49
	sta	AUDV0       	; 5-bit PCM				; 3
	adc	#0		; ??? rounded?				; 2
	sta	AUDV1							; 3
; 57

	;=========================
	; visualization
	sta	GRP0							; 3
	ora	#$60		; light purple				; 2
	sta	COLUBK		; set background color			; 3
	sty	PF1
	; room for 3 more bytes of visualization...

; 65
	;================================
	; handle vsync for odd scanlines
	;================================
	lsr	VSYNC_VALUE						; 5
	lda	VSYNC_VALUE						; 3
; 73
;	sta	WSYNC							; 3
; 76
; 0
	sta	VSYNC							; 3
; 3
	inc	COUNTER1	; t++					; 5
; 8
	dex								; 2
	bne	output_loop	; loop 64 times				; 2/3
; 12
	;==============================
	; here only every 1/64 of time

	inc	COUNTER2	; c2++ (t >> 6)				; 5
	lda	COUNTER2						; 3
	; if counter2 == 128 or counter2 == 0 then inc counter4
	and	#$7F							; 2
	bne	Counter4_OK						; 2/3
; 24

	inc	COUNTER4	; only inc 1/128 of time (t>>13)	; 5

; 25 / 29
Counter4_OK:
	; TODO: lsr/bne makes interesting change
;	and	#$01		; check bottom bit			;
;	beq	Counter3_OK
	lsr			; check bottom bit			; 2
	bcs	Counter3_OK						; 2/3

; 29 / 33
	inc	COUNTER3	; only inc 1/2 of time (t>>7)		; 5

; 30 / 34 / 38
Counter3_OK:
	jmp	sample_loop						; 3
; 41



demo_end:

	.res 128-(demo_end-demo_start)-4,$EA     ; nops


	.word demo_start	; RESET vector
	nop
	nop

