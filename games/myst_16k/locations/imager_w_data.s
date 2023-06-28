; LOCATION_IMAGER_W data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 4,$30			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte $FF			; center destination
.byte LOCATION_IMAGER_E		; left destination
.byte LOCATION_IMAGER_E		; right destination
.byte $00,$00			; unused

.include "imager_w_data.inc"
