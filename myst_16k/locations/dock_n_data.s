; LOCATION DOCK_N data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 6,$10			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte $FF			; left destination
.byte LOCATION_SHORTSTEPS_W	; center destination
.byte $FF			; right destination
.byte $00,$00			; unused

.include "dock_n_data.inc"
