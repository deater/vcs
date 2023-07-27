; LOCATION_ELEVATOR_N

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $0,$0			; background color, background color2
.byte 59			; overlay (sprite1) X location
.byte LOCATION_HINT		; center destination
.byte LOCATION_ELEVATOR_S	; left destination
.byte LOCATION_ELEVATOR_S	; right destination
.byte $0,$00			; XMAX/XMIN of grab area
.byte $0,$00			; YMAX/YMIN of grab area
.byte $00			; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "elevator_n_data.inc"
