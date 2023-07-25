; LOCATION LIBRARY_SW data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 63			; overlay (sprite1) X location
.byte $FF			; center destination
.byte LOCATION_LIBRARY_S	; left destination
.byte LOCATION_LIBRARY_W	; right destination
.byte 56,96			; XMAX/XMIN of grab area
.byte 17,29			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "library_sw_data.inc"

