; All of the intro code

.include "../../vcs.inc"
.include "../zp.inc"
.include "../common_routines.inc"

do_intro:

.include "title.s"

.include "cleft.s"

	rts

.include "book.s"

;.include "../hand_copy.s"
;.include "../hand_motion.s"
;.include "../adjust_sprite.s"


.align $100

.include "intro_data.inc"
.include "book_data.inc"
