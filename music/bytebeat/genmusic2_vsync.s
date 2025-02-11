	;viznut's combination of xpansive's and varjohukka's stuff
	;http://pouet.net/topic.php?which=8357&page=4
	;(t>>7|t|t>>6)*10+4*(t&t>>13|t>>6)
	;in 128 bytes on Atari VCS by Tjoppen

	; modified for vsync by deater


; takes roughly 2 lines = 76*2 = 152 cycles
	; 8kHz (original design) = 125us
	; Atari 2600 = 1.19MHz = .84us = ~150 cycles

.include "../../vcs.inc"

COUNTER1 =	$80   	; t
COUNTER2 =	$81	; t >> 6
COUNTER3 =	$82	; t >> 7
COUNTER4 =	$83	; t >> 13
TEMP	 =	$84

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

;	sei			; not really necssary?
	cld			; we do use adc/sbc

sample_loop:
	; repeat 64 times (COUNTER1)
	ldx	#64
output_loop:

	; (t>>7|t|t>>6)*10+4*(t&t>>13|t>>6)
	; (COUNTER1 | COUNTER2 | COUNTER3)*5 +
	;	2*(COUNTER1 & COUNTER4 | COUNTER2) >> 3
; 0
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

;
	.byte	$4B		; and #n-lsr A
	.byte	$1F		; same as and #$1f, lsr			; 2
;	asr	#%11111
; 46
	tay			; A proper value, masked with $1F	; 2
; 48
	sta	WSYNC							; 3
; 0
	sta	AUDV0       	; 5-bit PCM				; 3
	adc	#0		; ??? rounded?				; 2
	sta	AUDV1							; 3
;  8
	tya			; restore original			; 2
	ora	#$50							; 2
	sta	COLUPF		; set color				; 3
; 15
	lda	PF1Tab,Y	; set pattern				; 4+
	sta	PF1							; 3
	lda	PF2Tab,Y						; 4+
	sta	PF2							; 3
; 29

	inc	COUNTER1	; t++					; 5
; 34
	dex								; 2
	bne	output_loop						; 2/3
; 42

	;==============================
	; here only every 1/64 of time

	inc	COUNTER2	; c2++ (t >> 6)				; 5
	lda	COUNTER2						; 3
	and	#$7F		; mask off high bit			; 2
	bne	Counter4_OK	; branch most of time			; 2/3

	inc	COUNTER4	; only inc 1/128 of time (t>>13)	; 5
Counter4_OK:
	and	#$01		; check bottom bit			; 2
	bne	Counter3_OK						; 2/3

	inc	COUNTER3	; only inc 1/2 of time (t>>7)		; 5
Counter3_OK:
	jmp	sample_loop						; 3

PF1Tab:
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

	.byte %00000001
	.byte %00000011
	.byte %00000111
	.byte %00001111
	.byte %00011111
	.byte %00111111
	.byte %01111111

PF2Tab:
	.byte %00000000
	.byte %10000000
	.byte %11000000
	.byte %11100000
	.byte %11110000
	.byte %11111000
	.byte %11111100
	.byte %11111110
	.byte %11111111

demo_end:

	.res 128-(demo_end-demo_start)-4,$EA     ; nops


	.word demo_start	; RESET vector
	nop
	nop

