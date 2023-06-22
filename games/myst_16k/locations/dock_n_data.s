; LOCATION DOCK_N data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 6,$10			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte 90,114			; XMAX/XMIN of grab area
.byte 24,32			; YMAX/YMIN of grab area
.byte LOCATION_DOCK_S		; left destination
.byte LOCATION_SHORTSTEPS_W	; center destination
.byte LOCATION_DOCK_S		; right destination
.byte $00,$00			; unused

.include "dock_n_data.inc"
