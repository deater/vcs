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
        .byte $04, $0c, $04, $0c, $01, $06, $03


; Instrument Attack/Decay start indexes into ADSR tables.
tt_InsADIndexes:
        .byte $00, $00, $06, $06, $0c, $14, $1a


; Instrument Sustain start indexes into ADSR tables
tt_InsSustainIndexes:
        .byte $02, $02, $08, $08, $10, $16, $1a


; Instrument Release start indexes into ADSR tables
; Caution: Values are stored with an implicit -1 modifier! To get the
; real index, add 1.
tt_InsReleaseIndexes:
        .byte $03, $03, $09, $09, $11, $17, $1b


; AUDVx and AUDFx ADSR envelope values.
; Each byte encodes the frequency and volume:
; - Bits 7..4: Freqency modifier for the current note ([-8..7]),
;       8 means no change. Bit 7 is the sign bit.
; - Bits 3..0: Volume
; Between sustain and release is one byte that is not used and
; can be any value.
; The end of the release phase is encoded by a 0.
tt_InsFreqVolTable:
; 0+1: ---
        .byte $82, $83, $81, $00, $80, $00
; 2+3: ---
        .byte $89, $86, $86, $00, $83, $00
; 4: ---
        .byte $83, $85, $86, $85, $83, $00, $81, $00
; 5: ---
        .byte $88, $85, $83, $00, $82, $00
; 6: ---
        .byte $86, $00, $82, $00



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
        .byte $01, $08


; The AUDF frequency values for the percussion instruments.
; If the second to last value is negative (>=128), it means it's an
; "overlay" percussion, i.e. the player fetches the next instrument note
; immediately and starts it in the sustain phase next frame. (Needs
; TT_USE_OVERLAY)
tt_PercFreqTable:
; 0: ---
        .byte $05, $1b, $1f, $1c, $1d, $1e, $00
; 1: ---
        .byte $0c, $15, $1c, $1a, $1b, $1f, $17, $96
        .byte $00


; The AUDCx and AUDVx volume values for the percussion instruments.
; - Bits 7..4: AUDC value
; - Bits 3..0: AUDV value
; 0 means end of percussion data.
tt_PercCtrlVolTable:
; 0: ---
        .byte $14, $c5, $c4, $83, $82, $80, $00
; 1: ---
        .byte $88, $85, $c2, $83, $80, $80, $80, $80
        .byte $00


        
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
        .byte $4f, $08, $3f, $08, $4b, $08, $4f, $08
        .byte $3f, $08, $4b, $08, $4f, $08, $3f, $08
        .byte $51, $08, $4b, $08, $4d, $08, $51, $08
        .byte $4b, $08, $4d, $08, $54, $08, $4d, $08
        .byte $4b, $08, $54, $08, $4d, $08, $4b, $08
        .byte $54, $08, $4d, $08, $4b, $08, $54, $08
        .byte $4d, $08, $3f, $08, $54, $08, $4d, $08
        .byte $3f, $08, $54, $08, $4d, $08, $3f, $08
        .byte $00

; Intro left1
tt_pattern1:
        .byte $4f, $08, $4b, $08, $8f, $08, $4f, $08
        .byte $8b, $08, $3f, $08, $4f, $08, $7f, $08
        .byte $4b, $08, $3f, $08, $91, $08, $51, $08
        .byte $4b, $08, $4d, $08, $54, $08, $4d, $08
        .byte $91, $08, $54, $08, $4d, $08, $8d, $08
        .byte $54, $08, $4d, $08, $4b, $08, $8b, $08
        .byte $4d, $08, $3f, $08, $54, $08, $8b, $08
        .byte $91, $08, $54, $08, $8d, $08, $3f, $08
        .byte $00

; Intro left2
tt_pattern2:
        .byte $4f, $08, $4b, $08, $8f, $08, $4f, $08
        .byte $8b, $08, $3f, $08, $4f, $08, $7f, $08
        .byte $4b, $08, $3f, $08, $91, $08, $51, $08
        .byte $4b, $08, $4d, $08, $54, $08, $4d, $08
        .byte $91, $08, $54, $08, $4d, $08, $4d, $08
        .byte $4b, $08, $4d, $08, $7f, $08, $91, $08
        .byte $4d, $08, $3f, $08, $8b, $08, $91, $08
        .byte $8d, $08, $54, $08, $8f, $08, $4b, $08
        .byte $00

; Intro left3
tt_pattern3:
        .byte $4f, $08, $4b, $08, $8f, $08, $4f, $08
        .byte $94, $08, $3f, $08, $4f, $08, $3f, $08
        .byte $91, $08, $3f, $08, $4d, $08, $51, $08
        .byte $4b, $08, $4d, $08, $94, $08, $4d, $08
        .byte $97, $08, $54, $08, $4d, $08, $4b, $08
        .byte $54, $08, $4d, $08, $94, $08, $54, $08
        .byte $4d, $08, $3f, $08, $8f, $08, $4d, $08
        .byte $8b, $08, $54, $08, $91, $08, $3f, $08
        .byte $00

; Intro left3a
tt_pattern4:
        .byte $4f, $08, $4b, $08, $8f, $08, $4f, $08
        .byte $94, $08, $3f, $08, $4f, $08, $3f, $08
        .byte $91, $08, $3f, $08, $4d, $08, $51, $08
        .byte $4b, $08, $4d, $08, $8d, $08, $4d, $08
        .byte $3f, $08, $91, $08, $4d, $08, $3f, $08
        .byte $91, $08, $94, $08, $3f, $08, $54, $08
        .byte $97, $08, $3f, $08, $54, $08, $4d, $08
        .byte $3f, $08, $54, $08, $94, $08, $3f, $08
        .byte $00

; left2
tt_pattern5:
        .byte $8f, $10, $8f, $10, $94, $10, $8f, $10
        .byte $08, $08, $08, $08, $ac, $08, $08, $08
        .byte $91, $10, $91, $10, $97, $10, $93, $08
        .byte $ac, $08, $af, $10, $b2, $08, $08, $08
        .byte $8f, $10, $8f, $10, $94, $10, $91, $10
        .byte $08, $08, $08, $b2, $08, $08, $b0, $08
        .byte $8f, $8b, $08, $08, $7f, $10, $7d, $10
        .byte $7a, $10, $7d, $10, $7f, $08, $08, $08
        .byte $8b, $08, $08, $08, $08, $10, $08, $08
        .byte $08, $08, $37, $10, $3f, $10, $37, $10
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $3a, $10, $3a, $10
        .byte $08, $08, $08, $08, $08, $08, $3f, $10
        .byte $3f, $10, $3f, $10, $8b, $10, $7f, $10
        .byte $7d, $10, $08, $08, $7f, $10, $08, $08
        .byte $8b, $10, $08, $08, $8f, $10, $08, $00

; left1
tt_pattern6:
        .byte $08, $9f, $10, $4f, $10, $8f, $10, $77
        .byte $10, $7f, $10, $8b, $10, $8f, $08, $08
        .byte $08, $10, $08, $08, $08, $3f, $08, $3a
        .byte $08, $37, $08, $33, $08, $3a, $08, $08
        .byte $00

; left1a
tt_pattern7:
        .byte $08, $9f, $10, $4f, $10, $8f, $10, $77
        .byte $10, $7f, $10, $8b, $10, $8f, $08, $08
        .byte $08, $10, $08, $08, $08, $37, $10, $31
        .byte $10, $33, $10, $34, $10, $37, $08, $08
        .byte $00

; left3
tt_pattern8:
        .byte $08, $4f, $4b, $3f, $37, $4f, $3f, $3a
        .byte $37, $08, $08, $08, $08, $3d, $3f, $4f
        .byte $51, $08, $08, $08, $08, $ac, $10, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $00

; left4
tt_pattern9:
        .byte $08, $94, $08, $10, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $3f, $08, $10, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $00

; left5
tt_pattern10:
        .byte $08, $4f, $08, $08, $08, $08, $08, $08
        .byte $08, $4c, $4b, $3f, $3d, $3a, $08, $3d
        .byte $08, $3f, $08, $08, $08, $08, $08, $4b
        .byte $08, $08, $08, $08, $3d, $08, $08, $08
        .byte $00

; left6
tt_pattern11:
        .byte $08, $9f, $10, $5f, $10, $57, $10, $54
        .byte $10, $4f, $10, $57, $10, $57, $10, $54
        .byte $08, $08, $08, $08, $08, $77, $10, $7a
        .byte $10, $7f, $10, $08, $08, $8f, $10, $94
        .byte $00

; left6a
tt_pattern12:
        .byte $08, $9f, $10, $5f, $10, $57, $10, $54
        .byte $10, $4f, $10, $57, $10, $57, $10, $54
        .byte $08, $08, $08, $08, $08, $77, $10, $7a
        .byte $10, $7f, $10, $08, $08, $8e, $10, $7f
        .byte $00

; lef7
tt_pattern13:
        .byte $08, $8f, $97, $9f, $10, $08, $08, $9f
        .byte $10, $8f, $8b, $7f, $10, $08, $08, $7d
        .byte $08, $10, $08, $7f, $08, $8b, $08, $3f
        .byte $08, $4b, $08, $8f, $08, $91, $08, $94
        .byte $00

; left8
tt_pattern14:
        .byte $08, $37, $3a, $3d, $08, $08, $08, $3f
        .byte $08, $4b, $08, $4f, $08, $54, $08, $08
        .byte $08, $4f, $08, $4b, $08, $3f, $08, $3a
        .byte $08, $37, $08, $08, $08, $08, $08, $08
        .byte $00

; left9
tt_pattern15:
        .byte $08, $9f, $5f, $4f, $4e, $4d, $3f, $7a
        .byte $10, $3f, $4b, $4d, $4b, $8b, $4e, $4d
        .byte $7f, $4b, $4d, $4e, $8f, $51, $54, $51
        .byte $4f, $4e, $08, $8f, $10, $08, $08, $8e
        .byte $10, $00

; letfa
tt_pattern16:
        .byte $8f, $10, $8f, $10, $8f, $10, $08, $08
        .byte $91, $10, $08, $91, $10, $9a, $08, $08
        .byte $08, $c8, $c0, $c1, $c2, $08, $08, $08
        .byte $e1, $10, $08, $08, $08, $08, $00

; leftb
tt_pattern17:
        .byte $b9, $08, $10, $08, $08, $08, $00

; Intro right
tt_pattern18:
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $00

; New pattern
tt_pattern19:
        .byte $cb, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $cd, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $cf, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $00

; right1
tt_pattern20:
        .byte $cb, $08, $08, $08, $08, $08, $08, $08
        .byte $11, $08, $08, $08, $cb, $08, $08, $08
        .byte $cd, $08, $08, $08, $08, $08, $08, $08
        .byte $11, $08, $08, $08, $cd, $08, $08, $08
        .byte $cf, $08, $08, $08, $08, $08, $08, $08
        .byte $11, $08, $08, $08, $08, $08, $08, $08
        .byte $cf, $08, $08, $08, $08, $08, $08, $08
        .byte $11, $08, $08, $08, $cd, $08, $08, $08
        .byte $00

; New pattern
tt_pattern21:
        .byte $b9, $10, $b9, $10, $11, $08, $b9, $10
        .byte $b9, $08, $ac, $10, $b9, $10, $12, $08
        .byte $b0, $10, $11, $08, $b9, $10, $af, $10
        .byte $b9, $10, $b9, $10, $ad, $10, $ac, $10
        .byte $00

; New pattern-
tt_pattern22:
        .byte $b9, $10, $b9, $10, $11, $08, $b9, $10
        .byte $b9, $08, $ac, $10, $b9, $10, $12, $08
        .byte $b0, $10, $11, $08, $b9, $10, $ad, $10
        .byte $b9, $10, $b9, $10, $af, $10, $b0, $10
        .byte $00

; right2
tt_pattern23:
        .byte $eb, $10, $08, $08, $e5, $10, $eb, $10
        .byte $08, $08, $eb, $10, $11, $08, $08, $08
        .byte $eb, $10, $08, $08, $e5, $10, $08, $08
        .byte $08, $08, $11, $08, $08, $08, $11, $08
        .byte $00

; right3
tt_pattern24:
        .byte $cb, $08, $08, $08, $08, $08, $08, $08
        .byte $08, $08, $08, $08, $08, $08, $08, $08
        .byte $c7, $08, $08, $08, $c8, $08, $ca, $08
        .byte $cb, $08, $08, $08, $cf, $08, $08, $08
        .byte $00

; rightx
tt_pattern25:
        .byte $3f, $4f, $54, $08, $10, $08, $00




; Individual pattern speeds (needs TT_GLOBAL_SPEED = 0).
; Each byte encodes the speed of one pattern in the order
; of the tt_PatternPtr tables below.
; If TT_USE_FUNKTEMPO is 1, then the low nibble encodes
; the even speed and the high nibble the odd speed.

.if TT_GLOBAL_SPEED = 0
tt_PatternSpeeds:
;%%PATTERNSPEEDS%%
.endif


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
        .byte $00, $00, $01, $02, $03, $04, $05, $06
        .byte $07, $06, $07, $08, $08, $09, $0a, $0b
        .byte $0c, $09, $0a, $0d, $0e, $0f, $0f, $0f
        .byte $10, $11, $99

        
        ; ---------- Channel 1 ----------
        .byte $12, $13, $13, $13, $14, $14, $14, $15
        .byte $16, $16, $15, $15, $16, $15, $16, $17
        .byte $17, $15, $16, $17, $17, $15, $18, $14
        .byte $13, $19, $b4


;        echo "Track size: ", *-tt_TrackDataStart
