; LOCATION SHACK_W data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $E0,$E0			; background color, background color2
.byte 1,$E0			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte 14,36			; XMAX/XMIN of grab area
.byte 24,32			; YMAX/YMIN of grab area
.byte LOCATION_SHACK_S		; left destination
.byte $FF			; center destination
.byte $FF			; right destination
.byte $00,$00			; unused

.include "shack_w_data.inc"
