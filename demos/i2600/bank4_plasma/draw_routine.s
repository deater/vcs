.include "../zp.inc"
.include "../../../vcs.inc"


;================================================================

; comes in 6 cycles in
line1:
; 6
	nop		; 2
	nop		; 2
	lda	$80	; 3
	lda	$80	; 3
	lda	$80	; 3


; 19

	; want to wait until 22.66 cpu clocks?
							; cpu pixel pf 
	lda	#$0e					; 2
	sta	COLUPF					; 3	15  3.75
	lda	#$1e					; 2
	sta	COLUPF					; 3	30  7.5
	lda	#$2e					; 2
	sta	COLUPF					; 3	45  
	lda	#$3e					; 2
	sta	COLUPF					; 3	60
	lda	#$4e					; 2
	sta	COLUPF					; 3	75
	lda	#$5e					; 2
	sta	COLUPF					; 3	90
	lda	#$6e
	sta	COLUPF
	lda	#$7e
	sta	COLUPF
	lda	#$8e
	sta	COLUPF
	lda	#$9e
	sta	a:COLUPF

; 70
	rts
; 6


; comes in 6 cycles in
line2:
; 6
	lda	$80	; 3
	lda	$80	; 3
	lda	$80	; 3
	nop		; 2
	nop		; 2


; 19

	; want to wait until 22.66 cpu clocks?
							; cpu pixel pf 
	lda	#$1e					; 2
	sta	COLUPF					; 3	15  3.75
	lda	#$2e					; 2
	sta	COLUPF					; 3	30  7.5
	lda	#$3e					; 2
	sta	COLUPF					; 3	45  
	lda	#$4e					; 2
	sta	COLUPF					; 3	60
	lda	#$5e					; 2
	sta	COLUPF					; 3	75
	lda	#$6e					; 2
	sta	COLUPF					; 3	90
	lda	#$7e
	sta	COLUPF
	lda	#$8e
	sta	COLUPF
	lda	#$9e
	sta	COLUPF
	lda	#$ae
	sta	a:COLUPF

; 70
	rts
; 6


; comes in 6 cycles in
line3:
; 6
	lda	$80	; 3
	lda	$80	; 3
	lda	$80	; 3
	nop		; 2
	nop		; 2


; 19

	; want to wait until 22.66 cpu clocks?
							; cpu pixel pf 
	lda	#$2e					; 2
	sta	COLUPF					; 3	15  3.75
	lda	#$3e					; 2
	sta	COLUPF					; 3	30  7.5
	lda	#$4e					; 2
	sta	COLUPF					; 3	45  
	lda	#$5e					; 2
	sta	COLUPF					; 3	60
	lda	#$6e					; 2
	sta	COLUPF					; 3	75
	lda	#$7e					; 2
	sta	COLUPF					; 3	90
	lda	#$8e
	sta	COLUPF
	lda	#$9e
	sta	COLUPF
	lda	#$ae
	sta	COLUPF
	lda	#$be
	sta	a:COLUPF

; 70
	rts
; 6

; comes in 6 cycles in
line4:
; 6
	lda	$80	; 3
	lda	$80	; 3
	lda	$80	; 3
	nop		; 2
	nop		; 2


; 19

	; want to wait until 22.66 cpu clocks?
							; cpu pixel pf 
	lda	#$3e					; 2
	sta	COLUPF					; 3	15  3.75
	lda	#$4e					; 2
	sta	COLUPF					; 3	30  7.5
	lda	#$5e					; 2
	sta	COLUPF					; 3	45  
	lda	#$6e					; 2
	sta	COLUPF					; 3	60
	lda	#$7e					; 2
	sta	COLUPF					; 3	75
	lda	#$8e					; 2
	sta	COLUPF					; 3	90
	lda	#$9e
	sta	COLUPF
	lda	#$ae
	sta	COLUPF
	lda	#$be
	sta	COLUPF
	lda	#$ce
	sta	a:COLUPF

; 70
	rts
; 6

; comes in 6 cycles in
line5:
; 6
	lda	$80	; 3
	lda	$80	; 3
	lda	$80	; 3
	nop		; 2
	nop		; 2


; 19

	; want to wait until 22.66 cpu clocks?
							; cpu pixel pf 
	lda	#$4e					; 2
	sta	COLUPF					; 3	15  3.75
	lda	#$5e					; 2
	sta	COLUPF					; 3	30  7.5
	lda	#$6e					; 2
	sta	COLUPF					; 3	45  
	lda	#$7e					; 2
	sta	COLUPF					; 3	60
	lda	#$8e					; 2
	sta	COLUPF					; 3	75
	lda	#$9e					; 2
	sta	COLUPF					; 3	90
	lda	#$ae
	sta	COLUPF
	lda	#$be
	sta	COLUPF
	lda	#$ce
	sta	COLUPF
	lda	#$de
	sta	a:COLUPF

; 70
	rts
; 6
