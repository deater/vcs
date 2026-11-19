; knowthis screen

.include "../../../vcs.inc"

; zero page addresses

.include "../zp.inc"

.include "../common_routines.inc"
.include "../timing.inc"


	;=======================
        ; knowthis screen
        ;=======================
do_knowthis:

.include "frame1_init.s"


.include "knowthis.s"

	rts

