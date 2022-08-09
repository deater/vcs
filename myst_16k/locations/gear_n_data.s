; LOCATION GEAR_N data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $02,$02			; background color, background color2
.byte 1,$60			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte LOCATION_HILLTOP_S	; left destination
.byte $FF			; center destination
.byte LOCATION_HILLTOP_S	; right destination
.byte $00,$00			; unused

.include "gear_n_data.inc"
