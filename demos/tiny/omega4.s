; 32 byte demo, Animatrix 2
; by Omegamatrix

; last update Oct 08, 2018

.include "../../vcs.inc"

;    .byte $FF

.ORG $FFE0

Start:

;SP=$FD at startup

loopClear:
	asl
	tsx
	pha
	bne	loopClear

;RIOT ram $80-$F6 clear, TIA clear, SP=$FF, A=0, X=0, carry is clear

doVSYNC:
	lda	#$38         ; does two lines (non-Vsync), and then the regular 3 lines of VSYNC
	sta	GRP0
loopVSYNC:
	sta	WSYNC
	sta	VSYNC
	lsr
	bne	loopVSYNC

	dey
	sty	HMP0

loopKernel:
	sta	WSYNC
	sta	HMOVE
	sty	COLUP0
	dex
	bne	loopKernel
                          ; X=0
.ORG $FFFC             ; CPX #$FF
    .word Start
    bne   doVSYNC        ; always branch

