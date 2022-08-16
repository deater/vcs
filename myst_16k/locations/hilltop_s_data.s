; LOCATION_HILLTOP_S data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $E0,$E0			; background color, background color2
.byte 4,$70			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte LOCATION_HILLTOP_E	; left destination
.byte LOCATION_SHACK_W		; center destination
.byte LOCATION_HILLTOP_W	; right destination
.byte $00,$00			; unused

.include "hilltop_s_data.inc"
