; Ryan Schlimme
; 04 March 2022

; This program takes two 8-bit numbers stored in x4000. Bits [15:8] are Number 1
; and bits [7:0] are Number 2. It stores the smaller of the two numbers in x4001.

.ORIG x3000;        start the program at x3000

; Load the bit vector and masks
LDI R0, MAIN;       place the one-word bit vector into R0
LDI R1, MAIN;       place the one-word bit vector into R1
LD R2, MASK1;       place the first mask into R2
LD R3, MASK2;       place the second mask into R3

; Isolate the most and least significant 8 bits
AND R0, R2, R0;     AND the number with MASK1, result is 8 most significant bits
STI R0, DST1;       store number one into x4002
AND R1, R3, R1;     AND the number with MASK2, result is 8 least significant bits

; Right shift the most significant 8 bits
ADD R0, R1, #0;     copy R1 to R0
LD R2, SRCMask;     place the source mask into R2
LD R3, DSTMask;     place the destination mask into R3
    AND R4, R1, R2; inspect bit k using the source mask
    BRz #1;         if bit k=0, skip to left-shifting masks
    ADD R1, R1, R3; otherwise, add the destination mask to our number
    ADD R3, R3, R3; left-shift DSTMask
    ADD R2, R2, R2; left-shift SRCMask
    BRnp #-6;       unless R2 turns to 0, repeat the loop from line 20
NOT R0, R0;         one's complement our original number
ADD R0, R0, #1;     two's complement our original number
ADD R1, R1, R0;     add our loop result to the two's complement original number
STI R1, DST2;       resultant right shifted number stored into x4003

; Logic to determine which is larger
LDI R0, DST1;       Load first number into R0 (bits 7:0 of the original vector)
LDI R1, DST2;       Load second number into R1 (bits 15:8 of the original vector)
NOT R2, R1;         One's complement the second number
ADD R2, R2, #1;     two's complement the second number
ADD R2, R2, R0;     Add the first number and two's complemented second number

; Store final answer to memory
BRnz #2;            if the value of R2 is negative or 0, skip to store R0
STI R1, DST;        if the value of R2 is positive, store R1 to the final destination 
BRp #1;             if the value of R2 is positive, proceed to HALT
STI R0, DST

HALT
MAIN .FILL x4000;   address for original bit vector representing two unsigned integers
MASK1 .FILL x00FF;  masks the most significant 8 bits
MASK2 .FILL xFF00;  masks the least significant 8 bits
SRCMask .FILL x0100;allows us to start testing at bit 8
DSTMask .FILL x0001;allows us to start settting bits at bit 0
DST .FILL x4001;    final destination of the smallest number (even if they are equal)
DST1 .FILL x4002;   intermediate destination for the least significant 8 bits
DST2 .FILL x4003;   intermediate destination for the right-shifted most significant 8 bits
.END