; LOCATION INSIDE_ELEVATOR data

.include "../locations.inc"

.byte $04			; color of pointer (sprite0)
.byte 226,226			; background color, background color2
.byte 119			; overlay (sprite1) X location
.byte LOCATION_ELEVATOR_S	; center destination
.byte $FF			; left destination
.byte $FF			; right destination
.byte 108,132			; XMAX/XMIN of grab area
.byte 33,41			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00
.byte $00			; unused
.byte $00
.byte $00			; unused

.include "inside_elevator_data.inc"
