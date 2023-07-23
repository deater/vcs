; LOCATION LIBRARY_S data

.include "../locations.inc"
.include "../zp.inc"

.byte $22			; color of pointer (sprite0)
.byte $00,$00			; background color, background color2
.byte 63			; overlay (sprite1) X location
.byte LOCATION_HILLTOP_S	; center destination
.byte LOCATION_LIBRARY_SE	; left destination
.byte LOCATION_LIBRARY_SW	; right destination
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte BARRIER_LIBRARY_DOOR_CLOSED	; condition
.byte $FF			; new dest
.byte $00,$00			; unused

.include "library_s_data.inc"
