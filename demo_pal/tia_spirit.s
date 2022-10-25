; testing tia music player

.include "../vcs.inc"

; zero page addresses

.include "zp.inc"



tia:
	cld		; clear decimal mode

	ldx	#0
	txa
clear_loop:
	sta	$0,X
	inx
	bne	clear_loop
	dex
	txs	; point stack to $1FF (mirrored at top of zero page)



	;=====================
	; other includes

.include "tia_kernel.s"


	;=====================
	; other includes


.include "common_routines.s"


.include "tia_spirit_trackdata.s"

.segment "IRQ_VECTORS"
	.word tia	; NMI
	.word tia	; RESET
	.word tia	; IRQ


