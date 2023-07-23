; LOCATION INSIDE_FIREPLACE data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 63			; overlay (sprite1) X location
.byte $FF			; center destination
.byte $FF			; left destination
.byte $FF			; right destination
.byte 0,159 ;4*2,68*2		; XMAX/XMIN of grab area
.byte 23,46			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "inside_fireplace_data.inc"
