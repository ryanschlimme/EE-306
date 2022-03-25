; Ryan Schlimme
; 21 March 2022

; Lab 5

; This program prompts the user for a court number (max 7 uppercase and numeric characters) and searches a linked list of courses.
; If there is a match, it will print "<Course Number> is offered this semester!" and if there is not a match, it will print
; "<Course Number> is not offered this semester." Course numbers are formatted as follows: 1-3 uppercase letters, 3 digits,
; an optional uppercase letter, NO SPACES.

.ORIG x3000

; Prompt Algorithm
LEA R0, Prompt; Load and display prompt
PUTS
LEA R1, CODE;   Load address to store input
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
ADD R1, R1, #-1;Clear enter from memory
STR R2, R1, #0
; End of Prompt Algorithm

; Search/Compare Algorithm
LD R0, DATA;    Load first pointer
LDR R1, R0, #0; 
BRz NoMatch;    If the first pointer is null, there will never be a match
LDR R0, R1, #0; Otherwise, load the pointer to the first node
LEA R4, CODE;   Load the input data address
BRnzp NextNode; Go to the first node
Loop1
LDR R1, R0, #0; Load the node pointer
ADD R0, R0, #1; Load the address of the data
LDR R2, R0, #0
BRz NextNode;   If the address of the data is null, go to the next node
CompareLoop
LDR R3, R2, #0; Load the data element
LDR R5, R4, #0; Load the input element
BRz Match;      If the input element is zero, there is a match
NOT R5, R5;     Otherwise subtract
ADD R5, R5, #1
ADD R3, R3, R5
BRnp NextNode;  If the values are not the same, go to next node
ADD R4, R4, #1; Otherwise increment data and input addresses
ADD R2, R2, #1
BRnzp CompareLoop
Next
ADD R0, R0, #1
ADD R4, R4, #1
BRnzp Loop1
NextNode
LEA R4, CODE;   Reload the input data address
ADD R0, R1, #0; Copy R1 to R0
ADD R0, R0, #0
BRnp Loop1; 
BRz NoMatch;    If there is no data, 
; End of Search/Compare Algorithm

; Response Algorithm
; If there is a match
Match 
LEA R0, CODE;   Load and display the input
PUTS
LEA R0, YesResponse; Load and display the YesResponse
PUTS
BRnzp EndProgram;    End the program
; If there isn't a match
NoMatch
LEA R0, CODE;   Load and display the input
PUTS
LEA R0, NoResponse;  Load and display the NoResponse
PUTS
; End of Response Algorithm

EndProgram HALT

MASK .FILL xFF00
DATA .FILL x4000
Prompt .STRINGZ "Type Course Number and press Enter:"
YesResponse .STRINGZ " is offered this semester!"
NoResponse .STRINGZ " is not offered this semester."
CODE .BLKW #8

.END