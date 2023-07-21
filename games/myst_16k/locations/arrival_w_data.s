; LOCATION_ARRIVAL_W data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $02,$02			; background color, background color2
.byte 57			; overlay (sprite1) coarse/fine
.byte LOCATION_IMAGER_W		; center destination
.byte LOCATION_ARRIVAL_S	; left destination
.byte LOCATION_ARRIVAL_N	; right destination
.byte $00,$00			; XMAX/XMIN of grab area
.byte $00,$00			; YMAX/YMIN of grab area
.byte 0				; coarse/fine of missile0 (vertical line)
.byte $00,$00			; unused
.byte $00,$00			; unused

.include "arrival_w_data.inc"
