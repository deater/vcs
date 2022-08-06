; LOCATION_ROCKET data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $F4,$F4			; background color, background color2
.byte 4,$30			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte $00			; left destination
.byte LOCATION_HILLTOP_E	; center destination
.byte $00			; right destination
.byte $00,$00			; unused

.include "rocket_data.inc"
