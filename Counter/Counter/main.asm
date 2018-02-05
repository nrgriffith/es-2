;
; Counter.asm
;
; Created: 1/31/2018 3:58:32 PM
; Authors: Nichole Griffith and Nickolas Kruger
;

.include "tn45def.inc"
.cseg
.org 0

; 7-segment numbers in format 0b[G][F][E][D][A][B][C][DP]
; -A-
;F - B
; -G-
;E - C
; -D-

;numbers: .db 0b01111110, 0b00000110, 0b10111100, 0b10011110, 0b11000110, 0b11011010, 0b11111010, 0b00001110, 0b11111110, 0b11011110

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Pin Assignment Notes
; PB0: Shift Register Clock SCK (Pin 15)
; PB1: Serial In to Shift Register (Pin 2)
; PB2: Register Clock RCK (Pin 10)
; PB5: Input (push-button)

; Configure PB1, PB2, and PB3 as output pins, and PB5 as input
      sbi   DDRB,1      ; PB1 is now output                        [2 cycles]
	  sbi   DDRB,2      ; PB2 is now output                        [2 cycles]
	  sbi   DDRB,5      ; PB5 is now output                        [2 cycles]
	  cbi   DDRB,0      ; PB0 is now input                         [2 cycles]

; Give registers more meaningful names
;.def OutputRegister = r16
;clr OutputRegister
.def Counter = r17
.def OnCntr  = r18
.def OffCntr = r19

FullClear:
      rcall Clear
      clr Counter
	  rjmp Main

Clear:
      clr OnCntr
	  clr OffCntr
	  ret

Main:
	  rcall TurnOff
	  sbic  PINB,0
	  rjmp  FullClear
	  ;
Zeroth:
      rcall Button
	  cpi   Counter,5
	  brlo  Zeroth
	  cp    OnCntr,OffCntr
	  brlo  FullClear
	  cbi   PORTB,1
	  ;
	  rcall Clear
	  ;.
First:             ; Check if t <= 1 sec
	  rcall Button
	  cpi   Counter,100
	  brlo  First
	  cp    OnCntr,OffCntr
	  brlo  FullClear
	  cbi   PORTB,2     ; Turn on first light if t <= 1 sec
	  ;
	  clr OnCntr
	  clr OffCntr
	  ;
Second:             ; Check if 1 sec < t < 2 sec
	  rcall Button
	  cpi   Counter,200
	  brlo  Second
	  cp    OnCntr,OffCntr
	  brlo  FullClear
	  cbi   PORTB,5     ; Turn on second light if 1 sec < t < 2 sec
	  ;
	  sbic  PINB,0      ; Check if button is still pushed
	  rjmp FullClear
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	  ; delay to see light
	  clr Counter
Third:
      inc   Counter
	  rcall delay_long
	  cpi   Counter,100
	  brlo Third
      ;
	  rjmp FullClear
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Button:
      inc Counter
      sbis  PINB,0
	  inc OnCntr
	  sbic  PINB,0
	  inc OffCntr
	  rcall delay_long
	  ret

TurnOff:
      sbi PORTB,1
	  sbi PORTB,2
	  ;sbi PORTB,5
	  ret

; delay for ~10ms
delay_long:          ;
      ldi   r23,11      ; r23 <-- Counter for outer loop            [1 cycle ]
  d1: ldi   r24,13     ; r24 <-- Counter for level 2 loop          [1 cycle ]
  d2: ldi   r25,174      ; r25 <-- Counter for inner loop            [1 cycle ]
  d3: dec   r25         ; decrement r25                             [1 cycle ]
      nop               ; no operation                              [1 cycle ]
	  brne  d3          ;                                           [1 cycle if 0, 2 cycles other]
      dec   r24         ;                                           [1 cycle ]
      brne  d2          ;                                           [1 cycle if 0, 2 cycles other]
      dec   r23         ;                                           [1 cycle ]
      brne  d1          ;                                           [1 cycle if 0, 2 cycles other]
      ret               ;                                           [4 cycles]
.exit