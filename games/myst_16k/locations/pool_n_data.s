; LOCATION POOL_N data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $02,$02			; background color, background color2
.byte 107			; overlay (sprite1) X location
.byte LOCATION_HILLTOP_N	; center destination
.byte LOCATION_POOL_S		; left destination
.byte LOCATION_POOL_S		; right destination
.byte 100,124			; XMAX/XMIN of grab area
.byte 24,32			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "pool_n_data.inc"
