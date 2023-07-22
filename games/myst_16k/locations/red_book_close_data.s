; LOCATION RED_BOOK_CLOSE data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 75			; overlay (sprite1) coarse/fine
.byte LOCATION_LIBRARY_W	; center destination
.byte $FF			; left destination
.byte $FF			; right destination
.byte 64,100			; XMAX/XMIN of grab area
.byte 16,32			; YMAX/YMIN of grab area
.byte 0				; coarse/fine of missile0 (vertical line)
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "red_book_close_data.inc"
