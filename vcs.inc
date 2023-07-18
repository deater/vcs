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

; control number and size of player and missiles
;  D5/D4 = Missile Size
;  D2/D1/D0 = player number/size
NUSIZ0	=	$04
NUSIZ1	=	$05
	NUSIZ_MISSILE_WIDTH_1	= $00
	NUSIZ_MISSILE_WIDTH_2	= $10
	NUSIZ_MISSILE_WIDTH_4	= $20
	NUSIZ_MISSILE_WIDTH_8	= $30

	NUSIZ_ONE_COPY		= $00
	NUSIZ_TWO_COPIES_CLOSE	= $01
	NUSIZ_TWO_COPIES_MED	= $02
	NUSIZ_THREE_COPIES_CLOSE= $03
	NUSIZ_TWO_COPIES_WIDE	= $04
	NUSIZ_DOUBLE_SIZE	= $05
	NUSIZ_THREE_COPIES_MED	= $06
	NUSIZ_QUAD_SIZE		= $07 




COLUP0	=	$06
COLUP1	=	$07
COLUPF	=	$08	; color of playfield
COLUBK	=	$09	; color of background
CTRLPF	=	$0A	; control the playfield
	CTRLPF_REF	=	$01	; reflect (mirror) playfield
	CTRLPF_SCORE	=	$02	; left/right colors P0/P1 colors
	CTRLPF_PFP	=	$04	; playfield has priority (sprites go behind)
	CTRLPF_BALL_SIZE1=	$00	; ball size
	CTRLPF_BALL_SIZE2=	$10
	CTRLPF_BALL_SIZE4=	$20
	CTRLPF_BALL_SIZE8=	$30
REFP0	=	$0B
REFP1	=	$0C

; playfield is 20 bits, each 4 pixels wide, then repeated/reflected
;  PF0   PF1       PF2
; |4567|76543210|01234567
PF0	=	$0D
PF1	=	$0E
PF2	=	$0F


RESP0	=	$10
RESP1	=	$11
RESM0	=	$12
RESM1	=	$13
RESBL	=	$14	; reset ball

; Audio
AUDC0	=	$15	; audio control, 4 bits
AUDC1	=	$16

AUDF0	=	$17	; audio frequency divider 5 bits (0=1, 1=2, .. 31=32) 
AUDF1	=	$18	;

AUDV0	=	$19	; audio volume (0..15)
AUDV1	=	$1A


GRP0	=	$1B	; graphics for P0
GRP1	=	$1C	; graphics for P1
ENAM0	=	$1D	; enable missile 0
ENAM1	=	$1E	; enable missile 1
ENABL	=	$1F	; enable ball
HMP0	=	$20	; p0 position fine tune
HMP1	=	$21	; p1 position fine tune
HMM0	=	$22	; missile 0 position fine tune
HMM1	=	$23	; missile 1 position fine tune
HMBL	=	$24	; ball position fine tune
VDELP0	=	$25	; delay p0
VDELP1	=	$26	; delay p1
VDELBL	=	$27	; delay ball
RESMP0	=	$28
RESMP1	=	$29
HMOVE	=	$2A	; apply horizontal motion
HMCLR	=	$2B	; clear horizontal move
CXCLR	=	$2C	; clear collision latches

; read addresses

; collision detect
CXM0P	=	$00		; Collision Detect
CXM1P	=	$01		;
CXP0FB	=	$02		; collision bit7=p0/pf, bit6=p0/bl
CXP1FB	=	$03		;
CXM0FB	=	$04		;
CXM1FB	=	$05		;
CXBLPF	=	$06		;
CXPPMM	=	$07		; collision bit7=p0/p1, bit6=m0/m1
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


; E7 bank-switch
; For E7 bank-switched cartridge (16k ROM, 2k RAM)

;       1FE0 - 1FE6 activates that bank of ROM into $1000-$17FF
;       1FE7 activates 1k of RAM instead (1000-13FF is write, 1400-17ff read)
;       1FE8 - 1FEB activates which 256B RAM shows up at $1800 W/$1900 R
;       1A00 - 1FDF ROM always visible



; signatures MAME looks for
;	$ad, $e5, $ff	lda $FFE5
;	$8d, $e7, $ff	sta $FFE7

E7_BANK_BASE		= $F000

E7_1K_WRITE_ADDR	= $F000
E7_1K_READ_ADDR		= $F400

E7_256B_WRITE_ADDR	= $F800
E7_256B_READ_ADDR	= $F900

E7_SET_BANK0		= $FFE0
E7_SET_BANK5		= $FFE5
E7_SET_BANK6		= $FFE6
E7_SET_BANK7_RAM	= $FFE7
E7_SET_256_BANK0	= $FFE8
