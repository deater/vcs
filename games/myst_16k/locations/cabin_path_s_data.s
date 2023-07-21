; LOCATION CABIN_PATH_S data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 59			; overlay (sprite1) X location
.byte LOCATION_CLOCK_S		; center destination
.byte LOCATION_CABIN_E		; left destination
.byte $FF			; right destination
.byte 0,0			; XMAX/XMIN of grab area
.byte 0,0			; YMAX/YMIN of grab area
.byte 5				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "cabin_path_s_data.inc"
