; LOCATION_CLOCK_S data

.include "../locations.inc"
.include "../zp.inc"

.byte $22			; color of pointer (sprite0)
.byte $E0,$E0			; background color, background color2
.byte 82			; overlay (sprite1) coarse/fine
.byte $FF			; center destination
.byte LOCATION_CLOCK_N		; left destination
.byte LOCATION_CLOCK_N		; right destination
.byte 32,72			; XMAX/XMIN of grab area
.byte 32,42			; YMAX/YMIN of grab area
.byte 45			; missile0 (vertical line) X location
.byte BARRIER_CLOCK_BRIDGE_UP	; center dest patch condition
.byte LOCATION_CLOCK_CLOSE_S	; center dest patch location
.byte OVERLAY_PATCH_BARRIER|1	; overlay patch type
.byte $00			; unused

.include "clock_s_data.inc"
