; LOCATION SHACK_S data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $D0,$D0			; background color, background color2
.byte 6,$10			; overlay (sprite1) coarse/fine
.byte 2,$E0			; coarse/fine of missile0 (vertical line)
.byte 0,0			; XMAX/XMIN of grab area
.byte 0,0			; YMAX/YMIN of grab area
.byte $FF			; left destination
.byte LOCATION_CABIN_PATH_S	; center destination
.byte LOCATION_SHACK_W		; right destination
.byte $00,$00			; unused

.include "shack_s_data.inc"
