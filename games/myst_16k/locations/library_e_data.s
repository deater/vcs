; LOCATION LIBRARY_E data

.include "../locations.inc"
.include "../zp.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 63			; overlay (sprite1) X location
.byte LOCATION_BLUE_BOOK_CLOSE	; center destination
.byte LOCATION_LIBRARY_NE	; left destination
.byte LOCATION_LIBRARY_SE	; right destination
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00                       ; patch cond
.byte $00                       ; patch dest
.byte OVERLAY_PATCH_LIBRARY_PAGE; overlay patch type
.byte $00                       ; unused


.include "library_e_data.inc"
