; LOCATION BLUE_BOOK_CLOSE data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 68			; overlay (sprite1) coarse/fine
.byte LOCATION_LIBRARY_E	; center destination
.byte $FF			; left destination
.byte $FF			; right destination
.byte 64,100			; XMAX/XMIN of grab area
.byte 16,32			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "blue_book_close_data.inc"
