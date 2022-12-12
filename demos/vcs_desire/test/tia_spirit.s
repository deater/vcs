; testing tia music player

.include "../../vcs.inc"

; zero page addresses

.include "zp.inc"

; =====================================================================
; Flags
; =====================================================================

; 1: Global song speed, 0: Each pattern has individual speed
TT_GLOBAL_SPEED         = 1
; duration (number of TV frames) of a note
TT_SPEED                = 6
; duration of odd frames (needs TT_USE_FUNKTEMPO)
TT_ODD_SPEED            = 6

; 1: Overlay percussion, +40 bytes
TT_USE_OVERLAY          = 1
; 1: Melodic instrument slide, +9 bytes
TT_USE_SLIDE            = 0
; 1: Goto pattern, +8 bytes
TT_USE_GOTO             = 0
; 1: Odd/even rows have different SPEED values, +7 bytes
TT_USE_FUNKTEMPO        = 0
; If the very first notes played on each channel are not PAUSE, HOLD or
; SLIDE, i.e. if they start with an instrument or percussion, then set
; this flag to 0 to save 2 bytes.
; 0: +2 bytes
TT_STARTS_WITH_NOTES    = 1





; ---------------------------------------------------------------------
; Helper macro: Retrieves current note. May advance pattern if needed.
; Becomes a subroutine if TT_USE_OVERLAY is used.
; ---------------------------------------------------------------------
.macro TT_FETCH_CURRENT_NOTE
        ; construct ptr to pattern
constructPatPtr:
        ldy tt_cur_pat_index_c0,x       ; get current pattern (index into tt_SequenceTable)
        lda tt_SequenceTable,y
.if TT_USE_GOTO = 1
        bpl noPatternGoto
        and #%01111111                  ; mask out goto bit to get pattern number
        sta tt_cur_pat_index_c0,x       ; store goto'ed pattern index
        bpl constructPatPtr            ; unconditional
noPatternGoto:
.endif
        tay
        lda tt_PatternPtrLo,y
        sta tt_ptr
        lda tt_PatternPtrHi,y
        sta tt_ptr+1
        ; get new note
.if TT_USE_OVERLAY = 0
        ldy tt_cur_note_index_c0,x
.else
        ; If the V flag is set and if the new note is an instrument,
        ; it means it got pre-fetched by an overlay percussion, it has
        ; to remain in sustain.
        clv
        ; check if note had been pre-fetched by overlay perc already
        lda tt_cur_note_index_c0,x
        bpl notPrefetched
        ; If so, remove flag
        and #%01111111
        sta tt_cur_note_index_c0,x
        ; Set V flag for later
        bit tt_Bit6Set
notPrefetched:
        tay
.endif
        lda (tt_ptr),y
        ; pre-process new note
        ; 7..5: instrument (1..7), 4..0 (0..31): frequency
        ; 0/0: End of pattern
        bne noEndOfPattern
        ; End of pattern: Advance to next pattern
        sta tt_cur_note_index_c0,x      ; a is 0
        inc tt_cur_pat_index_c0,x
        bne constructPatPtr            ; unconditional
noEndOfPattern:
.endmacro


; ---------------------------------------------------------------------
; Helper subroutine to minimize ROM footprint. Will be inlined if
; TT_USE_OVERLAY is not used.
; Interleaved here so player can be inlined.
; ---------------------------------------------------------------------
.if TT_USE_OVERLAY = 1
tt_FetchNote:
        TT_FETCH_CURRENT_NOTE
        rts
.endif


; ---------------------------------------------------------------------
; Helper subroutine to minimize ROM footprint.
; Interleaved here so player routine can be inlined.
; ---------------------------------------------------------------------
tt_CalcInsIndex:
        ; move upper 3 bits to lower 3
        lsr
        lsr
        lsr
        lsr
        lsr
        tay
tt_Bit6Set:     ; This opcode has bit #6 set, for use with bit instruction
        rts


tia:
	sei
	cld
	ldx	#0
	txa
clear_loop:
	dex
	txs
	pha
	bne	clear_loop

	; S = $FF, A=$0, x=$0, Y=??


	;=====================
	; other includes


; =====================================================================
; Initialize music.
; Set tt_cur_pat_index_c0/1 to the indexes of the first patterns from
; tt_SequenceTable for each channel.
; Set tt_timer and tt_cur_note_index_c0/1 to 0.
; All other variables can start with any value.
; =====================================================================

	lda	#0
	sta	tt_cur_pat_index_c0
;	lda	#$4a
	lda	#72
	sta	tt_cur_pat_index_c1

	; the rest should be 0 already from startup code. If not,
	; set the following variables to 0 manually:
	; - tt_timer
	; - tt_cur_pat_index_c0
	; - tt_cur_pat_index_c1
	; - tt_cur_note_index_c0
	; - tt_cur_note_index_c1

;======================================================================
; MAIN LOOP
;======================================================================

tia_frame:

	;========================
	; start VBLANK
	;========================
	; in scanline 0

;	jsr	common_vblank

	lda	#02
	sta	VBLANK


	;================================
	; 45 lines of VBLANK (37 on NTSC)
	;================================


	;========================
	; update music player
	;========================
	; worst case for this particular song seems to be
	;	around 9 * 64 = 576 cycles = 8 scanlines
	;	make it 12 * 64 = 11 scanlines to be safe

	; Original is 43 * 64 cycles = 2752/76 = 36.2 scanlines

	lda	#$24		; TIM_VBLANK
	sta	TIM64T


	;=======================
	; run the music player
	;=======================

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

; =====================================================================
; Permanent variables. These are states needed by the player.
; =====================================================================
.if 0
tt_timer                ds 1    ; current music timer value
tt_cur_pat_index_c0     ds 1    ; current pattern index into tt_SequenceTable
tt_cur_pat_index_c1     ds 1
tt_cur_note_index_c0    ds 1    ; note index into current pattern
tt_cur_note_index_c1    ds 1
tt_envelope_index_c0    ds 1    ; index into ADSR envelope
tt_envelope_index_c1    ds 1
tt_cur_ins_c0           ds 1    ; current instrument
tt_cur_ins_c1           ds 1


; =====================================================================
; Temporary variables. These will be overwritten during a call to the
; player routine, but can be used between calls for other things.
; =====================================================================
tt_ptr                  ds 2
.endif

; =====================================================================
; TIATracker Player
; =====================================================================
tt_PlayerStart:

; PLANNED PLAYER VARIANTS:
; - RAM, speed, player ROM: c0/c1 patterns have same length
; - RAM: Pack 2 values (out of cur_pat_index, cur_note_index, envelope_index)
;       into one and use lsr/asl to unpack them, allowing only ranges of
;       16/16 or 32/8 for them, depending on number of patterns, max
;       pattern size and max ADSR size
; - ROM: Check if tt_SequenceTable can hold ptrs directly without indexing
;       tt_PatternPtrLo/Hi. Can be smaller if not many patterns get repeated
;       (saves table and decode routine)
; - Speed: Inline tt_CalcInsIndex
; - Speed: Store ptr to current note in RAM instead of reconstructing it?
;       Might also save the need for cur_note_index





; ---------------------------------------------------------------------
; Music player entry. Call once per frame.
; ---------------------------------------------------------------------
tt_Player: ; SUBROUTINE    
        ; ==================== Sequencer ====================
        ; Decrease speed timer
        dec tt_timer
        bpl noNewNote
        
        ; Timer ran out: Do sequencer
        ; Advance to next note
        ldx #1                          ; 2 channels
advanceLoop:
.if TT_USE_OVERLAY = 1
        jsr tt_FetchNote
.else
        TT_FETCH_CURRENT_NOTE
.endif
        ; Parse new note from pattern
        cmp #TT_INS_PAUSE
.if TT_USE_SLIDE = 0
        bcc finishedNewNote	
        bne newNote
.else
        beq pause
        bcs newNote

        ; --- slide/hold ---
        ; Adjust frequency and hold note in sustain.
        ; composer/tracker has to make sure that no unwanted
        ; under/overflow happens.
        ; Note: f = f + (8-(16-x)) = x + f - 8
        adc tt_cur_ins_c0,x             ; carry is clear after cmp
        sec
        sbc #8
        sta tt_cur_ins_c0,x
        bcs finishedNewNote            ; unconditional, since legally no underflow can happen (ins>0 or HOLD for ins=0)
.endif
  
        ; --- pause ---
pause:
        ; Get release index for current instrument. Since a pause can
        ; only follow an instrument, we don't need to handle percussion
        ; or commands.
        lda tt_cur_ins_c0,x
        jsr tt_CalcInsIndex
        lda tt_InsReleaseIndexes-1,y    ; -1 b/c instruments start at #1
        ; Put it into release. Skip junk byte so index no longer indicates
        ; sustain phase.
        clc
        adc #1
        bcc storeADIndex               ; unconditional



        ; --- start instrument or percussion ---
newNote:
        sta tt_cur_ins_c0,x             ; set new instrument
        ; Instrument or percussion?
        cmp #TT_FREQ_MASK+1
        bcs startInstrument

        ; --- start percussion ---
        ; Get index of envelope
        tay
        ; -TT_FIRST_PERC because percussion start with TT_FIRST_PERC
        lda tt_PercIndexes-TT_FIRST_PERC,y
        bne storeADIndex               ; unconditional, since index values are >0

        ; --- start instrument ---
startInstrument:
.if TT_USE_OVERLAY = 1
        ; If V flag is set, this note had been pre-fetched. That means
        ; it should remain in sustain.
        bvs finishedNewNote
.endif
        ; Put note into attack/decay
        jsr tt_CalcInsIndex
        lda tt_InsADIndexes-1,y         ; -1 because instruments start at #1
storeADIndex:
        sta tt_envelope_index_c0,x      

        ; --- Finished parsing new note ---
finishedNewNote:
        ; increase note index into pattern
        inc tt_cur_note_index_c0,x
        ; loop over channels
sequencerNextChannel:
        dex
        bpl advanceLoop

        ; Reset timer value
.if TT_GLOBAL_SPEED = 0
        ; Get timer value for current pattern in channel 0
        ldx tt_cur_pat_index_c0         ; get current pattern (index into tt_SequenceTable)
        ldy tt_SequenceTable,x          ; Current pattern index now in y
.if TT_USE_FUNKTEMPO = 0
        lda tt_PatternSpeeds,y
        sta tt_timer
.else
        ; Test for odd/even frame
        lda tt_cur_note_index_c0
        lsr
        lda tt_PatternSpeeds,y          ; does not affect carry flag
        bcc evenFrame
        and #$0f                        ; does not affect carry flag
        bcs storeFunkTempo        
evenFrame:
        lsr
        lsr
        lsr
        lsr
storeFunkTempo:
        sta tt_timer
.endif   ; TT_USE_FUNKTEMPO = 0

.else
        ; Global tempo
        ldx #TT_SPEED-1
.if TT_USE_FUNKTEMPO = 1
        lda tt_cur_note_index_c0
        lsr
        bcc noOddFrame
        ldx #TT_ODD_SPEED-1
noOddFrame:
.endif   ; TT_USE_FUNKTEMPO = 1
        stx tt_timer
.endif   ; TT_GLOBAL_SPEED = 0

        ; No new note to process
noNewNote:

        ; ==================== Update registers ====================
        ldx #1                          ; 2 channels
updateLoop:
        ; Percussion or melodic instrument?
        lda tt_cur_ins_c0,x
.if TT_STARTS_WITH_NOTES = 0
        ; This branch can be removed if track starts with a note in each channel
        beq afterAudioUpdate
.endif
        cmp #TT_FREQ_MASK+1
        bcs instrument                 ; Melodic instrument

        ; --- Percussion: Get envelope index ---
        ldy tt_envelope_index_c0,x
        ; Set AUDC and AUDV value from envelope
        lda tt_PercCtrlVolTable-1,y     ; -1 because values are stored +1
        beq endOfPercussion            ; 0 means end of percussion data
        inc tt_envelope_index_c0,x      ; if end not reached: advance index
endOfPercussion:
        sta AUDV0,x
        lsr
        lsr
        lsr
        lsr
        sta AUDC0,x     
        ; Set AUDF
        lda tt_PercFreqTable-1,y        ; -1 because values are stored +1
        ; Bit 7 (overlay) might be set, but is unused in AUDF
        sta AUDF0,x
.if TT_USE_OVERLAY = 1
        bpl afterAudioUpdate
        ; Overlay percussion: Fetch next note out of order
        jsr tt_FetchNote
        ; Only do something if it's a melodic instrument
        cmp #TT_FREQ_MASK+1
        bcc afterAudioUpdate
        ; Instrument: Put into sustain
        sta tt_cur_ins_c0,x             ; set new instrument
        jsr tt_CalcInsIndex
        lda tt_InsSustainIndexes-1,y    ; -1 because instruments start at #1
        sta tt_envelope_index_c0,x      
        ; Set prefetch flag. asl-sec-ror is smaller than lda-ora #128-sta
        asl tt_cur_note_index_c0,x
        sec
        ror tt_cur_note_index_c0,x
        bmi afterAudioUpdate           ; unconditional
.else
        jmp afterAudioUpdate
.endif

    


instrument:
        ; --- Melodic instrument ---
        ; Compute index into ADSR indexes and master Ctrl tables
        jsr tt_CalcInsIndex
        ; Set AUDC with master value for this instrument, while we are at it
        lda tt_InsCtrlTable-1,y ; -1 because instruments start with #1
        sta AUDC0,x
        ; advance ADSR counter and compare to end of Sustain
        lda tt_envelope_index_c0,x
        cmp tt_InsReleaseIndexes-1,y    ; -1 because instruments start with #1
        bne noEndOfSustain
        ; End of sustain: Go back to start of sustain
        lda tt_InsSustainIndexes-1,y    ; -1 because instruments start with #1
noEndOfSustain:
        tay
        ; Set volume from envelope
        lda tt_InsFreqVolTable,y
        beq endOfEnvelope              ; 0 means end of release has been reached:
        iny                             ; advance index otherwise
endOfEnvelope:
        sty tt_envelope_index_c0,x
        sta AUDV0,x
        ; Now adjust frequency with ADSR value from envelope
        lsr
        lsr
        lsr
        lsr     
        clc
        adc tt_cur_ins_c0,x
        sec
        sbc #8
        sta AUDF0,x

afterAudioUpdate:
        ; loop over channels
        dex
        bpl updateLoop




;        echo "Music player size: ", *-tt_PlayerStart


	; Measure player worst case timing
;;	lda	#12		; TIM_VBLANK
;	sec
;	sbc	INTIM
;	cmp	player_time_max
;	bcc	no_new_max
;	sta	player_time_max
no_new_max:

	lda	INTIM
	bne	no_new_max
	lda	#$0e
blah3:
	sta	WSYNC
	sta	VSYNC
	lsr
	bne	blah3
	lda	#$02
	sta	VBLANK
	lda	#$2b
	STA	TIM64T
blah:
	lda	INTIM
	bne	blah
	sta	WSYNC
	lda	#$00
	sta	VBLANK
	lda	#$13
	sta	T1024T
blah2:
	lda	INTIM
	bne	blah2
	jmp	tia_frame



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

; =====================================================================
; TIATracker melodic and percussion instruments, patterns and sequencer
; data.
; =====================================================================
tt_TrackDataStart:

; =====================================================================
; Melodic instrument definitions (up to 7). tt_envelope_index_c0/1 hold
; the index values into these tables for the current instruments played
; in channel 0 and 1.
; 
; Each instrument is defined by:
; - tt_InsCtrlTable: the AUDC value
; - tt_InsADIndexes: the index of the start of the ADSR envelope as
;       defined in tt_InsFreqVolTable
; - tt_InsSustainIndexes: the index of the start of the Sustain phase
;       of the envelope
; - tt_InsReleaseIndexes: the index of the start of the Release phase
; - tt_InsFreqVolTable: The AUDF frequency and AUDV volume values of
;       the envelope
; =====================================================================

;.align $100


.repeat 2621
	.byte $00
.endrepeat

; should be at fb55

; Intro right
tt_pattern19:
        .byte $11, $08, $08, $08, $12, $08, $08, $08
        .byte $11, $08, $08, $08, $12, $08, $08, $08
        .byte $00

; snnn
tt_pattern18:
        .byte $13, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $00

; end left
tt_pattern17:
        .byte $11, $08, $08, $11, $08, $08, $11, $08
        .byte $11, $08, $08, $08, $78, $08, $08, $08
        .byte $00

; bassline druma
tt_pattern16:
        .byte $11, $51, $28, $51, $12, $51, $28, $51
        .byte $28, $08, $29, $08, $2b, $08, $2d, $08
        .byte $00

; bassline drumg
tt_pattern15:
        .byte $11, $54, $29, $54, $12, $54, $29, $54
        .byte $11, $54, $29, $54, $12, $54, $29, $54
        .byte $00

; bassl.,drum,fill
tt_pattern14:
        .byte $11, $58, $2b, $58, $12, $58, $2b, $58
        .byte $28, $58, $29, $58, $2b, $58, $2d, $58
        .byte $00

; fill in left
tt_pattern13:
        .byte $65, $66, $65, $08, $65, $08, $67, $68
        .byte $69, $6d, $6b, $08, $6b, $08, $08, $08
        .byte $00

; break left 4
tt_pattern12:
        .byte $3b, $5b, $38, $58, $08, $08, $08, $08
        .byte $65, $08, $08, $08, $08, $08, $08, $08
        .byte $00

; break left 3
tt_pattern11:
        .byte $35, $55, $38, $58, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $3b, $5b, $38, $58
        .byte $00

; break left 2
tt_pattern10:
        .byte $3b, $5b, $38, $58, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $3b, $5b, $38, $58
        .byte $00

; break left 1
tt_pattern9:
        .byte $08, $08, $38, $58, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $3b, $5b, $38, $58
        .byte $00

; leer snare fill
tt_pattern8:
        .byte $11, $08, $08, $08, $12, $08, $08, $08
        .byte $08, $08, $08, $13, $08, $08, $13, $08
        .byte $00

; bassline drum g+
tt_pattern7:
        .byte $11, $54, $29, $54, $12, $54, $29, $54
        .byte $11, $51, $28, $51, $12, $51, $28, $51
        .byte $00


; Instrument master CTRL values
tt_InsCtrlTable:
        .byte $06, $06, $07, $06, $04, $0c

; bassline d
tt_pattern5:
        .byte $3b, $4d, $26, $4d, $3b, $4d, $26, $4d
        .byte $3b, $4d, $26, $4d, $3b, $4d, $26, $4d
        .byte $00

; bassline
tt_pattern4:
        .byte $38, $4b, $25, $4b, $38, $4b, $25, $4b
        .byte $38, $4b, $25, $4b, $38, $4b, $25, $4b
        .byte $00

; fill left 2
tt_pattern3:
        .byte $38, $08, $2b, $08, $08, $08, $2b, $08
        .byte $2d, $08, $2e, $08, $2f, $08, $35, $08
        .byte $00

; intro double
tt_pattern2:
        .byte $38, $58, $2b, $45, $25, $2b, $2b, $4b
        .byte $08, $08, $2b, $4b, $38, $58, $2b, $58
        .byte $00

; Intro left 2
tt_pattern1:
        .byte $38, $08, $2b, $08, $08, $08, $2b, $08
        .byte $2d, $08, $2e, $08, $2f, $08, $35, $08
        .byte $00

; Intro left
tt_pattern0:
        .byte $38, $08, $2b, $08, $08, $08, $2b, $08
        .byte $08, $08, $2b, $08, $08, $08, $38, $08
        .byte $00











;======================================================



; Instrument Attack/Decay start indexes into ADSR tables.
tt_InsADIndexes:
        .byte $00, $0d, $19, $27, $2f, $2f


; Instrument Sustain start indexes into ADSR tables
tt_InsSustainIndexes:
        .byte $08, $14, $23, $27, $2f, $2f


; Instrument Release start indexes into ADSR tables
; Caution: Values are stored with an implicit -1 modifier! To get the
; real index, add 1.
tt_InsReleaseIndexes:
        .byte $0a, $16, $24, $2c, $30, $30


; AUDVx and AUDFx ADSR envelope values.
; Each byte encodes the frequency and volume:
; - Bits 7..4: Freqency modifier for the current note ([-8..7]),
;       8 means no change. Bit 7 is the sign bit.
; - Bits 3..0: Volume
; Between sustain and release is one byte that is not used and
; can be any value.
; The end of the release phase is encoded by a 0.
tt_InsFreqVolTable:
; 0: Pizzicato bass
        .byte $8f, $8f, $8f, $8b, $8f, $8a, $84, $80
        .byte $80, $80, $00, $80, $00
; 1: Pizzicato bass echo
        .byte $88, $87, $84, $82, $80, $81, $80, $80
        .byte $80, $00, $80, $00
; 2: Electronic Guitar
        .byte $8c, $8c, $8a, $8a, $88, $98, $87, $85
        .byte $83, $81, $80, $00, $80, $00
; 3: beep
        .byte $8e, $87, $85, $83, $82, $00, $80, $00
; 4+5: ---
        .byte $80, $00, $80, $00



; =====================================================================
; Percussion instrument definitions (up to 15)
;
; Each percussion instrument is defined by:
; - tt_PercIndexes: The index of the first percussion frame as defined
;       in tt_PercFreqTable and tt_PercCtrlVolTable
; - tt_PercFreqTable: The AUDF frequency value
; - tt_PercCtrlVolTable: The AUDV volume and AUDC values
; =====================================================================

; Indexes into percussion definitions signifying the first frame for
; each percussion in tt_PercFreqTable.
; Caution: Values are stored with an implicit +1 modifier! To get the
; real index, subtract 1.
tt_PercIndexes:
        .byte $01, $10, $17, $26


; The AUDF frequency values for the percussion instruments.
; If the second to last value is negative (>=128), it means it's an
; "overlay" percussion, i.e. the player fetches the next instrument note
; immediately and starts it in the sustain phase next frame. (Needs
; TT_USE_OVERLAY)
tt_PercFreqTable:
; 0: Kick
        .byte $00, $01, $02, $03, $04, $05, $06, $07
        .byte $08, $09, $0a, $0b, $0c, $0d, $00
; 1: Snare
        .byte $05, $1b, $08, $05, $05, $05, $00
; 2: Snare
        .byte $07, $0d, $0e, $10, $14, $14, $15, $18
        .byte $18, $19, $1a, $1b, $1e, $1f, $00
; 3: Hat echo
        .byte $82, $00


; The AUDCx and AUDVx volume values for the percussion instruments.
; - Bits 7..4: AUDC value
; - Bits 3..0: AUDV value
; 0 means end of percussion data.
tt_PercCtrlVolTable:
; 0: Kick
        .byte $ef, $ee, $ee, $eb, $e9, $e8, $e8, $e6
        .byte $e6, $e6, $e4, $e4, $e1, $e1, $00
; 1: Snare
        .byte $8f, $cf, $6f, $89, $86, $83, $00
; 2: Snare
        .byte $8e, $8d, $8d, $8c, $8b, $8a, $88, $88
        .byte $87, $86, $84, $82, $81, $80, $00
; 3: Hat echo
        .byte $8c, $00


        
; =====================================================================
; Track definition
; The track is defined by:
; - tt_PatternX (X=0, 1, ...): Pattern definitions
; - tt_PatternPtrLo/Hi: Pointers to the tt_PatternX tables, serving
;       as index values
; - tt_SequenceTable: The order in which the patterns should be played,
;       i.e. indexes into tt_PatternPtrLo/Hi. Contains the sequences
;       for all channels and sub-tracks. The variables
;       tt_cur_pat_index_c0/1 hold an index into tt_SequenceTable for
;       each channel.
;
; So tt_SequenceTable holds indexes into tt_PatternPtrLo/Hi, which
; in turn point to pattern definitions (tt_PatternX) in which the notes
; to play are specified.
; =====================================================================

; ---------------------------------------------------------------------
; Pattern definitions, one table per pattern. tt_cur_note_index_c0/1
; hold the index values into these tables for the current pattern
; played in channel 0 and 1.
;
; A pattern is a sequence of notes (one byte per note) ending with a 0.
; A note can be either:
; - Pause: Put melodic instrument into release. Must only follow a
;       melodic instrument.
; - Hold: Continue to play last note (or silence). Default "empty" note.
; - Slide (needs TT_USE_SLIDE): Adjust frequency of last melodic note
;       by -7..+7 and keep playing it
; - Play new note with melodic instrument
; - Play new note with percussion instrument
; - End of pattern
;
; A note is defined by:
; - Bits 7..5: 1-7 means play melodic instrument 1-7 with a new note
;       and frequency in bits 4..0. If bits 7..5 are 0, bits 4..0 are
;       defined as:
;       - 0: End of pattern
;       - [1..15]: Slide -7..+7 (needs TT_USE_SLIDE)
;       - 8: Hold
;       - 16: Pause
;       - [17..31]: Play percussion instrument 1..15
;
; The tracker must ensure that a pause only follows a melodic
; instrument or a hold/slide.
; ---------------------------------------------------------------------
TT_FREQ_MASK    = %00011111
TT_INS_HOLD     = 8
TT_INS_PAUSE    = 16
TT_FIRST_PERC   = 17



; bassline drum
tt_pattern6:
        .byte $11, $58, $2b, $58, $12, $58, $2b, $58
        .byte $11, $58, $2b, $58, $12, $58, $2b, $58
        .byte $00




; puremelo2
tt_pattern31:
        .byte $67, $08, $67, $67, $08, $08, $68, $08
        .byte $67, $08, $08, $08, $65, $08, $08, $08
        .byte $00

; puremelo3
tt_pattern32:
        .byte $66, $08, $67, $69, $08, $08, $6d, $08
        .byte $67, $08, $08, $08, $68, $08, $08, $08
        .byte $00

; break right 1
tt_pattern33:
        .byte $11, $08, $14, $08, $08, $08, $14, $08
        .byte $08, $08, $14, $08, $08, $08, $14, $08
        .byte $00

; break left kick 
tt_pattern34:
        .byte $11, $08, $14, $11, $08, $08, $11, $08
        .byte $12, $08, $14, $08, $13, $08, $14, $08
        .byte $00

; just hihat
tt_pattern35:
        .byte $14, $08, $14, $08, $14, $08, $14, $08
        .byte $14, $08, $14, $08, $14, $08, $14, $08
        .byte $00

; endspurt recht1 
tt_pattern36:
        .byte $61, $08, $14, $08, $14, $08, $63, $08
        .byte $65, $08, $14, $08, $14, $08, $14, $08
        .byte $00

; endspurt recht12
tt_pattern37:
        .byte $65, $08, $14, $08, $14, $08, $63, $08
        .byte $62, $08, $14, $08, $14, $08, $14, $08
        .byte $00

; endright
tt_pattern38:
        .byte $08, $08, $65, $08, $08, $08, $65, $08
        .byte $08, $08, $66, $08, $6b, $08, $08, $08
        .byte $00


; Individual pattern speeds (needs TT_GLOBAL_SPEED = 0).
; Each byte encodes the speed of one pattern in the order
; of the tt_PatternPtr tables below.
; If TT_USE_FUNKTEMPO is 1, then the low nibble encodes
; the even speed and the high nibble the odd speed.
;.if TT_GLOBAL_SPEED = 0
;tt_PatternSpeeds:
;%%PATTERNSPEEDS%%
;.endif


; ---------------------------------------------------------------------
; Pattern pointers look-up table.
; ---------------------------------------------------------------------
tt_PatternPtrLo:

        .byte <tt_pattern0, <tt_pattern1, <tt_pattern2, <tt_pattern3
        .byte <tt_pattern4, <tt_pattern5, <tt_pattern6, <tt_pattern7
        .byte <tt_pattern8, <tt_pattern9, <tt_pattern10, <tt_pattern11
        .byte <tt_pattern12, <tt_pattern13, <tt_pattern14, <tt_pattern15
        .byte <tt_pattern16, <tt_pattern17, <tt_pattern18, <tt_pattern19
        .byte <tt_pattern20, <tt_pattern21, <tt_pattern22, <tt_pattern23
        .byte <tt_pattern24, <tt_pattern25, <tt_pattern26, <tt_pattern27
        .byte <tt_pattern28, <tt_pattern29, <tt_pattern30, <tt_pattern31
        .byte <tt_pattern32, <tt_pattern33, <tt_pattern34, <tt_pattern35
        .byte <tt_pattern36, <tt_pattern37, <tt_pattern38

tt_PatternPtrHi:
        .byte >tt_pattern0, >tt_pattern1, >tt_pattern2, >tt_pattern3
        .byte >tt_pattern4, >tt_pattern5, >tt_pattern6, >tt_pattern7
        .byte >tt_pattern8, >tt_pattern9, >tt_pattern10, >tt_pattern11
        .byte >tt_pattern12, >tt_pattern13, >tt_pattern14, >tt_pattern15
        .byte >tt_pattern16, >tt_pattern17, >tt_pattern18, >tt_pattern19
        .byte >tt_pattern20, >tt_pattern21, >tt_pattern22, >tt_pattern23
        .byte >tt_pattern24, >tt_pattern25, >tt_pattern26, >tt_pattern27
        .byte >tt_pattern28, >tt_pattern29, >tt_pattern30, >tt_pattern31
        .byte >tt_pattern32, >tt_pattern33, >tt_pattern34, >tt_pattern35
        .byte >tt_pattern36, >tt_pattern37, >tt_pattern38


; ---------------------------------------------------------------------
; Pattern sequence table. Each byte is an index into the
; tt_PatternPtrLo/Hi tables where the pointers to the pattern
; definitions can be found. When a pattern has been played completely,
; the next byte from this table is used to get the address of the next
; pattern to play. tt_cur_pat_index_c0/1 hold the current index values
; into this table for channels 0 and 1.
; If TT_USE_GOTO is used, a value >=128 denotes a goto to the pattern
; number encoded in bits 6..0 (i.e. value AND %01111111).
; ---------------------------------------------------------------------
tt_SequenceTable:
        ; ---------- Channel 0 ----------
        .byte $00, $00, $00, $01, $00, $00, $00, $01
        .byte $02, $02, $02, $03, $02, $02, $02, $03
        .byte $04, $04, $04, $05, $04, $04, $04, $05
        .byte $06, $06, $06, $07, $06, $06, $06, $03
        .byte $06, $06, $06, $07, $06, $06, $06, $08
        .byte $09, $0a, $0b, $0c, $09, $0a, $0b, $0c
        .byte $0d, $06, $06, $06, $0e, $06, $06, $06
        .byte $0e, $06, $06, $06, $0e, $0f, $10, $06
        .byte $0e, $0f, $10, $06, $0e, $00, $11, $12


        ; ---------- Channel 1 ----------
        .byte $13, $13, $13, $08, $13, $13, $13, $14
        .byte $15, $15, $15, $08, $15, $16, $17, $08
        .byte $18, $18, $18, $19, $1a, $1a, $1a, $1b
        .byte $1c, $1c, $1c, $1d, $1c, $1c, $1c, $1d
        .byte $1e, $1f, $1e, $20, $1e, $1f, $1e, $20
        .byte $21, $21, $21, $22, $21, $21, $21, $1b
        .byte $14, $23, $23, $23, $23, $23, $23, $23
        .byte $14, $24, $23, $25, $23, $25, $23, $24
        .byte $23, $25, $23, $24, $23, $1a, $26, $12


; puremelo1
tt_pattern30:
        .byte $67, $08, $67, $67, $08, $08, $67, $08
        .byte $67, $08, $08, $08, $6b, $08, $08, $08
        .byte $00

; maguggn2
tt_pattern29:
        .byte $40, $08, $08, $69, $08, $08, $69, $08
        .byte $08, $08, $68, $08, $08, $08, $68, $08
        .byte $00

; maguggn
tt_pattern28:
        .byte $cc, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $80, $08
        .byte $00

; fill
tt_pattern27:
        .byte $14, $08, $08, $14, $08, $08, $14, $08
        .byte $14, $14, $14, $14, $13, $08, $80, $08
        .byte $00

; melody
tt_pattern26:
        .byte $26, $25, $22, $82, $12, $08, $08, $62
        .byte $08, $08, $61, $08, $62, $08, $08, $08
        .byte $00

; New pattern d
tt_pattern25:
        .byte $08, $08, $08, $08, $62, $08, $08, $62
        .byte $08, $08, $61, $08, $62, $08, $08, $08
        .byte $00


; New pattern
tt_pattern24:
        .byte $08, $08, $08, $08, $62, $08, $08, $62
        .byte $08, $08, $63, $08, $62, $08, $08, $08
        .byte $00


; intro 2 right 3
tt_pattern23:
        .byte $11, $08, $78, $08, $12, $08, $6b, $08
        .byte $11, $08, $08, $08, $12, $08, $08, $08
        .byte $00

; intro 2 right 2
tt_pattern22:
        .byte $11, $08, $6d, $6b, $12, $08, $64, $65
        .byte $11, $08, $08, $08, $12, $08, $08, $08
        .byte $00


; fill 2
tt_pattern20:
        .byte $11, $08, $08, $11, $08, $08, $11, $08
        .byte $11, $08, $08, $08, $13, $08, $08, $08
        .byte $00

; intro 2 right
tt_pattern21:
        .byte $11, $08, $65, $08, $12, $08, $08, $08
        .byte $11, $08, $66, $65, $12, $08, $65, $08
        .byte $00

;        echo "Track size: ", *-tt_TrackDataStart



.segment "IRQ_VECTORS"
	.word tia	; NMI
	.word tia	; RESET
	.word tia	; IRQ


