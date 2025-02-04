; short 32 byte demo, rev b
; by Omegamatrix

; last update Sept 11, 2018

.include "../../vcs.inc"

;.org $F800
;    .byte $FF

.org $FFE0

Start:

;SP=$FD at startup
loopClear:
	asl
	pha
	tsx
	bne	loopClear

;RIOT ram $80-$F6 clear, TIA clear except VSYNC, SP=$00

doVSYNC:
	lda	#$0E << 2	; does two lines (non-Vsync), and then the regular 3 lines of VSYNC
loopVSYNC:
	sta	WSYNC
	sta	VSYNC
	sta	CTRLPF		; reflect for symmetrical PF2
	lsr
	bne	loopVSYNC

	dex			; scroll color and shape

loopKernel:
	sta	WSYNC
	dex
	stx	PF2
	stx	COLUPF
	dey
	bne	loopKernel
.byte $0C  ; NOP, skip 2 bytes

.ORG $FFFC
	.word Start
	beq	doVSYNC        ; always branch

