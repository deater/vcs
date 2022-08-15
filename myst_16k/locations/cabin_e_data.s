; LOCATION_CABIN_E data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $0,$E2			; background color, background color2
.byte 6,$50			; overlay (sprite1) coarse/fine
.byte 10,$80			; coarse/fine of missile0 (vertical line)
.byte 90,114			; XMAX/XMIN of grab area
.byte 24,32			; YMAX/YMIN of grab area
.byte LOCATION_CLOCK_N		; left destination
.byte LOCATION_CLOCK_S		; center destination
.byte LOCATION_CLOCK_N		; right destination
.byte $00,$00			; unused

.include "cabin_e_data.inc"
