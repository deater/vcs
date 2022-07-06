; Notes: for NTSC it's 160x192 pixels?
;	TIA: 160 pixels + 68 retrace
;	6502: 76 cycles per scanline
; 3 vertical sync / 37 VBLANK / 192 drawing / 30 overscan
; TIA: background, playfield, 2 sprites, 2 missiles, ball

; Memory Map
;	$00-$7F = TIA
;	$80-$FF = RAM
;	$180-$1FF (mirrored $80-$FF) can also be used as STACK 
;	$280-$2FF = RIOT
;	$1000-$1FFF = ROM (also mirrored at $F000-$FFFF)

; write addresses

VSYNC	=	$00	; reset beam to top (2 to start, 0 done after 3 lines)
VBLANK	=	$01	; turn off beam (write 2 to turn off, 0 to turn on)
WSYNC	=	$02	; sleep until beginning of next scanline
RSYNC	=	$03
NUSIZ0	=	$04
NUSIZ1	=	$05
COLUP0	=	$06
COLUP1	=	$07
COLUPF	=	$08
COLUBK	=	$09	; color/luminosity/background
CTRLPF	=	$0A
REFP0	=	$0B
REFP1	=	$0C
PF0	=	$0D
PF1	=	$0E
PF2	=	$0F
RESP0	=	$10
RESP1	=	$11
RESM0	=	$12
RESM1	=	$13
RESBL	=	$14	; reset ball
AUDC0	=	$15
AUDC1	=	$16
AUDF0	=	$17
AUDF1	=	$18
AUDV0	=	$19
AUDV1	=	$1A
GRP0	=	$1B
GRP1	=	$1C
ENAM0	=	$1D
ENAM1	=	$1E
ENABL	=	$1F
HMP0	=	$20
HMP1	=	$21
HMM0	=	$22
HMM1	=	$23
HMBL	=	$24
VDELP0	=	$25
VDELP1	=	$26
VDELBL	=	$27
RESMP0	=	$28
RESMP1	=	$29
HMOVE	=	$2A	; apply horizontal motion
HMCLR	=	$2B	; clear horizontal move
CXCLR	=	$2C	; clear collision latches

; read addresses
CXM0P	=	$00		; Collision Detect
CXM1P	=	$01
CXP0FB	=	$02
CXP1FB	=	$03
CXM0FB	=	$04
CXM1FB	=	$05
CXBLPF	=	$06
CXPPMM	=	$07
INPT0	=	$08		; pot port
INPT1	=	$09
INPT2	=	$0A
INPT3	=	$0B
INPT4	=	$0C		; joystick 0 button (bit 7)
INPT5	=	$0D		; joystick 1 button (bit 7) 

;========================================
; RIOT

SWCHA	=	$280		; Port A (joystick)
				;	bits 4-7 = player 1
				;	bits 0-3 = player 2
				;	$01=up   $02=down
				;	$04=left $08=right
SWACNT	=	$281		; Port A data direction

SWCHB	=	$282		; Port B (console switches)
SWBCNT	=	$283		; Port B data direction

INTIM	=	$284		; Timer output
TIMINT	=	$285

TIM1T	=	$294		; set 1 clock interval
TIM8T	=	$295		; set 8 clock interval
TIM64T	=	$296		; set 64 clock interval
T1024T	=	$297		; set 1024 clock interval
