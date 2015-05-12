; Set of Data Hazard Tests for the RISC Pipeline Achitecture
; Each test is independent from each other
; At the end of each test one register will be a designated test output.

;========================================
;Test 1
;========================================

ADDI  R0, 0B	; R0=0x0B
ADDI  R1, 16	; R1=0x16
ADD	  R0, R1	; R0=0x21
ADD	  R1, R0	; R1=0x37
ADD	  R0, R1	; R0=0x58
ADD	  R1, R0	; R1=0x8F
MOV   R0, R1	; R0=0x8F

;Register 0 should be 0x8F

;========================================
;Test 2
;========================================

ANDI  R1, 00    ; R1=0x00
ADDI  R1, 28	; R1=0x28
ADDI  R2, 58	; R2=0x58
SUB   R2, R1	; R2=x30
AND   R2, R1	; R2=x20
MOV   R1, R2	; R1=x20


;Register 1 should be 0x20

;========================================
;Test 3
;========================================

ANDI  R2, 00    ; R2=0x00
ADDI  R2, 0A	; R2=0x0A
ADDI  R3, 7F	; R3=0x7F
ADD   R2, R3	; R2=0x89
AND   R3, R2	; R3=0x09
SUB   R3, R2	; R3=0x80
OR    R3, R2	; R3=0x89
ADD   R2, R3	; R2=0x12
OR	  R2, R3	; R2=0x9B

;Register 2 should be 0x9B

;========================================
;Test 4
;========================================

ANDI  R3, 00    ; R3=0x00
ADDI  R3, 2D	; R3=0x2D
SW    R3, 2		; MEM[2]=0x2D
AND   R3, R4	; R3=0x00
LW    R3, 2		; R3=0x2D
SUB   R4, R3	; R4=0xD3
AND   R4, R3	; R4=0x01
AND	  R3, R4	; R3=0x01

;Register 3 should be 0x01


