; short 32 byte demo (New Gold Dream)
; by Omegamatrix

; last update Sept 11, 2018

.include "../../vcs.inc"

;    ORG $F800
;    .byte $FF
;

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
	lda	#$0E << 2       ; does two lines (non-Vsync), and then the regular 3 lines of VSYNC
loopVSYNC:
	sta	WSYNC
	sta	VSYNC
	lsr
	bne	loopVSYNC

loopKernel:
	sty	HMP0
	sta	WSYNC
	sta	HMOVE
	sty	GRP0
	sty	COLUP0
	dey
	bne	loopKernel
.byte $0C  ; NOP, skip 2 bytes

.ORG $FFFC
    .word Start
    beq    doVSYNC        ; always branch

