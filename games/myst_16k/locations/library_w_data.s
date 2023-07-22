; LOCATION LIBRARY_W data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 63			; overlay (sprite1) coarse/fine
.byte LOCATION_RED_BOOK_CLOSE	; center destination
.byte LOCATION_LIBRARY_SW	; left destination
.byte LOCATION_LIBRARY_NW	; right destination
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "library_w_data.inc"
