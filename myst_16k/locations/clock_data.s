
; LOCATION_CLOCK data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $E0,$E0			; background color, background color2
.byte 5,$F0			; overlay (sprite1) coarse/fine
.byte 4,$00			; coarse/fine of missile0 (vertical line)
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte $00			; left destination
.byte LOCATION_HILLTOP_S	; center destination
.byte $00			; right destination
.byte $00,$00			; unused

.include "clock_data.inc"
