; LOCATION_HILL_W data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $02,$02			; background color, background color2
.byte 63			; overlay (sprite1) X position
.byte LOCATION_HILLTOP_W	; center destination
.byte LOCATION_DENTIST_E	; left destination
.byte LOCATION_DENTIST_N	; right destination
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X position
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "hill_w_data.inc"
