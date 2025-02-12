	;viznut's combination of xpansive's and varjohukka's stuff
	;http://pouet.net/topic.php?which=8357&page=4
	;(t>>7|t|t>>6)*10+4*(t&t>>13|t>>6)
	;in 128 bytes on Atari VCS by Tjoppen

	; modified for vsync by deater


; takes roughly 2 lines = 76*2 = 152 cycles
	; 8kHz (original design) = 125us
	; Atari 2600 = 1.19MHz = .84us = ~150 cycles

	; so ideally
	; VSYNC on at 0
	; VSYNC off at 3
	; VBLANK off at 40	/ 2 = 20 $14
	; VBLANK on at 232	/ 2 =116 $74

.include "../../vcs.inc"

COUNTER1	= $80   ; t
COUNTER2	= $81	; t >> 6
COUNTER3	= $82	; t >> 7
COUNTER4	= $83	; t >> 13
TEMP	 	= $84

FRAME_COUNT	= $85
VSYNC_VALUE	= $86
VBLANK_COUNT	= $87

.org $FF80

demo_start:

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
	cld			; we do use adc/sbc

;	lda	#$02
;	sta	VBLANK_COUNT

;

; 48
sample_loop:
	; repeat 64 times (COUNTER1)
	ldx	#64							; 2

; 20 / 50
output_loop:

	; want to write 2 if <20 || >116, 0 otherwise
	ldy	FRAME_COUNT						; 3
	cpy	#116	; carry clear if greater			; 2
	rol								; 2
	cpy	#20	; carry clear if less				; 2
	rol		;                                     +11 want	; 2
	clc		; xxxx xx00                <116  <20   X11  1X	; 2
	adc	#3	;        01 fine           <116  >20   100  0X	; 2
			;        10 not possible?  >116  <20   101  XX
			;        11                >116  >20   110  1X

	sta	VBLANK							; 3

; 38 / 68

	dec	FRAME_COUNT						; 5
	bne	skip_reset_vsync					; 2/3
reset_vsync:
; 45 / 75
	lda	#131		; reset to 131*2 = 262 scanlines	; 2
	sta	FRAME_COUNT						; 3
; 50 / 80
	lda	#$38		;					; 2
	sta	VSYNC_VALUE						; 3
; 46 / 66 / 55 / 85
skip_reset_vsync:
	lsr	VSYNC_VALUE						; 5
	lda	VSYNC_VALUE						; 8
; 59 / 79 / 68 / 98
	sta	WSYNC							; 3
; 62 / 82 / 73 / 101

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
; 12
	asl			; A=temp*4				; 2
	asl								; 2
	clc								; 2
	adc	TEMP							; 3
	sta	TEMP		; temp = (c1|c2|c3)*5			; 3
; 24
	lda	COUNTER1						; 3
	and	COUNTER4						; 3
	ora	COUNTER2	; A=(c1&c4)|c2				; 3
	asl			; *2					; 2
	clc								; 2
	adc	TEMP		; A=(c1|c2|c3)*5 + ((c1&c4)|c2)*2	; 3
	lsr								; 2
	lsr								; 2
; 44
	.byte	$4B,$1F		; and #$1F, lsr	(asr #1F)		; 2
; 46
	tay			; A proper value, masked with $1F	; 2
; 48
	sta	AUDV0       	; 5-bit PCM				; 3
	adc	#0		; ??? rounded?				; 2
	sta	AUDV1							; 3
; 56
	lsr	VSYNC_VALUE						; 5
	lda	VSYNC_VALUE						; 3
	sta	WSYNC							; 3
; 67
; 0
	sta	VSYNC							; 3

; 3
	tya			; restore original			; 2
	ora	#$60		; light blue				; 2
	sta	COLUBK		; set background color			; 3
; 10

	inc	COUNTER1	; t++					; 5
; 15
	dex								; 2
	bne	output_loop	; loop 64 times				; 2/3
; 19
	;==============================
	; here only every 1/64 of time

	inc	COUNTER2	; c2++ (t >> 6)				; 5
	lda	COUNTER2						; 3
	and	#$7F		; mask off high bit			; 2
	bne	Counter4_OK	; branch most of time			; 2/3
; 31

	inc	COUNTER4	; only inc 1/128 of time (t>>13)	; 5

; 32 / 36
Counter4_OK:
	; TODO: lsr/bne makes interesting change
;	and	#$01		; check bottom bit			; 2

	lsr			; check bottom bit			; 2
	bcs	Counter3_OK						; 2/3

; 36 / 40
	inc	COUNTER3	; only inc 1/2 of time (t>>7)		; 5

; 37 / 41 / 45
Counter3_OK:
	jmp	sample_loop						; 3
; 48

PF1Tab:
PF2Tab:


demo_end:

	.res 128-(demo_end-demo_start)-4,$EA     ; nops


	.word demo_start	; RESET vector
	nop
	nop

