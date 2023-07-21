; LOCATION LIBRARY_UP data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $FE,$FE			; background color, background color2
.byte 63			; overlay (sprite1) X location
.byte LOCATION_LIBRARY_N	; center destination
.byte $FF			; left destination
.byte $FF			; right destination
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "library_up_data.inc"
