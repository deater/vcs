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
        .byte $06, $06, $06, $06


; Instrument Attack/Decay start indexes into ADSR tables.
tt_InsADIndexes:
        .byte $00, $08, $10, $18


; Instrument Sustain start indexes into ADSR tables
tt_InsSustainIndexes:
        .byte $04, $0c, $14, $1c


; Instrument Release start indexes into ADSR tables
; Caution: Values are stored with an implicit -1 modifier! To get the
; real index, add 1.
tt_InsReleaseIndexes:
        .byte $05, $0d, $15, $1d


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
        .byte $8f, $8f, $8c, $88, $81, $00, $80, $00
; 1: Pizzicato bass 3
        .byte $84, $83, $82, $82, $80, $00, $80, $00
; 2: Pizzicato bass (echo 1)
        .byte $8a, $89, $87, $83, $80, $00, $80, $00
; 3: Pizzicato bass echo 2
        .byte $85, $83, $82, $82, $80, $00, $80, $00



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
        .byte $01, $10, $1f, $21, $28


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
        .byte $07, $0d, $0e, $10, $14, $14, $15, $18
        .byte $18, $19, $1a, $1b, $1e, $1f, $00
; 2: Hat
        .byte $82, $00
; 3: Snare
        .byte $05, $1b, $08, $05, $05, $05, $00
; 4: Hatehoc
        .byte $82, $00


; The AUDCx and AUDVx volume values for the percussion instruments.
; - Bits 7..4: AUDC value
; - Bits 3..0: AUDV value
; 0 means end of percussion data.
tt_PercCtrlVolTable:
; 0: Kick
        .byte $ef, $ee, $ee, $eb, $e9, $e8, $e8, $e6
        .byte $e6, $e6, $e4, $e4, $e2, $e2, $00
; 1: Snare
        .byte $8e, $8d, $8d, $8c, $8b, $8a, $88, $88
        .byte $87, $86, $84, $82, $81, $80, $00
; 2: Hat
        .byte $89, $00
; 3: Snare
        .byte $8f, $cf, $6f, $89, $86, $83, $00
; 4: Hatehoc
        .byte $82, $00


        
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

; Intro left
tt_pattern0:
        .byte $2b, $4b, $2b, $4b, $6b, $4b, $8b, $4b
        .byte $2b, $4b, $2b, $4b, $8b, $4b, $2d, $4b
        .byte $00

; Intro l2
tt_pattern1:
        .byte $29, $49, $29, $49, $69, $49, $89, $49
        .byte $2d, $4d, $2d, $4d, $8d, $4d, $2d, $4d
        .byte $00

; bass plus kick
tt_pattern2:
        .byte $2b, $4b, $2b, $4b, $11, $4b, $8b, $4b
        .byte $2b, $4b, $2b, $4b, $11, $4b, $2d, $4b
        .byte $00

; bass+kick+chord2
tt_pattern3:
        .byte $29, $49, $29, $49, $11, $49, $89, $49
        .byte $2d, $4d, $2d, $4d, $11, $4d, $2d, $4d
        .byte $00

; 3octavebass E
tt_pattern4:
        .byte $38, $4b, $2b, $4b, $25, $4b, $8b, $4b
        .byte $38, $4b, $2b, $4b, $25, $4b, $2d, $4b
        .byte $00

; 3octave GD
tt_pattern5:
        .byte $34, $49, $29, $49, $24, $49, $89, $49
        .byte $3b, $4d, $2d, $4d, $26, $4d, $2d, $4d
        .byte $00

; melo2
tt_pattern6:
        .byte $41, $20, $21, $20, $41, $25, $24, $25
        .byte $41, $80, $20, $80, $41, $80, $20, $80
        .byte $00

; Intro right
tt_pattern7:
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $00

; intro r2
tt_pattern8:
        .byte $08, $08, $08, $08, $12, $08, $08, $08
        .byte $08, $08, $08, $08, $12, $08, $08, $08
        .byte $00

; intro r3
tt_pattern9:
        .byte $08, $08, $12, $08, $08, $12, $08, $08
        .byte $11, $08, $08, $11, $08, $08, $11, $08
        .byte $00

; Drums
tt_pattern10:
        .byte $11, $08, $13, $08, $14, $08, $13, $08
        .byte $11, $08, $11, $08, $14, $08, $13, $08
        .byte $00

; Drums2
tt_pattern11:
        .byte $11, $15, $13, $15, $14, $15, $13, $15
        .byte $11, $15, $11, $15, $14, $15, $13, $15
        .byte $00

; interlude melody
tt_pattern12:
        .byte $08, $08, $22, $62, $82, $42, $08, $08
        .byte $08, $08, $22, $62, $82, $42, $08, $08
        .byte $00

; melody1
tt_pattern13:
        .byte $08, $08, $21, $22, $61, $62, $81, $82
        .byte $41, $42, $08, $08, $08, $08, $08, $08
        .byte $00

; melody2
tt_pattern14:
        .byte $08, $08, $22, $21, $62, $61, $21, $22
        .byte $62, $61, $08, $08, $22, $21, $42, $41
        .byte $00

; melody3
tt_pattern15:
        .byte $11, $08, $21, $22, $61, $62, $81, $82
        .byte $41, $42, $08, $08, $12, $08, $08, $08
        .byte $00

; melody4
tt_pattern16:
        .byte $11, $08, $22, $21, $62, $61, $21, $22
        .byte $62, $61, $08, $08, $12, $08, $11, $08
        .byte $00

; Drums+melo
tt_pattern17:
        .byte $11, $08, $21, $22, $14, $08, $21, $22
        .byte $11, $08, $11, $08, $14, $08, $22, $21
        .byte $00

; Drums+melo2
tt_pattern18:
        .byte $11, $20, $21, $20, $14, $25, $24, $25
        .byte $11, $80, $20, $80, $14, $80, $20, $80
        .byte $00

; Drums+melo3
tt_pattern19:
        .byte $11, $20, $21, $20, $14, $25, $24, $25
        .byte $11, $08, $08, $12, $08, $08, $12, $08
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
        .byte <tt_pattern8, <tt_pattern9, <tt_pattern10, <tt_pattern11
        .byte <tt_pattern12, <tt_pattern13, <tt_pattern14, <tt_pattern15
        .byte <tt_pattern16, <tt_pattern17, <tt_pattern18, <tt_pattern19

tt_PatternPtrHi:
        .byte >tt_pattern0, >tt_pattern1, >tt_pattern2, >tt_pattern3
        .byte >tt_pattern4, >tt_pattern5, >tt_pattern6, >tt_pattern7
        .byte >tt_pattern8, >tt_pattern9, >tt_pattern10, >tt_pattern11
        .byte >tt_pattern12, >tt_pattern13, >tt_pattern14, >tt_pattern15
        .byte >tt_pattern16, >tt_pattern17, >tt_pattern18, >tt_pattern19
        


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
        .byte $04, $04, $04, $05, $04, $04, $04, $05
        .byte $02, $02, $02, $03, $02, $02, $02, $03
        .byte $00, $00, $00, $01, $00, $00, $00, $01
        .byte $06, $07

        
        ; ---------- Channel 1 ----------
        .byte $07, $07, $07, $07, $08, $08, $08, $09
        .byte $0a, $0a, $0a, $09, $0b, $0b, $0b, $09
        .byte $07, $07, $07, $09, $0c, $0c, $0c, $0c
        .byte $0d, $0d, $0d, $0e, $0f, $0f, $0f, $10
        .byte $11, $11, $11, $11, $12, $12, $12, $13
        .byte $06, $06, $06, $06, $0c, $0c, $0d, $09
        .byte $07, $08


;        echo "Track size: ", *-tt_TrackDataStart
