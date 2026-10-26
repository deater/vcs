; title screen

.include "../../../vcs.inc"

; zero page addresses

.include "../zp.inc"

.include "../common_routines.inc"


	;=======================
        ; title screen
        ;=======================
do_title:


.include "dSr_logo.s"

	rts

