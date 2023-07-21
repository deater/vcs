; LOCATION_ARRIVAL_E data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 15			; overlay (sprite1) coarse/fine
.byte $FF			; center destination
.byte LOCATION_ARRIVAL_N	; left destination
.byte LOCATION_ARRIVAL_S	; right destination
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "arrival_e_data.inc"
