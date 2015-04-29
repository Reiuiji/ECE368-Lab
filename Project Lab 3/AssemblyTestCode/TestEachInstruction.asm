; Set of Tests for the RISC Pipeline Achitecture
; Test each available instruction

;========================================
;INIT
;========================================

ADDI  R0, 0B	; ADDI R0<-11		R0=11
ADDI  R1, 16	; ADDI R1<-22		R1=22
ADDI  R2, 21	; ADDI R2<-33		R2=33
ADDI  R3, 2C	; ADDI R3<-44		R3=44
ADDI  R4, 37	; ADDI R3<-55		R3=55
ADDI  R5, 42	; ADDI R3<-66		R3=66
ADDI  R6, 4D	; ADDI R3<-77		R3=77
ADDI  R7, 58	; ADDI R3<-88		R3=88
ADDI  R8, 63	; ADDI R3<-99		R3=99
ADDI  R9, 6F	; ADDI R3<-111		R3=111
ADDI  R10, 7A	; ADDI R3<-122		R3=122
ADDI  R11, 85	; ADDI R3<-133		R3=133

;========================================
;Primary Instructions
;========================================
ADD   R0, R1	; R0 = 33
SUB   R1, R2	; R1 = 245
AND   R2, R3	; R2 = 32
OR    R3, R4	; R3 = 63
MOV   R4, R5	; R4 = 66
ADDI  R5, 42	; R5 = 132
ANDI  R6, 2D	; R6 = 13
SL    R7, 3		; R7 = 192
SR    R8, 3		; R8 = 12
LW    R9, 4		; MEM[4] = 111
SW    R10, 4	; R10= 111

;========================================
;Jump/Branch Instructions (PC at 22)
;========================================
JAL   R0, 28 ; D028 : Leave R0 for it to assemble properly
SUB   R11, R1
SUB   R11, R2
BRA   0, 34
SUB   R11, R3
SUB   R11, R4
ADD   R11, R5 ; JAL Jump here
ADD   R11, R6
ADD   R11, R7
ADD   R11, R8
RTL   R0, 0  ;E000 : leave R0 and 0 for it to assemble properly
SUB   R11, R9
SUB   R11, R10 ; BRA Jump Here

; R11 = 31

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
