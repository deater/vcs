    ;viznut's combination of xpansive's and varjohukka's stuff
    ;http://pouet.net/topic.php?which=8357&page=4
    ;(t>>7|t|t>>6)*10+4*(t&t>>13|t>>6)
    ;in 128 bytes on Atari VCS by Tjoppen

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
	sta	CTRLPF	; reflect

SampleLoop:
	; repeat 64 times (COUNTER1)
	ldx	#64
OutputLoop:
	; (t>>7|t|t>>6)*10+4*(t&t>>13|t>>6)
	; (COUNTER1 | COUNTER2 | COUNTER3)*5 + 2*(COUNTER1 & COUNTER4 | COUNTER2) >> 3
	lda	COUNTER1
	ora	COUNTER2
	ora	COUNTER3
	sta	TEMP
	asl
	asl
	clc
	adc	TEMP
	sta	TEMP
	lda	COUNTER1
	and	COUNTER4
	ora	COUNTER2
	asl
	clc
	adc	TEMP
	lsr
	lsr
;
	.byte	$4B		; and #n-lsr A
	.byte	$1F
;	asr	#%11111
	tay
	sta	WSYNC
	sta	AUDV0       ;5-bit PCM
	adc	#0
	sta	AUDV1
	tya
	ora	#$50
	sta	COLUPF
	lda	PF1Tab,Y
	sta	PF1
	lda	PF2Tab,Y
	sta	PF2

	inc	COUNTER1

	dex
	bne	OutputLoop

	inc	COUNTER2    ;t >> 6
	lda	COUNTER2
	and	#$7F
	bne	Counter4OK
	inc	COUNTER4
Counter4OK:
	and	#$01
	bne	Counter3OK
	inc	COUNTER3
Counter3OK:
	jmp	SampleLoop

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
    ldx #0          ;wraps around to Start
