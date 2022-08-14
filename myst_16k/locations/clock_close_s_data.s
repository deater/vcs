; LOCATION_CLOCK_CLOSE_S data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $2,$2			; background color, background color2
.byte 1,$60			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte 10,32			; XMAX/XMIN of grab area
.byte 24,32			; YMAX/YMIN of grab area
.byte LOCATION_CLOCK_N		; left destination
.byte $FF			; center destination
.byte LOCATION_CLOCK_N		; right destination
.byte $00,$00			; unused

.include "clock_close_s_data.inc"
