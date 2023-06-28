; LOCATION_HILLTOP_E data

.include "../locations.inc"

.byte $04			; color of pointer (sprite0)
.byte $E0,$E0			; background color, background color2
.byte 2,$D0			; overlay (sprite1) coarse/fine
.byte 2,$00			; coarse/fine of missile0 (vertical line)
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte LOCATION_DENTIST_E	; center destination
.byte LOCATION_HILLTOP_N	; left destination
.byte LOCATION_HILLTOP_S	; right destination
.byte $00,$00			; unused

.include "hilltop_e_data.inc"
