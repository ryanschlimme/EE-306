; Ryan Schlimme
; 14 March 2022

; Lab 3
; This program takes an array of unsigned integer data starting at M[x4000] and organizes it in ascending order by bits [15:8] while carrying data from bits [7:0].

.ORIG x3000

LD R0, NUM1;        Load R0/R1 with first two values
LD R1, NUM2
LDR R2, R0, #0
LDR R3, R1, #0
LD R6, MASK;        Load R6 with mask to start isolating bits [15:8]

AND R2, R2, R6;     Isolate bits [15:8] of the first number
BRz ENDProgram;     If the first value is the terminator, end the program
AND R3, R3, R6;     Otherwise, isolate bits [15:8] of the second number

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
    LD R6, MASK;    Load mask
    LDR R2, R0, #0; Load value 1
    AND R2, R2, R6; Isolate bits [15:8]
    BRz ReturnToStart; If zero, return to start
    BRp Continue2;  If positive continue
    LD R5, MASK2;   If negative, load mask to remove bit 15
    AND R2, R5, R2; Remove bit 15
Continue
    LDR R3, R1, #0; Load value 2
    AND R3, R6, R3
    BRz ReturnToStart
    BRp Switch;     If first entry negative and second positive, switch numbers, first must be larger unsigned
    AND R3, R5, R3
Continue2
    LDR R3, R1, #0; Load value 2
    AND R3, R6, R3
    BRz ReturnToStart
    BRp Continue3;  If both positive proceed to compare
    AND R3, R5, R3
Continue3
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
LoopStop

ENDProgram HALT

NUM1 .FILL x4000;   Memory location of first number
NUM2 .FILL x4001;   Memory location of first number to compare
MASK .FILL xFF00;   Bit mask to isolate bits [15:8]
MASK2 .FILL x7F00;  Bit mask to remove bit 15
.END