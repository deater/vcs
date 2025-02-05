; short 32 byte demo, with sound! (rev b)
; by Omegamatrix

; last update Sept 11, 2018

.include "../../../vcs.inc"

;    ORG $F800
 ;   .byte $FF

.ORG $FFE0

Start:

;SP=$FD at startup
loopClear:
	asl
	pha
	tsx
	bne	loopClear

;RIOT ram $80-$F6 clear, TIA clear except VSYNC, SP=$00, X=0, A=0, carry is clear

doVSYNC:
	lda	#$0E << 2	; does two lines (non-Vsync), and then the regular 3 lines of VSYNC
loopVSYNC:
	sta	WSYNC
	sta	VSYNC
	sty	AUDC0+5,X	; write to each audio register
	dex
	lsr
	bne	loopVSYNC

	tax			; X=0
	dey			; scroll color and shape

loopKernel:
	sta	WSYNC
	dey
	sty	COLUBK
	dex
	bne	loopKernel
.byte $0C  ; NOP, skip 2 bytes

.ORG $FFFC
	.word Start
	beq	doVSYNC		; always branch
