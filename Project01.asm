TITLE Program #1     (program01.asm)

; Author: Meghan Dougherty
; Last Modified: 7/04/2018
; OSU email address: dougherm@oregonstate.edu
; Course number/section: CS271 sec. 400
; Assignment Number: 1                Due Date: 4/09/2018
; Description: A simple program that asks the user for two integers; calculates the sum, difference, product, quotient and remainder of those
; two numbers; then prints the results of those calculations. The program also validates that the second integer is less than the first as well
; as repeating until the user wishes to quit. 

INCLUDE Irvine32.inc



.data

; (insert variable definitions here)
project	BYTE		"	Elementary Arithmetic", 0
myname	BYTE		"	by Meghan Dougherty", 0
intro	BYTE		"Enter two numbers, and I'll show you the sum, difference, product, quotient, and remainder.", 0
ask_1	BYTE		"First Number: ", 0
ask_2	BYTE		"Second Number: ", 0
plus		BYTE		" + ", 0
minus	BYTE		" - ", 0
multiply	BYTE		" x ", 0
divide	BYTE		" / ", 0
remainder	BYTE		" remainder ", 0
equal	BYTE		" = ", 0
bye		BYTE		"Impressed? Goodbye!", 0

int_1	DWORD	?
int_2	DWORD	?
sum		DWORD	?
differ	DWORD	?
product	DWORD	?
quotient	DWORD	?
modulus	DWORD	?

cred1dec	BYTE		"**EC: Program verifies that the 2nd integer is less than the first.", 0
cred1	BYTE		"The second number must be less than the first.", 0
cred3dec	BYTE		"**EC: Program repeats until user wants to quit.", 0
cred3	BYTE		"Would you like to restart? If yes, enter 0, if no enter 1 ", 0 

.code
main PROC

;Introduce the program and state the extra credit attempts.
	mov	edx, OFFSET project
	call	WriteString

	mov	edx, OFFSET myname
	call	WriteString
	call	Crlf
	
	mov	edx, OFFSET cred1dec
	call	WriteString
	call	Crlf

	mov	edx, OFFSET cred3dec
	call	WriteString
	call	Crlf
	call	Crlf

	mov	edx, OFFSET intro
	call	WriteString
	call	Crlf
	call	Crlf

;ask for the numbers
top:
	mov	edx, OFFSET ask_1
	call	WriteString
	call	ReadInt
	mov	int_1, eax

	mov	edx, OFFSET ask_2
	call	WriteString
	call	ReadInt
	mov	int_2, eax
	call	Crlf

; Compare the numbers to see if one is less than the other or if the second number is 0
	mov	eax, int_1
	cmp	eax, int_2
	
	jl	error1
	jmp	continue

;prints error message if the first number is less than the second, then asks if the user wants to retry the program. 
error1:
	mov	edx, OFFSET cred1
	call	WriteString
	call	Crlf
	jmp	tryagain

continue:

; calculate sum
	mov	eax, int_1
	add	eax, int_2
	mov	sum, eax

; calculate difference
	mov	eax, int_1
	sub	eax, int_2
	mov	differ, eax

; calculate product
	mov	eax, int_1
	mov	ebx,	int_2
	mul	ebx
	mov	product, eax

; calculate quotient and remainder
	mov	eax, int_1
	mov	ebx,	int_2
	div	ebx
	mov	quotient, eax
	mov	modulus, edx

; output sum
	mov	eax, int_1
	call	WriteDec

	mov	edx, OFFSET plus
	call	WriteString

	mov	eax, int_2
	call	WriteDec

	mov	edx, OFFSET equal
	call	WriteString

	mov	eax, sum
	call	WriteDec
	call	Crlf

; output difference
	mov	eax, int_1
	call	WriteDec

	mov	edx, OFFSET minus
	call	WriteString

	mov	eax, int_2
	call	WriteDec

	mov	edx, OFFSET equal
	call	WriteString

	mov	eax, differ
	call	WriteDec
	call	Crlf

; output product
	mov	eax, int_1
	call	WriteDec

	mov	edx, OFFSET multiply
	call	WriteString

	mov	eax, int_2
	call	WriteDec

	mov	edx, OFFSET equal
	call	WriteString

	mov	eax, product
	call	WriteDec
	call	Crlf

; output quotient
	mov	eax, int_1
	call	WriteDec

	mov	edx, OFFSET divide
	call	WriteString

	mov	eax, int_2
	call	WriteDec

	mov	edx, OFFSET equal
	call	WriteString

	mov	eax, quotient
	call	WriteDec
	
	mov	edx, OFFSET remainder
	call	WriteString

	mov	eax, modulus
	call	WriteDec
	call	Crlf
	call	Crlf

; Extra Credit 3, loop back to top 

tryagain:
	mov	edx, OFFSET cred3
	call	WriteString
	call	ReadInt
	call	Crlf
	
	cmp	eax, 0
	jz	top
	cmp	eax, 1
	je	gbye
	jmp	tryagain

; Say goodbye
gbye:
	mov	edx,OFFSET bye
	call	WriteString
	call	Crlf
	
; exit to operating system
	exit	

main ENDP
	
END main
