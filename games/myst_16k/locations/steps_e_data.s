; LOCATION STEPS_E data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $28,$28			; background color, background color2
.byte 5,$60			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte LOCATION_STEPS_S		; left destination
.byte LOCATION_DOCK_S		; center destination
.byte LOCATION_STEPS_S		; right destination
.byte $00,$00			; unused

.include "steps_e_data.inc"
