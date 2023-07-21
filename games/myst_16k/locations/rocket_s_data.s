; LOCATION_ROCKET_S data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $02,$02			; background color, background color2
.byte 105			; overlay (sprite1) coarse/fine
.byte LOCATION_HILLTOP_E	; center destination
.byte LOCATION_ROCKET_N		; left destination
.byte LOCATION_ROCKET_N		; right destination
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "rocket_s_data.inc"
