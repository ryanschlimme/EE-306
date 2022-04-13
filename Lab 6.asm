; Ryan Schlimme
; 06 April 2022

; Lab 6
; This program prompts the user for a court number (max 7 uppercase and numeric characters) and searches two linked lists of courses.
; If there is a match in the first list, it will print "<Course Number> is already being offered this semester." and if there is 
; a match in the second list, it will add the course number to the first list and print, "<Course Number> has been added to this 
; semester's course offerings." If there is not a match in either, it will print "The entered Course Number does not exist in the
; current course catalog." Course numbers are formatted as follows: 1-3 uppercase letters, 3 digits, an optional uppercase letter, 
; NO SPACES.

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

; Search/Compare Algorithm 1
LD R0, DATA
LDR R1, R0, #0
BRz NoMatch
LDR R0, R1, #0
LEA R4, CODE
BRnzp NextNode
Loop1
LDR R1, R0, #0
LDR R2, R0, #1
BRz NextNode
CompareLoop
LDR R3, R2, #0
BRnp Fail1
LDR R5, R4, #0
BRz Match2
Fail1 
LDR R5, R4, #0
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
; End of Search/Compare Algorithm `

; Search/Compare Algorithm 2
NoMatch
AND R6, R6, #0; Initialize a counter register
LD R0, DATA
ADD R0, R0, #1; Increment to course catalog list
LDR R1, R0, #0
BRz NoMatch2
BRnp NextNode2
Loop2
LDR R1, R0, #0
LDR R2, R0, #1
BRz NextNode2
CompareLoop2
LDR R3, R2, #0
BRnp Fail2
LDR R5, R4, #0
BRz Match2
Fail2 
LDR R5, R4, #0
NOT R5, R5
ADD R5, R5, #1
ADD R3, R3, R5
BRnp NextNode2
ADD R4, R4, #1
ADD R2, R2, #1
BRnzp CompareLoop2
Next2
ADD R0, R0, #1
ADD R4, R4, #1
BRnzp Loop2
NextNode2
LEA R4, CODE
ADD R6, R0, #0
ADD R0, R1, #0
BRnp Loop2
BRz NoMatch2
; End of Search Compare/Algorithm 2

; Response Algorithm
; If there is a match in search 1
Match 
ADD R5, R5, #0
BRnp NoMatch
LEA R0, CODE
PUTS
LEA R0, YesResponse
PUTS
BRnzp EndProgram
; If there is a match in search 2
Match2

; NODE DELETION
LDR R3, R0, #0
STR R3, R6, #0

; NODE INSERTION
LD R1, DATA
LDR R1, R1, #0
STR R1, R0, #0
LD R1, DATA
STR R0, R1, #0

LEA R0, CODE
PUTS
LEA R0, Yes2Response
PUTS
BRnzp ENDProgram
; If there is not a match in either
NoMatch2
LEA R0, NoMatchResponse
PUTS
BRnzp EndProgram
; End of Response Algorithm

EndProgram HALT

DATA .FILL x4000
NextDATA .FILL x4001
CODE .BLKW #8
Prompt .STRINGZ "Type Course Number and press Enter: "
YesResponse .STRINGZ " is already being offered this semester."
Yes2Response .STRINGZ " has been added to this semester's course offerings."
NoMatchResponse .STRINGZ "The entered Course Number does not exist in the current course catalog."


.END