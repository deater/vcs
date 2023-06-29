; LOCATION LIBRARY_UP data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $FE,$FE			; background color, background color2
.byte 4,$30			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte LOCATION_LIBRARY_N	; center destination
.byte $FF			; left destination
.byte $FF			; right destination
.byte $00,$00			; unused

.include "library_up_data.inc"
