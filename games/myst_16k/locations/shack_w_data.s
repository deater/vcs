; LOCATION SHACK_W data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $E0,$E0			; background color, background color2
.byte 23			; overlay (sprite1) X location
.byte $FF			; center destination
.byte LOCATION_SHACK_S		; left destination
.byte LOCATION_SHACK_N		; right destination
.byte 14,36			; XMAX/XMIN of grab area
.byte 24,32			; YMAX/YMIN of grab area
.byte 0				; coarse/fine of missile0 (vertical line)
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "shack_w_data.inc"
