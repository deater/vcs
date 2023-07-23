; LOCATION_CLOCK_CLOSE_S data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $2,$2			; background color, background color2
.byte 15			; overlay (sprite1) X location
.byte $FF			; center destination
.byte LOCATION_CLOCK_N		; left destination
.byte LOCATION_CLOCK_N		; right destination
.byte 10,32			; XMAX/XMIN of grab area
.byte 24,32			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "clock_close_s_data.inc"
