; LOCATION_ROCKET_CLOSE_N data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte 2,0			; background color, background color2
.byte 5,$A0			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte 86,110			; XMAX/XMIN of grab area
.byte 24,32			; YMAX/YMIN of grab area
.byte LOCATION_ROCKET_S		; left destination
.byte $FF			; center destination
.byte LOCATION_ROCKET_S		; right destination
.byte $00,$00			; unused

.include "rocket_close_n_data.inc"
