; LOCATION_ROCKET_CLOSE_N data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte 2,0			; background color, background color2
.byte 87			; overlay (sprite1) X location
.byte $FF			; center destination
.byte LOCATION_ROCKET_S		; left destination
.byte LOCATION_ROCKET_S		; right destination
.byte 86,110			; XMAX/XMIN of grab area
.byte 24,32			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "rocket_close_n_data.inc"
