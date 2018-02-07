;
; Counter.asm
;
; Created: 1/31/2018 3:58:32 PM
; Authors: Nichole Griffith and Nickolas Kruger
;

.include "tn45def.inc"
.cseg
.org 0

; 7-segment numbers in format 0b[G][F][E][D][C][B][A][DP]
; -A-
;F - B
; -G-
;E - C
; -D-

;numbers: .db 0b01111111, 0b00001101, 0b10110111, 0b10011111, 0b11001101, 0b11011011, 0b11111011, 0b00001111, 0b11111111, 0b11011111

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Pin Assignment Notes
; PB0: Shift Register Clock SCK (Pin 15)
; PB1: Serial In to Shift Register (Pin 2)
; PB2: Register Clock RCK (Pin 10)
; PB5: Input (push-button)

; Give registers more meaningful names
.def BCT     = r16
.def Counter = r17
.def OnCntr  = r18
.def OffCntr = r19
.def MODE    = r20 ; 1-dec, 0-inc
.def LED     = r21
.def TEMP    = r22
.equ CLK   = 0   ; PB0 = Shift Register Clock (Green)
.equ SERIN = 1	 ; PB1 = Serial Data (Yellow)
.equ LATCH = 2	 ; PB2 = Latch (Orange)
.equ BTTN  = 3   ; PB3 = Button (White)
; Note: PB5 is a lie!

; Configure pins
      sbi   DDRB,CLK      ; PB0 is now output                        [2 cycles]
	  sbi   DDRB,SERIN    ; PB1 is now output                        [2 cycles]
	  sbi   DDRB,LATCH    ; PB2 is now output                        [2 cycles]
	  cbi   DDRB,BTTN     ; PB3 is now input                         [2 cycles]

	  sbi PORTB,SERIN     ; Clear serial in
;FullClear:
;      rcall Clear
;      clr Counter
;	  rjmp Main

;Clear:
;      clr OnCntr
;	  clr OffCntr
;	  ret
;Prelim:
;	  ldi Counter,0b00001010

Start : ldi LED,0b00000000

Main:
      ;sbic PINB,BTTN
	  ;rjmp Main
	  ;cpi LED,0b11111111
	  ;breq Start
	  ;inc LED
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;; Super simple button sanity test ;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      sbic PINB,BTTN  ; Jump to main if button is not pushed
;	  rjmp Main
;	  cbi PORTB,SERIN ; Turn on LED
;	  sbis PINB,BTTN  ; Turn off LED if button is not pushed
;	  sbi PORTB,SERIN
;	  rjmp Main       ; Go to beginning of loop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      cbi PORTB,CLK
	  nop
	  sbi PORTB,CLK
	  nop
	  ;rcall delay_1sec
      cbi PORTB,SERIN
	  nop
	  sbi PORTB,LATCH
	  nop
	  cbi PORTB,LATCH
	  nop
	  ;sbi PORTB,CLK
	  ;nop
	  ;cbi PORTB,CLK
	  ;nop

      ;sbi PORTB,SERIN
	  ;nop
	  ;sbi PORTB,LATCH
	  ;nop
	  ;cbi PORTB,LATCH
	  ;nop
	  rcall delay_1sec
	  rcall delay_1sec
	  rcall delay_1sec
	  rjmp Main
	  ;dec Counter
	  ;cpi Counter,0b00000000
	  ;breq Prelim
	  ;mov LED,Counter
	  ;sbic  PINB,BTTN
	  ;rjmp  FullClear
	  ;
Initialize:
      ldi BCT,0b10000000

Push_Next:
      mov TEMP,LED
	  and BCT,TEMP
	  breq Zero
	  cbi PORTB,SERIN
	  rjmp Shift
Zero:
     sbi PORTB,SERIN
Shift:
	  ;clock pulse
	  sbi PORTB,CLK
	  nop
	  cbi PORTB,CLK
	  ; Clear carry flag (i.e. 0 goes into rotate)
	  clc
	  ; Rotate right
	  ror BCT
	  brne Push_Next
	  ; Latch
	  sbi PORTB,LATCH
	  nop
	  cbi PORTB,LATCH
	  rcall delay_1sec
	  rjmp Main

SEND_BYTE:
	ldi	BCT,0b10000000	; Set Bit counter

sr_write:
	rcall	SEND_BYTE	; Send byte to shift reg.
	reti			; return

;Zeroth:
;      rcall Button
;	  cpi   Counter,5
;	  brlo  Zeroth
;	  cp    OnCntr,OffCntr
;	  brlo  FullClear
;	  cbi   PORTB,1
	  ;
;	  rcall Clear
	  ;.
;First:             ; Check if t <= 1 sec
;	  rcall Button
;	  cpi   Counter,100
;	  brlo  First
;	  cp    OnCntr,OffCntr
;	  brlo  FullClear
;	  cbi   PORTB,2     ; Turn on first light if t <= 1 sec
	  ;
;	  clr OnCntr
;	  clr OffCntr
	  ;
;Second:             ; Check if 1 sec < t < 2 sec
;	  rcall Button
;	  cpi   Counter,200
;	  brlo  Second
;	  cp    OnCntr,OffCntr
;	  brlo  FullClear
;	  cbi   PORTB,5     ; Turn on second light if 1 sec < t < 2 sec
	  ;
;	  sbic  PINB,0      ; Check if button is still pushed
;	  rjmp FullClear

Button:
     inc Counter
     sbis  PINB,BTTN
     inc OnCntr
	 sbic  PINB,BTTN
	 inc OffCntr
	 rcall delay_10ms
     ret

;TurnOff:
;     sbi PORTB,1
;	  sbi PORTB,2
;	  ;sbi PORTB,5
;	  ret

;next_bit:
;     sbic
;decrement:
;      ; get the actual number
;      mov TEMP,LED
;	  sbci TEMP,1
;	  ror TEMP
;	  ; if 0, go to 9
;	  cpi TEMP,0b00000000
;	  brne overflow

;overflow:
;      mov TEMP,LED
	  



; delay for ~10ms
delay_10ms:          ;
      ldi   r23,134      ; r23 <-- Counter for outer loop            [1 cycle ]
 d01: ldi   r24,54       ; r24 <-- Counter for level 2 loop          [1 cycle ]
 d02: ldi   r25,2        ; r25 <-- Counter for inner loop            [1 cycle ]
 d03: dec   r25          ; decrement r25                             [1 cycle ]
      nop                ; no operation                              [1 cycle ]
	  brne  d03          ;                                           [1 cycle if 0, 2 cycles other]
      dec   r24          ;                                           [1 cycle ]
      brne  d02          ;                                           [1 cycle if 0, 2 cycles other]
      dec   r23          ;                                           [1 cycle ]
      brne  d01          ;                                           [1 cycle if 0, 2 cycles other]
      ret                ;                                           [4 cycles]

delay_1sec:          ;
      ldi   r23,199      ; r23 <-- Counter for outer loop            [1 cycle ]
  d1: ldi   r24,232     ; r24 <-- Counter for level 2 loop          [1 cycle ]
  d2: ldi   r25,43      ; r25 <-- Counter for inner loop            [1 cycle ]
  d3: dec   r25         ; decrement r25                             [1 cycle ]
      nop               ; no operation                              [1 cycle ]
	  brne  d3          ;                                           [1 cycle if 0, 2 cycles other]
      dec   r24         ;                                           [1 cycle ]
      brne  d2          ;                                           [1 cycle if 0, 2 cycles other]
      dec   r23         ;                                           [1 cycle ]
      brne  d1          ;                                           [1 cycle if 0, 2 cycles other]
      ret               ;                                           [4 cycles]
.exit