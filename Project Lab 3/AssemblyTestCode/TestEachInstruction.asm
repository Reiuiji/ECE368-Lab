; Set of Tests for the RISC Pipeline Achitecture
; Test each available instruction

;========================================
;INIT
;========================================

ADDI  R0, 0B	; R0=0x0B
ADDI  R1, 16	; R1=0x16
ADDI  R2, 21	; R2=0x21
ADDI  R3, 2C	; R3=0x2c
ADDI  R4, 37	; R4=0x37
ADDI  R5, 42	; R5=0x42
ADDI  R6, 4D	; R6=0x4D
ADDI  R7, 58	; R7=0x58
ADDI  R8, 63	; R8=0x63
ADDI  R9, 6F	; R9=0x6F
ADDI  R10, 7A	; R10=0x7A
ADDI  R11, 85	; R11=0x85

;========================================
;Primary Instructions
;========================================
ADD   R0, R1	; R0 = 0x21
SUB   R1, R2	; R1 = 0xF4
AND   R2, R3	; R2 = 0x20
OR    R3, R4	; R3 = 0x3F
MOV   R4, R5	; R4 = 0x42
ADDI  R5, 42	; R5 = 0x84
ANDI  R6, 2D	; R6 = 0x0D
SL    R7, 3		; R7 = 0xC0
SR    R8, 3		; R8 = 0x0C
LW    R9, 4		; MEM[4] = 0x6F
SW    R10, 4	; R10= 0x6F

;========================================
;Jump/Branch Instructions (PC at 23)
;========================================
JAL   R0, 06 ; D006 : Leave R0 for it to assemble properly
SUB   R11, R1 ; R11 = 0x44
SUB   R11, R2 ; R11 = 0x24
BRA   0, 9
SUB   R11, R3 ; R11 = 0x
SUB   R11, R4
ADD   R11, R5 ; R11 = 0x09   ; JAL Jump here
ADD   R11, R6 ; R11 = 0x16
ADD   R11, R7 ; R11 = 0xD6
ADD   R11, R8 ; R11 = 0x39
RTL   R0, 0  ;E000 : leave R0 and 0 for it to assemble properly
SUB   R11, R9
SUB   R11, R10 ; BRA Jump Here

; R11 = 0xB4

;========================================
;Special Instructions (Optional)
;========================================
;LWV		R0,	S0,	255	; B000FF
;SWV		R1,	S1,	256	; C14100
;LWVI	R2,	S2,	255	; B2A0FF
;LWVD	R3,	S3,	255	; B3D0FF
;LWVS	R4,	S0,	255	; B430FF
;SWED	R6,	S2,	255	; C690FF
;SWEI	R7,	S3,	255	; C7E0FF
