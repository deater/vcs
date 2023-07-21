; LOCATION_HINT

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $0,$0			; background color, background color2
.byte 0				; overlay (sprite1) X location
.byte LOCATION_ELEVATOR_S	; center destination
.byte $FF			; left destination
.byte $FF			; right destination
.byte $0,$0			; XMAX/XMIN of grab area
.byte $0,$0			; YMAX/YMIN of grab area
.byte $00			; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "hint_data.inc"
