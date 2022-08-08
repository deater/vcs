; LOCATION SHORTSTEPS_W data

.include "../locations.inc"

.byte $30			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 8,$F0			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte LOCATION_HILLTOP_W	; left destination
.byte LOCATION_HILLTOP_W	; center destination
.byte $FF			; right destination
.byte $00,$00			; unused

.include "shortsteps_w_data.inc"
