; LOCATION DENTIST_N data

.include "../locations.inc"

.byte $04			; color of pointer (sprite0)
.byte $02,$02			; background color, background color2
.byte 1,$60			; overlay (sprite1) coarse/fine
.byte 10,$00			; coarse/fine of missile0 (vertical line)
.byte 10,32			; XMAX/XMIN of grab area
.byte 24,32			; YMAX/YMIN of grab area
.byte $FF			; center destination
.byte LOCATION_HILLTOP_W	; left destination
.byte LOCATION_HILLTOP_W	; right destination
.byte $00,$00			; unused

.include "dentist_n_data.inc"
