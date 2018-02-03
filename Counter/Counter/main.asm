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
      sbi   DDRB,0      ; PB1 is now output                        [2 cycles]
      sbi   DDRB,1      ; PB2 is now output                        [2 cycles]
	  sbi   DDRB,2      ; PB3 is now output                        [2 cycles]
	  cbi   DDRB,5      ; PB5 is now input                         [2 cycles]

; Give registers more meaningful names
.def OutputRegister = r16

clr OutputRegister

; Skip next instruction 
sbic