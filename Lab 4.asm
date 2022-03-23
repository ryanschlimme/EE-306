; Ryan Schlimme
; 21 March 2022

; Lab 4

; This program takes an array of unsigned integer data starting at M[x4000] and organizes it in ascending order by bits [7:0] while carrying 
; data from bits [15:8]. Then, it will calculate the mean of bits [7:0] of the elements in the array and store the in M[x5005]. Then, it will
; calculate the range and store it in M[x5004] where [15:8] represents the highest value and [7:0] the lowest value. Next, it will produce a 
; table representing the number of values [7:0] which are 0-25, 26-50, 51-100, and >100, in consecutive memory locations starting at x5000. 
; Bits [15:8] of each memory location will contain the ASCII codes for S, M, L, and H respectively. 

.ORIG x3000

; Bubble Sort Algorithm
LD R0, NUM1;        Load R0/R1 with first two values
LD R1, NUM2
LDR R2, R0, #0
LDR R3, R1, #0
LD R6, MASK3;       Load R6 with mask to start isolating bits [15:8]
AND R2, R2, R6;     Isolate bits [15:8] of the first number
BRz MEANAlg
AND R7, R7, #0;     Initialize our counter register
; Count total entries in array
LD R0, NUM1;        Load R0/R1 with first two values
LD R1, NUM2
LDR R2, R0, #0
LDR R3, R1, #0
AND R7, R7, #0;     Initalize our counter register
CountLoop;          Count total entries in array
    LDR R2, R0, #0; Load entry
    AND R2, R2, R6; Check if entry is terminator
    BRz CountStop;  If zero, stop counting
    ADD R7, R7, #1; If not, increment counter
    ADD R0, R0, #1; Increment pointer
    BRnzp CountLoop;Start again
CountStop

LD R0, NUM1;        Reload R0 with x4000

LoopStart 
    LD R6, MASK3;    Load mask
    LDR R2, R0, #0; Load value 1
    AND R2, R2, R6; Isolate bits [15:8]
    BRz ReturnToStart; If zero, return to start
    LD R5, MASK;   Otherwise, load mask
    LDR R2, R0, #0
    AND R2, R5, R2
    LDR R3, R1, #0; Load value 2
    AND R3, R6, R3
    BRz ReturnToStart
    LDR R3, R1, #0
    AND R3, R5, R3
    NOT R4, R3;     Value 2 - Value 1
    ADD R4, R4, #1
    ADD R5, R4, R2
    BRnz NoAction;  If value is negative or zero, do not swap the numbers
Switch
    LDR R2, R0, #0; Load initial values
    LDR R3, R1, #0
    STR R2, R1, #0; Store initial values in opposite memory locations
    STR R3, R0, #0
NoAction
    ADD R0, R0, #1; Increment R0 and R1 to check current second value and the next
    ADD R1, R1, #1
    BRnp LoopStart
ReturnToStart
LD R0, NUM1;        Return R0 to x4000
LD R1, NUM2;        Return R1 to x4001
ADD R7, R7, #-1;    Decrement R7
BRnp LoopStart;     Start Loop again
; End of Bubble Sourt Algorithm

; Mean Algorithm CREATING ALL ZERO'S!!!!!!!!!!!!!!!!
MEANAlg LD R0, NUM1
LD R2, MEAN
LD R6, MASK
LD R5, MASK3
LDR R1, R0, #0
AND R1, R1, R5
BRz ZERO2
AND R7, R7, #0
AND R3, R3, #0
Count2
    LDR R1, R0, #0;   Load entry
    AND R1, R1, R5;   Check if entry is terminator
    BRz Stop2;   If zero, stop counting
    ADD R7, R7, #1;   If not, increment counter
    LDR R1, R0, #0
    AND R1, R6, R1;     
    ADD R0, R0, #1;   Increment pointer
    ADD R3, R1, R3;   Add number to final value
    BRnzp Count2; Start again
Stop2
; Divide R3 by R7
AND R6, R6, #0; Initialize a counter register
NOT R5, R7
ADD R5, R5, #1
DivideLoop
    ADD R6, R6, #1
    ADD R7, R5, R3
    BRnz DivideStop
    ADD R3, R5, R3
    BRnzp DivideLoop
DivideStop
STR R6, R2, #0
BRnzp RANGEAlg

ZERO2
AND R1, R1, #0
ADD R1, R1, #-1
STR R1, R2, #0
LD R2, RNG
STR R1, R2, #0
LD R0, VAL
LD R1, S
STR R1, R0, #0
ADD R0, R0, #1
LD R1, M
STR R1, R0, #0
ADD R0, R0, #1
LD R1, L
STR R1, R0, #0
ADD R0, R0, #1
LD R1, H
STR R1, R0, #0
BRnzp ENDProgram

; End of Mean Algorthm

; Range Algorithm
; Store Lowest Number
RANGEAlg LD R0, NUM1
LD R6, MASK3
LD R5, MASK
LD R2, RNG
LDR R1, R0, #0
AND R1, R1, R5
STR R1, R2, #0
; Store Largest Number
Count
    LDR R1, R0, #0
    AND R1, R1, R6; Check if entry is terminator
    BRz Load0;  If zero, stop counting
    ADD R0, R0, #1; Increment pointer
    BRnzp Count;Start again
Load0
LDR R3, R2, #0
ADD R0, R0, #-1
LDR R1, R0, #0
AND R1, R1, R5
; Left shift R1 by 8 bits
AND R7, R7, #0
ADD R7, R7, #-8; Initialize counter register
ShiftLoop
    ADD R1, R1, R1
    ADD R7, R7, #1
    BRn ShiftLoop
ADD R1, R1, R3
STR R1, R2, #0
BRnp TABLE
; End of Range Algorithm

; Table Algoritm
TABLE 
; Duplicate the array
LD R0, NUM1
LD R1, DST
LD R3, MASK
LD R4, MASK3
Duplicate
LDR R2, R0, #0
AND R2, R2, R4
BRz NEXT
LDR R2, R0, #0
AND R2, R2, R3
STR R2, R1, #0
ADD R0, R0, #1
ADD R1, R1, #1
BRnzp Duplicate
NEXT
AND R2, R2, R3
STR R2, R1, #0

; Subtract 25 from each value, increment a counter. If positive, ignore. Otherwise, store original value to memory

AND R4, R4, #0
AND R5, R5, #0
AND R6, R6, #0
AND R3, R3, #0

LD R0, DST

CompareStart
    LDR R1, R0, #0
    BRz STOPCompare
    LD R2, n25
    ADD R2, R2, R1
    BRp Compare50
    ADD R4, R4, #1
    ADD R0, R0, #1
    BRnzp CompareStart
Compare50
    LD R2, n50
    ADD R2, R2, R1
    BRp Compare100
    ADD R5, R5, #1
    ADD R0, R0, #1
    BRnzp CompareStart
Compare100
    LD R2, n100
    ADD R2, R2, R1
    BRp Greater100
    ADD R6, R6, #1
    ADD R0, R0, #1
    BRnzp CompareStart
Greater100
    ADD R3, R3, #1
    ADD R0, R0, #1
    BRnzp CompareStart
STOPCompare
LD R0, VAL
LD R1, S
ADD R4, R1, R4
STR R4, R0, #0
ADD R0, R0, #1

LD R1, M
ADD R5, R1, R5
STR R5, R0, #0
ADD R0, R0, #1

LD R1, L
ADD R6, R1, R6
STR R6, R0, #0
ADD R0, R0, #1

LD R1, H
ADD R3, R1, R3
STR R3, R0, #0


ENDProgram HALT

NUM1 .FILL x4000;   Memory location of first number
NUM2 .FILL x4001;   Memory location of first number to compare
MASK .FILL x00FF;   Bit mask to isolate bits [7:0]
MASK2 .FILL x7FFF
MASK3 .FILL xFF00;  Bit mask to check for sentinel

VAL  .FILL x5000;   
RNG  .FILL x5004;   Memory location of range
MEAN .FILL x5005;   Memory location of mean

S    .FILL x5300;   ASCII codes for S, M, L, H 
M    .FILL x4D00
L    .FILL x4C00
H    .FILL x4800

DST  .FILL x3500

n25   .FILL #-25
n50   .FILL #-50
n100  .FILL #-100
n101  .FILL #-101

.END