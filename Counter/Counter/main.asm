;
; Counter.asm
;
; Created: 1/31/2018 3:58:32 PM
; Authors: Nichole Griffith and Nickolas Kruger
;

.include "tn45def.inc"
.cseg
.org 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Pin Assignment Notes
; PB0: Shift Register Clock SCK (Pin 15)
; PB1: Serial In to Shift Register (Pin 2)
; PB2: Register Clock RCK (Pin 10)
; PB5: Input (push-button)

; Configure PB1, PB2, and PB3 as output pins, and PB5 as input
      ;sbi   DDRB,0      ; PB1 is now output                        [2 cycles]
      sbi   DDRB,1      ; PB2 is now output                        [2 cycles]
	  sbi   DDRB,2      ; PB3 is now output                        [2 cycles]
	  cbi   DDRB,0      ; PB5 is now input                         [2 cycles]

	  ;sbi   PORTB,0
	  sbi   PORTB,1
	  sbi   PORTB,2

; Give registers more meaningful names
;.def OutputRegister = r16
;clr OutputRegister
.def Counter = r17
clr Counter

Main:
      ; turn on LED 1, turn off LED 2
	  clr Counter
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
	  cpi Counter,30
      brge TurnOn
	  ;
Next:
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
      sbis  PINB,0
	  inc Counter
	  sbis  PINB,0
	  rcall delay_long
	  ;
	  cpi Counter,5
      brge TurnOnTwo
	  ;
	  rjmp TurnOff
	  rjmp Main

TurnOff:
      sbi PORTB,1
	  sbi PORTB,2
	  rjmp Main

TurnOn:
      cbi PORTB,1
	  rjmp Next

TurnOnTwo:
      cbi PORTB,2
	  rjmp Main

; delay for ~10ms
delay_long:          ;
      ldi   r23,54      ; r23 <-- Counter for outer loop            [1 cycle ]
  d1: ldi   r24,2     ; r24 <-- Counter for level 2 loop          [1 cycle ]
  d2: ldi   r25,22      ; r25 <-- Counter for inner loop            [1 cycle ]
  d3: dec   r25         ; decrement r25                             [1 cycle ]
      nop               ; no operation                              [1 cycle ]
	  brne  d3          ;                                           [1 cycle if 0, 2 cycles other]
      dec   r24         ;                                           [1 cycle ]
      brne  d2          ;                                           [1 cycle if 0, 2 cycles other]
      dec   r23         ;                                           [1 cycle ]
      brne  d1          ;                                           [1 cycle if 0, 2 cycles other]
      ret               ;                                           [4 cycles]
.exit