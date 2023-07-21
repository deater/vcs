; LOCATION_ARRIVAL_N data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $F0,$F0			; background color, background color2
.byte 63			; overlay (sprite1) X location
.byte LOCATION_DOCK_N		; center destination
.byte LOCATION_ARRIVAL_W	; left destination
.byte LOCATION_ARRIVAL_E	; right destination
.byte 0,0			; XMAX/XMIN of grab area
.byte 0,0			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "arrival_n_data.inc"
