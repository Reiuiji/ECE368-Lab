;Adding Test
;Does this work? Go try it out
;Each instruction will run different based on your hardware design.
;Hint: ADDI will add R0 and a immediate value so it might be a little off.
;Hint: Play with ANDI and fill in what is needed
ADDI  R0, $90    ; ADDI R0<-90            R0=90
ADDI  R1, $25    ; ADDI R1<-25            R1=20
ADD	  R1, R0     ; 0x90 + 0x25 => 0xB5    CCR: N
ADDI  R1, $66    ; ADDI R1<-66            R1=66
ADD	  R1, R0     ; 0x90 + 0x66 => 0x1B    CCR: C
ADDI  R1, $E5    ; ADDI R1<-E5            R1=E5
ADD	  R1, R0     ; 0x1B + 0xE5 => 0x00    CCR: C,Z
