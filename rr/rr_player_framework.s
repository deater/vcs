; TIATracker music player
; Copyright 2016 Andre "Kylearan" Wichmann
; Website: https://bitbucket.org/kylearan/tiatracker
; Email: andre.wichmann@gmx.de
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
;   http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.

; Song author: 
; Song name: 

; @com.wudsn.ide.asm.hardware=ATARI2600

;        processor 6502
;        include vcs.h

; TV format switches
PAL             = 0
NTSC            = 1

.if PAL
TIM_VBLANK      = 43
TIM_OVERSCAN    = 36
TIM_KERNEL      = 19
.else
TIM_VBLANK      = 45
TIM_OVERSCAN    = 38
TIM_KERNEL      = 15
.endif

; =====================================================================
; Flags
; =====================================================================

; 1: Global song speed, 0: Each pattern has individual speed
TT_GLOBAL_SPEED         = 1
; duration (number of TV frames) of a note
TT_SPEED                = 7
; duration of odd frames (needs TT_USE_FUNKTEMPO)
TT_ODD_SPEED            = 7

; 1: Overlay percussion, +40 bytes
TT_USE_OVERLAY          = 0
; 1: Melodic instrument slide, +9 bytes
TT_USE_SLIDE            = 0
; 1: Goto pattern, +8 bytes
TT_USE_GOTO             = 1
; 1: Odd/even rows have different SPEED values, +7 bytes
TT_USE_FUNKTEMPO        = 0
; If the very first notes played on each channel are not PAUSE, HOLD or
; SLIDE, i.e. if they start with an instrument or percussion, then set
; this flag to 0 to save 2 bytes.
; 0: +2 bytes
TT_STARTS_WITH_NOTES    = 0


; =====================================================================
; Permanent variables. These are states needed by the player.
; =====================================================================
tt_timer                = $80    ; current music timer value
tt_cur_pat_index_c0     = $81    ; current pattern index into tt_SequenceTable
tt_cur_pat_index_c1     = $82
tt_cur_note_index_c0    = $83    ; note index into current pattern
tt_cur_note_index_c1    = $84
tt_envelope_index_c0    = $85   ; index into ADSR envelope
tt_envelope_index_c1    = $86
tt_cur_ins_c0           = $87   ; current instrument
tt_cur_ins_c1           = $88

; =====================================================================
; Temporary variables. These will be overwritten during a call to the
; player routine, but can be used between calls for other things.
; =====================================================================
tt_ptr                  = $89
tt_ptr2			= $8A


; test
player_time_max         = $AB


; =====================================================================
; Start of code
; =====================================================================

;        SEG     Bank0
;       ORG     $f000


; =====================================================================
; Initialize music.
; Set tt_cur_pat_index_c0/1 to the indexes of the first patterns from
; tt_SequenceTable for each channel.
; Set tt_timer and tt_cur_note_index_c0/1 to 0.
; All other variables can start with any value.
; =====================================================================
        lda #0
        sta tt_cur_pat_index_c0
        lda #12
        sta tt_cur_pat_index_c1
        ; the rest should be 0 already from startup code. If not,
        ; set the following variables to 0 manually:
        ; - tt_timer
        ; - tt_cur_pat_index_c0
        ; - tt_cur_pat_index_c1
        ; - tt_cur_note_index_c0
        ; - tt_cur_note_index_c1



; =====================================================================
; MAIN LOOP
; =====================================================================

MainLoop:

; ---------------------------------------------------------------------
; Overscan
; ---------------------------------------------------------------------

Overscan: ;        SUBROUTINE

        sta	WSYNC
        lda	#2
        sta	VBLANK
        lda	#TIM_OVERSCAN
        sta	TIM64T

        ; Do overscan stuff

waitForIntim:
        lda	INTIM
        bne	waitForIntim

; ---------------------------------------------------------------------
; VBlank
; ---------------------------------------------------------------------

VBlank:

        lda #%1110
vsyncLoop:
        sta WSYNC
        sta VSYNC
        lsr
        bne vsyncLoop
        lda #2
        sta VBLANK
        lda #TIM_VBLANK
        sta TIM64T

        ; Do VBlank stuff
.include "rr_player.s"

        ; Measure player worst case timing
        lda #TIM_VBLANK
        sec
        sbc INTIM
        cmp player_time_max
        bcc noNewMax
        sta player_time_max
noNewMax:


waitForVBlank:
        lda INTIM
        bne waitForVBlank
        sta WSYNC
        sta VBLANK


; ---------------------------------------------------------------------
; Kernel
; ---------------------------------------------------------------------

Kernel: ;  SUBROUTINE
        lda #TIM_KERNEL
        sta T1024T

        ; Do kernel stuff

waitForIntim2:
        lda INTIM
        bne waitForIntim2

        jmp MainLoop


; =====================================================================
; Data
; =====================================================================

.include "rr_trackdata.s"


; =====================================================================
; Vectors
; =====================================================================

 ;       echo "ROM left: ", ($fffc - *)

  ;      ORG             $fffc
   ;    .word   Start
   ;     .word   Start
