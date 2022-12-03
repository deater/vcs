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

; Instrument master CTRL values
tt_InsCtrlTable:
        .byte $06, $06, $04, $0c, $06, $04, $0c


; Instrument Attack/Decay start indexes into ADSR tables.
tt_InsADIndexes:
        .byte $00, $07, $0f, $0f, $15, $1f, $1f


; Instrument Sustain start indexes into ADSR tables
tt_InsSustainIndexes:
        .byte $02, $0b, $0f, $0f, $17, $1f, $1f


; Instrument Release start indexes into ADSR tables
; Caution: Values are stored with an implicit -1 modifier! To get the
; real index, add 1.
tt_InsReleaseIndexes:
        .byte $04, $0c, $10, $10, $1c, $22, $22


; AUDVx and AUDFx ADSR envelope values.
; Each byte encodes the frequency and volume:
; - Bits 7..4: Freqency modifier for the current note ([-8..7]),
;       8 means no change. Bit 7 is the sign bit.
; - Bits 3..0: Volume
; Between sustain and release is one byte that is not used and
; can be any value.
; The end of the release phase is encoded by a 0.
tt_InsFreqVolTable:
; 0: bass3
        .byte $8b, $8c, $8a, $8b, $00, $8a, $00
; 1: bass6
        .byte $88, $8a, $88, $88, $82, $00, $80, $00
; 2+3: lower
        .byte $86, $00, $86, $86, $83, $00
; 4: steel
        .byte $99, $6b, $9b, $c8, $99, $67, $c9, $00
        .byte $97, $00
; 5+6: Flute
        .byte $8d, $8c, $8c, $00, $85, $00



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



; The AUDF frequency values for the percussion instruments.
; If the second to last value is negative (>=128), it means it's an
; "overlay" percussion, i.e. the player fetches the next instrument note
; immediately and starts it in the sustain phase next frame. (Needs
; TT_USE_OVERLAY)
tt_PercFreqTable:


; The AUDCx and AUDVx volume values for the percussion instruments.
; - Bits 7..4: AUDC value
; - Bits 3..0: AUDV value
; 0 means end of percussion data.
tt_PercCtrlVolTable:


        
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

; New pattern
tt_pattern0:
        .byte $08, $2c, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $00

; p1L
tt_pattern1:
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $58, $08, $08
        .byte $08, $58, $08, $58, $08, $58, $08, $08
        .byte $58, $08, $08, $08, $56, $08, $08, $56
        .byte $08, $56, $08, $56, $08, $08, $56, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $00

; P2L
tt_pattern2:
        .byte $08, $29, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $27, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $26, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $00

; PL3
tt_pattern3:
        .byte $7f, $08, $08, $08, $45, $08, $45, $08
        .byte $08, $08, $08, $08, $45, $08, $45, $08
        .byte $08, $08, $08, $08, $46, $08, $46, $08
        .byte $08, $08, $08, $08, $45, $08, $45, $08
        .byte $08, $08, $08, $08, $45, $08, $45, $08
        .byte $08, $08, $08, $08, $46, $08, $46, $10
        .byte $00

; P4l
tt_pattern4:
        .byte $2d, $08, $10, $08, $ab, $10, $ab, $10
        .byte $08, $08, $08, $08, $ab, $10, $ab, $10
        .byte $08, $08, $08, $08, $ad, $10, $ad, $10
        .byte $08, $08, $08, $08, $ae, $10, $ae, $10
        .byte $27, $08, $10, $08, $29, $08, $10, $08
        .byte $29, $08, $10, $08, $29, $10, $27, $10
        .byte $00

; p5l
tt_pattern5:
        .byte $28, $08, $10, $08, $28, $08, $10, $08
        .byte $29, $08, $10, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $ab, $10, $ab, $08
        .byte $10, $08, $08, $08, $ab, $10, $ab, $08
        .byte $10, $08, $08, $08, $ad, $10, $ad, $08
        .byte $10, $08, $08, $08, $ae, $10, $ae, $10
        .byte $27, $08, $10, $08, $29, $08, $10, $08
        .byte $00

; p6l
tt_pattern6:
        .byte $08, $08, $29, $10, $08, $08, $08, $08
        .byte $27, $10, $28, $10, $08, $08, $28, $10
        .byte $08, $08, $2d, $10, $08, $08, $ad, $10
        .byte $ad, $08, $10, $08, $08, $08, $ad, $10
        .byte $ad, $08, $10, $08, $08, $08, $a9, $10
        .byte $a9, $08, $10, $08, $08, $08, $ad, $10
        .byte $ad, $10, $00

; p7l
tt_pattern7:
        .byte $2b, $10, $08, $08, $ab, $10, $ab, $08
        .byte $10, $08, $08, $08, $ad, $10, $ad, $08
        .byte $10, $08, $08, $08, $ae, $10, $ae, $08
        .byte $10, $08, $08, $08, $ad, $10, $ad, $08
        .byte $10, $08, $08, $08, $ab, $10, $ab, $08
        .byte $10, $08, $08, $08, $ad, $10, $ad, $08
        .byte $10, $08, $08, $08, $2e, $10, $2e, $08
        .byte $08, $10, $08, $08, $ae, $10, $ae, $10
        .byte $00

; p8l
tt_pattern8:
        .byte $08, $2e, $08, $10, $08, $29, $08, $10
        .byte $08, $29, $08, $10, $08, $08, $08, $27
        .byte $10, $28, $08, $10, $08, $28, $08, $10
        .byte $08, $2b, $08, $08, $08, $ab, $10, $ab
        .byte $08, $10, $08, $08, $08, $ab, $10, $ab
        .byte $08, $10, $08, $08, $08, $ad, $10, $ad
        .byte $08, $10, $08, $08, $08, $ab, $10, $ab
        .byte $10, $08, $08, $08, $08, $ab, $10, $ab
        .byte $00

; p9l
tt_pattern9:
        .byte $10, $08, $08, $08, $08, $ad, $10, $ad
        .byte $10, $26, $08, $2b, $08, $29, $08, $2b
        .byte $08, $29, $08, $2e, $08, $2b, $08, $2e
        .byte $08, $29, $08, $2e, $08, $2b, $08, $2e
        .byte $08, $27, $08, $2d, $08, $29, $08, $2d
        .byte $08, $29, $08, $2d, $08, $29, $08, $2d
        .byte $08, $29, $08, $2d, $08, $29, $08, $2d
        .byte $08, $00

; pal
tt_pattern10:
        .byte $28, $08, $2d, $08, $2a, $08, $2d, $08
        .byte $2a, $08, $2d, $08, $2e, $08, $2a, $08
        .byte $29, $08, $2a, $08, $2b, $08, $2a, $08
        .byte $29, $08, $2f, $08, $2b, $08, $2f, $08
        .byte $2b, $08, $2f, $08, $2b, $08, $2f, $08
        .byte $2b, $08, $2f, $08, $2b, $08, $2f, $08
        .byte $2b, $08, $2f, $08, $2b, $08, $2f, $08
        .byte $00

; pbl
tt_pattern11:
        .byte $aa, $08, $10, $08, $aa, $10, $aa, $08
        .byte $10, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $aa, $10, $aa, $10
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $27, $08, $10, $08, $29, $08, $10, $08
        .byte $29, $08, $10, $08, $08, $08, $29, $10
        .byte $2a, $08, $10, $08, $29, $08, $10, $08
        .byte $2a, $10, $29, $10, $2b, $10, $29, $10
        .byte $00

; pcl
tt_pattern12:
        .byte $2c, $08, $10, $08, $ae, $10, $ae, $08
        .byte $08, $08, $10, $08, $ae, $10, $ae, $08
        .byte $10, $08, $08, $08, $ae, $10, $ae, $08
        .byte $10, $08, $08, $08, $ae, $08, $10, $08
        .byte $28, $08, $10, $08, $2a, $08, $10, $08
        .byte $2a, $08, $10, $08, $08, $08, $2a, $10
        .byte $2b, $08, $10, $08, $2a, $08, $10, $08
        .byte $2b, $10, $2a, $08, $2d, $10, $08, $08
        .byte $00

; New
tt_pattern13:
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $cb, $cf
        .byte $d3, $d4, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $da, $08, $08, $08, $d7
        .byte $08, $08, $08, $d4, $08, $08, $08, $da
        .byte $08, $08, $08, $d7, $08, $08, $08, $df
        .byte $00

; P1R
tt_pattern14:
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $9a, $08, $08
        .byte $08, $97, $08, $08, $08, $94, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $91
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $92, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $00

; P2R
tt_pattern15:
        .byte $08, $08, $91, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $8f, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $8d, $08
        .byte $08, $08, $8c, $08, $08, $08, $08, $08
        .byte $8b, $08, $08, $08, $08, $08, $7f, $08
        .byte $08, $08, $08, $08, $7a, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $00

; PR3
tt_pattern16:
        .byte $6b, $08, $77, $08, $73, $08, $77, $08
        .byte $6f, $08, $73, $08, $77, $08, $8c, $08
        .byte $91, $08, $7a, $08, $74, $08, $7a, $08
        .byte $8f, $08, $7f, $08, $77, $08, $7f, $08
        .byte $6f, $08, $73, $08, $77, $08, $7f, $08
        .byte $91, $08, $7a, $08, $74, $08, $7a, $08
        .byte $00

; P4R
tt_pattern17:
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $d7, $08, $08, $10, $d7, $08, $d3, $08
        .byte $d4, $08, $d7, $08, $da, $08, $08, $08
        .byte $d7, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $da, $08, $08, $10
        .byte $da, $08, $dd, $08, $df, $08, $da, $08
        .byte $00

; p5r
tt_pattern18:
        .byte $dd, $08, $08, $10, $dd, $08, $08, $08
        .byte $df, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $d7, $08, $08, $10
        .byte $d7, $08, $08, $10, $d7, $08, $d3, $08
        .byte $d4, $08, $d7, $08, $da, $08, $08, $08
        .byte $d7, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $00

; p6r
tt_pattern19:
        .byte $d4, $08, $d3, $08, $08, $10, $d3, $08
        .byte $08, $08, $d1, $08, $08, $08, $08, $08
        .byte $08, $08, $d4, $08, $08, $08, $08, $08
        .byte $d3, $08, $d4, $08, $d7, $08, $da, $08
        .byte $d4, $08, $d3, $08, $08, $10, $d3, $08
        .byte $08, $08, $d4, $08, $08, $08, $08, $08
        .byte $08, $08, $00

; p64r
tt_pattern20:
        .byte $d7, $08, $08, $08, $08, $08, $d3, $08
        .byte $d4, $08, $d7, $08, $da, $08, $d4, $08
        .byte $d3, $08, $08, $10, $d3, $08, $08, $08
        .byte $d4, $08, $08, $08, $08, $08, $08, $08
        .byte $d7, $08, $08, $08, $08, $08, $d3, $08
        .byte $d4, $08, $d7, $08, $da, $08, $08, $08
        .byte $d7, $08, $08, $10, $d7, $08, $08, $10
        .byte $d7, $08, $08, $08, $08, $08, $08, $08
        .byte $00

; p8r
tt_pattern21:
        .byte $08, $08, $08, $08, $08, $d7, $08, $08
        .byte $08, $da, $08, $dd, $08, $df, $08, $da
        .byte $08, $dd, $08, $08, $10, $dd, $08, $08
        .byte $08, $df, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $00

; p9r
tt_pattern22:
        .byte $08, $df, $08, $08, $08, $da, $08, $08
        .byte $08, $d7, $08, $08, $08, $d3, $08, $08
        .byte $10, $d3, $08, $08, $08, $08, $08, $08
        .byte $08, $dd, $08, $cf, $08, $d1, $08, $ce
        .byte $08, $da, $08, $08, $08, $d3, $08, $08
        .byte $10, $d3, $08, $08, $08, $08, $08, $08
        .byte $08, $df, $08, $08, $08, $d3, $08, $08
        .byte $08, $00

; par
tt_pattern23:
        .byte $dd, $08, $08, $08, $da, $08, $08, $10
        .byte $da, $08, $08, $08, $08, $08, $da, $08
        .byte $da, $08, $d1, $08, $d3, $08, $d1, $08
        .byte $d3, $08, $08, $08, $d4, $08, $08, $08
        .byte $d7, $08, $08, $08, $df, $08, $08, $08
        .byte $df, $08, $08, $08, $08, $08, $08, $08
        .byte $ed, $08, $08, $08, $ec, $08, $08, $08
        .byte $00

; pbr
tt_pattern24:
        .byte $eb, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $ec, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $ed, $08, $08, $08
        .byte $00

; pcr
tt_pattern25:
        .byte $ec, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $dd, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $da, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $00




; Individual pattern speeds (needs TT_GLOBAL_SPEED = 0).
; Each byte encodes the speed of one pattern in the order
; of the tt_PatternPtr tables below.
; If TT_USE_FUNKTEMPO is 1, then the low nibble encodes
; the even speed and the high nibble the odd speed.
;    IF TT_GLOBAL_SPEED = 0
;tt_PatternSpeeds:
;%%PATTERNSPEEDS%%
;   ENDIF


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
        .byte <tt_pattern24, <tt_pattern25
tt_PatternPtrHi:
        .byte >tt_pattern0, >tt_pattern1, >tt_pattern2, >tt_pattern3
        .byte >tt_pattern4, >tt_pattern5, >tt_pattern6, >tt_pattern7
        .byte >tt_pattern8, >tt_pattern9, >tt_pattern10, >tt_pattern11
        .byte >tt_pattern12, >tt_pattern13, >tt_pattern14, >tt_pattern15
        .byte >tt_pattern16, >tt_pattern17, >tt_pattern18, >tt_pattern19
        .byte >tt_pattern20, >tt_pattern21, >tt_pattern22, >tt_pattern23
        .byte >tt_pattern24, >tt_pattern25        


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
        .byte $00, $01, $02, $03, $04, $05, $06, $07
        .byte $08, $09, $0a, $0b, $0c, $84

        
        ; ---------- Channel 1 ----------
        .byte $0d, $0e, $0f, $10, $11, $12, $13, $14
        .byte $15, $16, $17, $18, $19, $92


;        echo "Track size: ", *-tt_TrackDataStart
