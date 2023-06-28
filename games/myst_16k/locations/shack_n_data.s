; LOCATION SHACK_N data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $02,$02			; background color, background color2
.byte 4,$F0			; overlay (sprite1) coarse/fine
.byte 0,0			; coarse/fine of missile0 (vertical line)
.byte 0,0			; XMAX/XMIN of grab area
.byte 0,0			; YMAX/YMIN of grab area
.byte LOCATION_POOL_N		; center destination
.byte LOCATION_SHACK_W		; left destination
.byte $FF			; right destination
.byte $00,$00			; unused

.include "shack_n_data.inc"
