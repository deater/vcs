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
        .byte $01, $04, $0c, $08, $04, $0c


; Instrument Attack/Decay start indexes into ADSR tables.
tt_InsADIndexes:
        .byte $00, $04, $04, $0b, $0f, $0f


; Instrument Sustain start indexes into ADSR tables
tt_InsSustainIndexes:
        .byte $00, $07, $07, $0b, $0f, $0f


; Instrument Release start indexes into ADSR tables
; Caution: Values are stored with an implicit -1 modifier! To get the
; real index, add 1.
tt_InsReleaseIndexes:
        .byte $01, $08, $08, $0c, $10, $10


; AUDVx and AUDFx ADSR envelope values.
; Each byte encodes the frequency and volume:
; - Bits 7..4: Freqency modifier for the current note ([-8..7]),
;       8 means no change. Bit 7 is the sign bit.
; - Bits 3..0: Volume
; Between sustain and release is one byte that is not used and
; can be any value.
; The end of the release phase is encoded by a 0.
tt_InsFreqVolTable:
; 0: boop
        .byte $8b, $00, $88, $00
; 1+2: Default
        .byte $8c, $8b, $8a, $89, $00, $88, $00
; 3: static
        .byte $8a, $00, $88, $00
; 4+5: Softer
        .byte $85, $00, $84, $00



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

; left0
tt_pattern0:
        .byte $39, $10, $08, $33, $10, $08, $08, $08
        .byte $36, $10, $08, $08, $33, $10, $08, $08
        .byte $08, $08, $36, $10, $39, $10, $08, $08
        .byte $39, $10, $08, $08, $36, $10, $36, $10
        .byte $08, $08, $08, $36, $10, $08, $08, $39
        .byte $10, $08, $08, $33, $10, $7f, $08, $10
        .byte $00

; New pattern
tt_pattern1:
        .byte $08, $08, $79, $08, $10, $08, $7f, $08
        .byte $08, $08, $10, $08, $08, $51, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $10, $08
        .byte $53, $08, $08, $08, $08, $08, $08, $10
        .byte $51, $08, $08, $08, $08, $08, $10, $73
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $00

; Left2
tt_pattern2:
        .byte $08, $08, $08, $08, $08, $08, $4f, $08
        .byte $08, $08, $08, $08, $10, $08, $4b, $08
        .byte $08, $08, $08, $08, $08, $10, $71, $08
        .byte $08, $08, $08, $08, $08, $48, $08, $08
        .byte $10, $71, $08, $10, $08, $49, $08, $08
        .byte $10, $4b, $08, $08, $71, $08, $08, $10
        .byte $00

; Left3
tt_pattern3:
        .byte $4b, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $10, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $00

; right0
tt_pattern4:
        .byte $8b, $10, $08, $89, $10, $08, $08, $08
        .byte $8a, $10, $08, $08, $89, $10, $08, $08
        .byte $08, $08, $8a, $10, $8b, $10, $08, $08
        .byte $8b, $10, $08, $08, $8b, $10, $8b, $10
        .byte $08, $08, $08, $8b, $10, $08, $08, $8b
        .byte $10, $08, $08, $89, $10, $08, $08, $b4
        .byte $00

; Right P1
tt_pattern5:
        .byte $08, $10, $08, $08, $08, $08, $08, $08
        .byte $77, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $10, $08, $08, $08, $77, $08, $10
        .byte $08, $5c, $08, $08, $08, $10, $08, $08
        .byte $b7, $08, $08, $08, $08, $10, $08, $08
        .byte $08, $08, $08, $08, $4b, $08, $08, $08
        .byte $00

; Right2
tt_pattern6:
        .byte $08, $08, $08, $08, $08, $08, $10, $49
        .byte $08, $08, $53, $08, $10, $08, $51, $08
        .byte $08, $08, $08, $08, $10, $08, $08, $08
        .byte $08, $08, $4b, $10, $08, $08, $4b, $08
        .byte $08, $08, $08, $08, $10, $71, $08, $08
        .byte $08, $10, $48, $08, $10, $08, $08, $08
        .byte $00

; Right3
tt_pattern7:
        .byte $08, $48, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $a8, $08, $08, $08, $08, $10
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
;    ENDIF


; ---------------------------------------------------------------------
; Pattern pointers look-up table.
; ---------------------------------------------------------------------
tt_PatternPtrLo:
        .byte <tt_pattern0, <tt_pattern1, <tt_pattern2, <tt_pattern3
        .byte <tt_pattern4, <tt_pattern5, <tt_pattern6, <tt_pattern7

tt_PatternPtrHi:
        .byte >tt_pattern0, >tt_pattern1, >tt_pattern2, >tt_pattern3
        .byte >tt_pattern4, >tt_pattern5, >tt_pattern6, >tt_pattern7
        


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
        .byte $00, $01, $02, $03

        
        ; ---------- Channel 1 ----------
        .byte $04, $05, $06, $07


;        echo "Track size: ", *-tt_TrackDataStart
