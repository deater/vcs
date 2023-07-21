; LOCATION_CLOCK_PUZZLE

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $2,$2			; background color, background color2
.byte 60			; overlay (sprite1) coarse/fine
.byte LOCATION_CLOCK_S		; center destination
.byte $FF			; left destination
.byte $FF			; right destination
.byte $22,$6C			; XMAX/XMIN of grab area
.byte 32,48			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "clock_puzzle_data.inc"
