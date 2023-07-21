; LOCATION_HILLTOP_E data

.include "../locations.inc"

.byte $04			; color of pointer (sprite0)
.byte $E0,$E0			; background color, background color2
.byte 32			; overlay (sprite1) X location
.byte LOCATION_DENTIST_E	; center destination
.byte LOCATION_HILLTOP_N	; left destination
.byte LOCATION_HILLTOP_S	; right destination
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte 225			; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "hilltop_e_data.inc"
