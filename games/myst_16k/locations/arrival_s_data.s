; LOCATION_ARRIVAL_S data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $02,$02			; background color, background color2
.byte 45			; overlay (sprite1) X location
.byte $FF			; center destination
.byte LOCATION_ARRIVAL_E	; left destination
.byte LOCATION_ARRIVAL_W	; right destination
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "arrival_s_data.inc"
