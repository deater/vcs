; LOCATION_ARRIVAL_N data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $F0,$F0			; background color, background color2
.byte 4,$30			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte $FF			; left destination
.byte LOCATION_HILLTOP_W	; center destination
.byte LOCATION_ARRIVAL_E	; right destination
.byte $00,$00			; unused

.include "arrival_n_data.inc"
