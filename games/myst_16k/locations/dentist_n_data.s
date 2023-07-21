; LOCATION DENTIST_N data

.include "../locations.inc"

.byte $04			; color of pointer (sprite0)
.byte $02,$02			; background color, background color2
.byte 15			; overlay (sprite1) X location
.byte $FF			; center destination
.byte LOCATION_HILLTOP_W	; left destination
.byte LOCATION_HILLTOP_W	; right destination
.byte 10,32			; XMAX/XMIN of grab area
.byte 24,32			; YMAX/YMIN of grab area
.byte 129			; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "dentist_n_data.inc"
