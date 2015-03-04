ADDI  R0, 2    ; ADDI R0<-2             R0=2
ADDI  R1, 1    ; ADDI R1<-1             R1=1
SW    R1, $0F  ; DataMem[0F] <- [R1]    DM[0F]=1
LW    R5, $0F  ; R5 <- DataMem[0F]      R5=1
ADD   R0, R5   ; ADD  R0<-R0 + R5       R0=3
AND   R0, R1   ; AND  R0<-R0 & R1       R0=1
OR    R0, R1   ; OR   R0<-R0 or R1      R0=1
ADD   R0, R1   ; ADD  R0<-R0 + R1       R0=2
MOV   R10, R1   ; R10 <- R1              R10=1
SL    R10, 3   ; R10 R10[23:3&000]      R10=8
SR    R10, 1   ; R10 [0& 22:0]          R10=4

;Expected output code
;5002
;5101
;A10F
;950F
;0050
;2010
;3010
;0010
;4A10
;7A03
;8A01

;Test each set
;ADD		R0, R1
;SUB		R2, R3
;AND		R4, R5
;OR		R6, R7
;MOV		R8, R9
;ADDI	R10, 80
;ANDI	R11, 120
;SL		R12, 4
;SR		R12, 4
;LW		R13, 444
;SW		R14, 8888


;test the wonders of ID and D reg type
;LWV		R0,	S0,	255	; B000FF
;SWV		R1,	S1,	256	; C14100
;LWVI	R2,	S2,	255	; B2A0FF
;LWVD	R3,	S3,	255	; B3D0FF
;LWVS	R4,	S0,	255	; B430FF
;NOP		R5,	S1,	255	; C570FF
;SWED	R6,	S2,	255	; C690FF
;SWEI	R7,	S3,	255	; C7E0FF

