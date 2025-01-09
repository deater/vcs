; based on code from
; https://www.randomterrain.com/atari-2600-memories-tutorial-andrew-davie-22b.html
;
; which is based on code from river-raid


;=================================================
; calculates the values and positions objects:
; INPUT:
;   A = x-position
;   X = object to position (0=P0, 1=P1, 2=M0, 3=M1, 4=BL)

set_pos_x:
; 0
;	jsr	calc_pos_x						; 6

	; inline



; calculates values for fine x-positioning:
;
; Basically, divides pos by 15 and stores the int result of that.
; Then, the mod of that is adjusted to equal 6 + HMP1.
;
; HMPx
;
; INPUT:
;   A = x-position
; RETURN:
;   Y = coarse value for delay loop (shifted to lower 4 bits)
;	 1 loop = 5 clocks = 15 pixels
;   A = fine value for HMPx, HMMx, or HMBL

calc_pos_x:
; 0
	tay								; 2
	iny		; (setup for div 15; causes 15 to overflow)	; 2
	tya								; 2
	and	#$0f	; A chopped to lower 4 (fine pos value + 1)	; 2
	sta	TEMP2	; temp2 = A  (fine pos value + 1)		; 3
	tya								; 2
; 13
	lsr		; (A div 16)					; 2
	lsr								; 2
	lsr								; 2
	lsr								; 2
; 21
	tay		; Y = A, backup shifted bits to Y		; 2
	clc								; 2
	adc	TEMP2	; change this from div 16 to div 15		; 3
	cmp	#15	; look for div 15 overflow			; 2
; 30
	bcc	skipIny ; skip to EOR  (no div 15 overflow)		; 2/3
	sbc	#15	; A = A - 15  (CF = 1 but not needed here)	; 2
	iny		; yes on the div 15 overflow so inc Y		; 2
; 36
skipIny:
; 36 / 33
	eor	#$07	; sets offset for 6 + HMPx			; 2
; 38 / 35

mult_16:
	asl             						; 2
	asl             						; 2
	asl             						; 2
	asl             						; 2
; 46/43

set_pos_x2:
	sta	HMP0,X	; fine position the object specified in X	; 4
; 50/47
	iny		; get past 68 pixels of horizontal blank	; 2
	iny								; 2
	iny								; 2
; 56/53
;	rts 62/69

; 56/53

;=================================
; be careful, when we do this here
; can lead to problems with the rts overflowing to next scanline
; if at right edge of screen

	sta	WSYNC							; 3

	; Y=0  -> (5)-1 + 4 =   8 cycles on screen?
	; Y=1  -> (10)-1 + 4 = 13 cycles
	; Y=8  -> (45)-1 + 4 = 48 cycles
	; Y=10 -> (55)-1 + 4 = 58 cycles
	; Y=11 -> (65)-1 + 4 = 63 cycles ; safe for rts/WSYNC (8*15=120)
	; Y=12 -> (65)-1 + 4 = 68 cycles
	; Y=13 -> (70)-1 + 4 = 73 cycles
	; Y=14 -> (75)-1 + 4 = 78 cycles
	; Y=15 -> (80)-1 + 4 = 83 cycles

	; 160/15 = 10+3 = 73 cycles

	; TIA=160+68 = 228

wait_pos:
	dey								; 2
	bpl	wait_pos	; 5-cycle loop (15 TIA color clocks)	; 2/3

	sta	RESP0,X           					; 4
	rts								; 6
