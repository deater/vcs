; LOCATION STEPS_E data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $28,$28			; background color, background color2
.byte 70			; overlay (sprite1) X location
.byte LOCATION_DOCK_S		; center destination
.byte LOCATION_STEPS_S		; left destination
.byte LOCATION_STEPS_S		; right destination
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "steps_e_data.inc"
