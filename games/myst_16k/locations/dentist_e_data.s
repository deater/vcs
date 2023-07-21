; LOCATION DENTIST_E data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $02,$02			; background color, background color2
.byte 100			; overlay (sprite1) coarse/fine
.byte LOCATION_STEPS_E		; center destination
.byte LOCATION_DENTIST_N	; left destination
.byte $FF			; right destination
.byte 0,0			; XMAX/XMIN of grab area
.byte 0,0			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "dentist_e_data.inc"
