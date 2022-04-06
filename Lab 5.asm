; Ryan Schlimme
; 21 March 2022

; Lab 5

; This program prompts the user for a court number (max 7 uppercase and numeric characters) and searches a linked list of courses.
; If there is a match, it will print "<Course Number> is offered this semester!" and if there is not a match, it will print
; "<Course Number> is not offered this semester." Course numbers are formatted as follows: 1-3 uppercase letters, 3 digits,
; an optional uppercase letter, NO SPACES.

.ORIG x3000

; Prompt Algorithm
LEA R0, Prompt
PUTS
LEA R1, CODE
LoopStart
AND R2, R2, #0; Load a register with ASCII of enter key
ADD R2, R2, x0A
GETC;           Get a character and print to console
OUT
STR R0, R1, #0; Store character in memory
ADD R1, R1, #1; Increment memory pointer
NOT R0, R0;     Subtract key value from register with enter
ADD R0, R0, #1
ADD R2, R0, R2
BRnp LoopStart; If value is not enter, loop
; Clear enter from memory
ADD R1, R1, #-1
STR R2, R1, #0
; End of Prompt Algorithm

; Search/Compare Algorithm
LD R0, DATA
LDR R1, R0, #0
BRz NoMatch
LDR R0, R1, #0
LEA R4, CODE
BRnzp NextNode
Loop1
LDR R1, R0, #0
ADD R0, R0, #1
LDR R2, R0, #0
BRz NextNode
CompareLoop
LDR R3, R2, #0
LDR R5, R4, #0
BRz Match
NOT R5, R5
ADD R5, R5, #1
ADD R3, R3, R5
BRnp NextNode
ADD R4, R4, #1
ADD R2, R2, #1
BRnzp CompareLoop
Next
ADD R0, R0, #1
ADD R4, R4, #1
BRnzp Loop1
NextNode
LEA R4, CODE
ADD R0, R1, #0
ADD R0, R0, #0
BRnp Loop1
BRz NoMatch
; End of Search/Compare Algorithm

; Response Algorithm
; If there is a match
Match 
LEA R0, CODE
PUTS
LEA R0, YesResponse
PUTS
BRnzp EndProgram
; If there isn't a match
NoMatch
LEA R0, CODE
PUTS
LEA R0, NoResponse
PUTS
; End of Response Algorithm

EndProgram HALT

MASK .FILL xFF00
DATA .FILL x4000
Prompt .STRINGZ "Type Course Number and press Enter: "
YesResponse .STRINGZ " is offered this semester!"
NoResponse .STRINGZ " is not offered this semester."
CODE .BLKW #8

.END