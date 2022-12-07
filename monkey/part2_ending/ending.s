.include "../zp.inc"
.include "../../vcs.inc"

	;==========================
	; Ending
	;==========================
	; potentially arrive here with an unknown number of cycles/scanlines
	; ideally VBLANK=2 (beam off)

do_ending:

;.include "level_engine.s"

.include "trials.s"

.include "cart.s"

	rts

        ;=======================
        ; more init

.include "../common_addresses.inc"

.align $100
.include "trials.inc"
.include "lookout.inc"
.include "lookout_over.inc"

