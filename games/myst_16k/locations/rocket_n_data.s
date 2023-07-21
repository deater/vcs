; LOCATION_ROCKET_N data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $F4,$00			; background color, background color2
.byte 63			; overlay (sprite1) X location
.byte LOCATION_ROCKET_CLOSE_N	; center destination
.byte LOCATION_ROCKET_S		; left destination
.byte LOCATION_ROCKET_S		; right destination
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte 0			;	; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "rocket_n_data.inc"
