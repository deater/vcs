; LOCATION GEAR_N data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $02,$02			; background color, background color2
.byte 9				; overlay (sprite1) X location
.byte $FF			; center destination
.byte LOCATION_GEAR_S		; left destination
.byte LOCATION_GEAR_S		; right destination
.byte 10,32			; XMAX/XMIN of grab area
.byte 24,32			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "gear_n_data.inc"
