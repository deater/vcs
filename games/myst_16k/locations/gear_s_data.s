; LOCATION GEAR_S data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $02,$02			; background color, background color2
.byte 97			; overlay (sprite1) X location
.byte LOCATION_STEPS_S		; center destination
.byte LOCATION_GEAR_N		; left destination
.byte LOCATION_GEAR_N		; right destination
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "gear_s_data.inc"
