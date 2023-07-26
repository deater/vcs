; LOCATION BLUE_BOOK_CLOSE data

.include "../locations.inc"
.include "../zp.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 75			; overlay (sprite1) coarse/fine
.byte LOCATION_LIBRARY_E	; center destination
.byte $FF			; left destination
.byte $FF			; right destination
.byte 64,100			; XMAX/XMIN of grab area
.byte 16,32			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00                       ; patch cond
.byte $00                       ; patch dest
.byte OVERLAY_PATCH_LIBRARY_PAGE|1; overlay patch type
.byte $00                       ; unused


.include "blue_book_close_data.inc"
