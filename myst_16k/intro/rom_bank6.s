; All of the intro code

.include "../../vcs.inc"
.include "../zp.inc"
.include "../common_routines.inc"

do_intro:

.include "title.s"

.include "cleft.s"

	jsr	do_book

	rts


do_book:
.include "book.s"
	rts

;.include "../hand_copy.s"
;.include "../hand_motion.s"
;.include "../adjust_sprite.s"


.align $100

.include "intro_data.inc"
;.include "../sprite_data.inc"
