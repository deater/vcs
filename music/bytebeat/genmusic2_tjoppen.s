    ;viznut's combination of xpansive's and varjohukka's stuff
    ;http://pouet.net/topic.php?which=8357&page=4
    ;(t>>7|t|t>>6)*10+4*(t&t>>13|t>>6)
    ;in 128 bytes on Atari VCS by Tjoppen


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

	; ldx #0 (reset vector points to $FF7E == $FFFE)
Start:
	cld
	txa
ClearStack:
	dex
	txs
	pha
	bne	ClearStack
	; SP=$FF, X = A = 0, Y unknown

	lda	#1
	sta	CTRLPF	; set playfield to reflect

SampleLoop:
	; repeat 64 times (COUNTER1)
	ldx	#64
OutputLoop:

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
	bne	OutputLoop						; 2/3
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
	jmp	SampleLoop						; 3

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

	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111

;    echo "ROM:", ($FFFC - *), "bytes left"

	nop
	nop


    .word Start-2
	ldx	#0          ;wraps around to Start
