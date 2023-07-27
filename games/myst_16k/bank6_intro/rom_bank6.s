; All of the intro code

.include "../../../vcs.inc"
.include "../zp.inc"
.include "../common_routines.inc"

do_intro:

.include "title.s"

.include "cleft.s"

	rts

.include "book.s"

;.align $100

.include "intro_data.inc"
.include "../sfx_data.inc"
.include "../sound_update.s"
;.include "fireplace_update.s"

.include "../pointer_update.s"

.include "../handle_grab.s"

rom_bank6_end:
