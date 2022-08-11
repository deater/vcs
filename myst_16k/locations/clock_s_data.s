
; LOCATION_CLOCK_S data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $E0,$E0			; background color, background color2
.byte 5,$F0			; overlay (sprite1) coarse/fine
.byte 4,$00			; coarse/fine of missile0 (vertical line)
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte LOCATION_CLOCK_N		; left destination
.byte $FF			; center destination
.byte LOCATION_CLOCK_N		; right destination
.byte $00,$00			; unused

.include "clock_s_data.inc"
