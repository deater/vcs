	;viznut's combination of xpansive's and varjohukka's stuff
	;http://pouet.net/topic.php?which=8357&page=4
	;(t>>7|t|t>>6)*10+4*(t&t>>13|t>>6)
	;in 128 bytes on Atari VCS by Tjoppen

	; modified for vsync by deater


; takes roughly 2 lines = 76*2 = 152 cycles
	; 8kHz (original design) = 125us
	; Atari 2600 = 1.19MHz = .84us = ~150 cycles


.include "../../vcs.inc"

COUNTER1	= $80   ; t
COUNTER2	= $81	; t >> 6
COUNTER3	= $82	; t >> 7
COUNTER4	= $83	; t >> 13
TEMP	 	= $84

FRAME_COUNT	= $85
VSYNC_VALUE	= $86

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

; 62

sample_loop:
	; repeat 64 times (COUNTER1)
	ldx	#64							; 2
; 64


; 34
output_loop:
	dec	FRAME_COUNT						; 5
	bne	skip_reset_vsync					; 2/3
reset_vsync:
; 41
	lda	#131							; 2
	sta	FRAME_COUNT						; 3
	lda	#$38							; 2
	sta	VSYNC_VALUE						; 3

; 42 / 51

skip_reset_vsync:
	lda	VSYNC_VALUE						; 3
	lsr								; 2
	sta	VSYNC_VALUE						; 3
; 50 / 59
	sta	WSYNC							; 3
; 53 / 62

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

;
	.byte	$4B		; and #n-lsr A
	.byte	$1F		; same as and #$1f, lsr			; 2
;	asr	#%11111
; 49
	tay			; A proper value, masked with $1F	; 2
; 51
	sta	AUDV0       	; 5-bit PCM				; 3
	adc	#0		; ??? rounded?				; 2
	sta	AUDV1							; 3
; 59

	lda	VSYNC_VALUE						; 3
	lsr								; 2
	sta	VSYNC_VALUE						; 3
	sta	WSYNC							; 3
; 70
	sta	VSYNC							; 3

; 3

	tya			; restore original			; 2
	ora	#$50							; 2
	sta	COLUBK		; set color				; 3
; 10
;	lda	PF1Tab,Y	; set pattern				; 4+
;	sta	PF1							; 3
;	lda	PF2Tab,Y						; 4+
;	sta	PF2							; 3
; 24

	inc	COUNTER1	; t++					; 5
; 29
	dex								; 2
	bne	output_loop						; 2/3
; 33
	;==============================
	; here only every 1/64 of time

	inc	COUNTER2	; c2++ (t >> 6)				; 5
	lda	COUNTER2						; 3
	and	#$7F		; mask off high bit			; 2
	bne	Counter4_OK	; branch most of time			; 2/3
; 45

	inc	COUNTER4	; only inc 1/128 of time (t>>13)	; 5

; 50 / 46
Counter4_OK:
	and	#$01		; check bottom bit			; 2
	bne	Counter3_OK						; 2/3

; 54 / 50
	inc	COUNTER3	; only inc 1/2 of time (t>>7)		; 5

; 59 / 55 / 51
Counter3_OK:
	jmp	sample_loop						; 3
; 62

PF1Tab:
PF2Tab:


demo_end:

	.res 128-(demo_end-demo_start)-4,$EA     ; nops


	.word demo_start	; RESET vector
	nop
	nop

