; Set of Data Hazard Tests for the RISC Pipeline Achitecture
; Each test is independent from each other
; At the end of each test one register will be a designated test output.

;========================================
;Test 1
;========================================

ADDI  R0, 11	; ADDI R0<-11		R0=11=x0B
ADDI  R1, 22	; ADDI R1<-22		R1=22=x16
ADD	  R0, R1	; ADD  R0<-R0 + R1	R0=33=x21
ADD	  R1, R0	; ADD  R1<-R1 + R0	R1=55=x37
ADD	  R0, R1	; ADD  R0<-R0 + R1	R0=88=x58
ADD	  R1, R0	; ADD  R1<-R1 + R0	R1=143=x8F
MOV   R0, R1	; MOV  R0<-R1		R0=143=x8F

;Register 0 should be 143 = x8F

;========================================
;Test 2
;========================================

ADDI  R1, 42	; ADDI R1<-40		R1=40=x28
ADDI  R2, 88	; ADDI R2<-88		R2=88=x58
SUB   R2, R1	; SUB  R2<-R2-R1	R2=48=x30
AND   R2, R1	; AND  R2<-R2&R1	R2=32=x20
MOV   R1, R2	; MOV  R1<-R2		R0=32=x20


;Register 1 should be 32 = x20

;========================================
;Test 3
;========================================

ADDI  R2, 10	; ADDI R2<-10		R2=10=x0A
ADDI  R3, 127	; ADDI R3<-127		R3=127=x7F
ADD   R2, R3	; ADD R2<-R2+R3		R2=137=x89
AND   R3, R2	; AND R3<-R3&R2		R3=9=x09
SUB   R3, R2	; SUB R3<-R3-R2		R3=128=x80
OR    R3, R2	; OR R3<-R3|R2		R3=137=x89
ADD   R2, R3	; ADD R2<-R2+R3		R2=18=x12
OR	  R2, R3	; OR R2<-R2|R3		R2=155=x9B

;Register 2 should be 155 = x9B

;========================================
;Test 4
;========================================

ADDI  R3, 45	; ADDI R3<-45		R3=45=x2D
SW    R3, 2		; SW MEM[2] <-45	MEM[2]=45
AND   R3, R4	; AND R3<-R3&R4		R3=0
LW    R3, 2		; LW R3 <- MEM[2]	R3=45=x2D
SUB   R4, R3	; SUB R4<-R4-R3		R4=211=D3
AND   R4, R3	; AND R4<-R4&R3		R4=1
AND	  R3, R4	; OR R3<-R3&R4		R3=1

;Register 3 should be 1


