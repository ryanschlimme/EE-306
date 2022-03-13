; Ryan Schlimme
; 13 March 2022

; Lab 3
; This program takes an array of data starting at M(x4000) and organizes it in ascending order by bits [15:8] while carrying data from bits [7:0].

.ORIG x3000

LD R0, NUM1
LD R1, NUM2
LDR R2, R0, #0
LDR R3, R1, #0
LD R6, MASK

AND R2, R2, R6
BRz ENDProgram
AND R3, R3, R6

LoopStart 
    NOT R4, R3
    ADD R4, R4, #1
    ADD R5, R4, R2
    BRnz NoAction
    LDR R2, R0, #0
    LDR R3, R1, #0
    STR R2, R0, #0
    STR R3, R1, #0
    NoAction
    ADD R0, R0, #1
    ADD R1, R1, #1
    LDR R2, R0, #0
    LDR R3, R1, #0
    AND R2, R2, R6
    AND R3, R3, R6
    BRnp LoopStart
LoopStop

ENDProgram HALT

NUM1 .FILL x4000
NUM2 .FILL x4001
MASK .FILL xFF00
.END