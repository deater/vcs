; All of the intro code

.include "../../vcs.inc"
.include "../zp.inc"


do_intro:

.include "title.s"

.include "cleft.s"

.include "book.s"

	rts


.include "../common_routines.s"
.include "../hand_copy.s"
.include "../hand_motion.s"
.include "../adjust_sprite.s"


.align $100

.include "intro_data.inc"
.include "../sprite_data.inc"
