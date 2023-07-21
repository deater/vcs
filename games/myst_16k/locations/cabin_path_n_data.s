; LOCATION CABIN_PATH_N data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $e2,$e2			; background color, background color2
.byte 103			; overlay (sprite1) X location
.byte LOCATION_SHACK_N		; center destination
.byte $FF			; left destination
.byte LOCATION_CABIN_E		; right destination
.byte 0,0			; XMAX/XMIN of grab area
.byte 0,0			; YMAX/YMIN of grab area
.byte 13			; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "cabin_path_n_data.inc"
