; LOCATION INSIDE_DENTIST data

.include "../locations.inc"

.byte $04			; color of pointer (sprite0)
.byte $0a,$0a			; background color, background color2
.byte 72			; overlay (sprite1) X location
.byte LOCATION_DENTIST_N	; center destination
.byte $FF			; left destination
.byte $FF			; right destination
.byte 0,0			; XMAX/XMIN of grab area
.byte 0,0			; YMAX/YMIN of grab area
.byte 0				; missile0 (vertical line) X location
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "inside_dentist_data.inc"
