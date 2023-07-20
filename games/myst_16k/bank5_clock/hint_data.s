; LOCATION_HINT

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $0,$0			; background color, background color2
.byte 0,$00			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte $0,$0			; XMAX/XMIN of grab area
.byte $0,$0			; YMAX/YMIN of grab area
.byte LOCATION_ELEVATOR_S	; center destination
.byte $FF			; left destination
.byte $FF			; right destination
.byte $00,$00			; unused

.include "hint_data.inc"
