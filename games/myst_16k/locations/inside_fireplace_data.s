; LOCATION INSIDE_FIREPLACE data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 4,$30			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte 0,159 ;4*2,68*2			; XMAX/XMIN of grab area
.byte 23,46			; YMAX/YMIN of grab area
;.byte LOCATION_LIBRARY_NW	; center destination
.byte $FF
.byte $FF			; left destination
.byte $FF			; right destination
.byte $00,$00			; unused

.include "inside_fireplace_data.inc"
