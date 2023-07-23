; LOCATION DNI_E data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 47			; overlay (sprite1) X location
.byte LOCATION_ATRUS_E		; center destination
.byte LOCATION_DNI_N		; left destination
.byte $FF			; right destination
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "dni_e_data.inc"
