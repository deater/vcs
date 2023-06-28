; LOCATION POOL_S data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $0E,$0E			; background color, background color2
.byte 4,$00			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte 0,0			; XMAX/XMIN of grab area
.byte 0,0			; YMAX/YMIN of grab area
.byte LOCATION_SHACK_S		; center destination
.byte LOCATION_POOL_N		; left destination
.byte LOCATION_POOL_N		; right destination
.byte $00,$00			; unused

.include "pool_s_data.inc"
