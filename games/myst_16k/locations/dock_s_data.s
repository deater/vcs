; LOCATION DOCK_S data

.include "../locations.inc"

.byte $22			; color of pointer (sprite0)
.byte $02,$02			; background color, background color2
.byte 0,$01			; overlay (sprite1) coarse/fine
.byte 0,$00			; coarse/fine of missile0 (vertical line)
.byte 0,0			; XMAX/XMIN of grab area
.byte 0,0			; YMAX/YMIN of grab area
.byte LOCATION_DOCK_N		; left destination
.byte LOCATION_ARRIVAL_S	; center destination
.byte LOCATION_DOCK_N		; right destination
.byte $00,$00			; unused

.include "dock_s_data.inc"
