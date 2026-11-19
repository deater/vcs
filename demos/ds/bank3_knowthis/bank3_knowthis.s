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
.include "knowthis2.s"

	rts

.include "knowthis_pf.inc"
.include "ikt_face.inc"
.include "ikt_message.inc"

bg_range:
;       .byte 0,0,112,0,0,224,0,0
        .byte 0,0,0,0,0,0,0,0
