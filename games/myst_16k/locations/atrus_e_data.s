; LOCATION ATRUS_E data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 66			; overlay (sprite1) X location
.byte LOCATION_DNI_E		; center destination
.byte $FF			; left destination
.byte $FF			; right destination
.byte 34*2,48*2			; XMAX/XMIN of grab area
.byte 16,30			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "atrus_e_data.inc"
