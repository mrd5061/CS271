TITLE Program 2     (Program02.asm)

; Author: Meghan Dougherty
; Last Modified: 7/10/2018
; OSU email address: dougherm@oregonstate.edu
; Course number/section: CS271 sec. 400
; Assignment Number: 2               Due Date: 7/16/2018
; Description: A program that computes and displays the fibonacci numbers from 0 to n, where n is a user specified integer. 

INCLUDE Irvine32.inc



.data

; Variable Definitions

project		BYTE		"Fibonacci Numbers", 0
myname		BYTE		"programmed by Meghan Dougherty", 0
askname		BYTE		"What's your name? ", 0
greet		BYTE		"Hello, ", 0
Fib1 		BYTE		"Next is the number of Fibonacci terms to be displayed.", 0
range		BYTE		"Please enter an integer in the range [1...46]", 0
howmany   	BYTE		"How many Fibonacci terms do you want?", 0
outrange		BYTE		"Out of range. Please enter an integer in the range [1...46] ", 0
again		BYTE		"Would you like to run the program again?" , 0
choice		BYTE		"Please Enter 1 for yes and 0 for no." , 0
error		BYTE		"Invalid Input." , 0
certified		BYTE		"Results certified by Meghan Dougherty", 0 
bye			BYTE		"Goodbye, ", 0

uname		BYTE		21 DUP(0)	; the user's name
unCount		DWORD	?		;length of the user's name

nthTerm		DWORD	?		;the amount of Fibonacci Numbers the user wants to display
Term1		DWORD	0		; 1st term used in calculations
Term2		DWORD	1		; 2nd term used in calculations
Result		DWORD	?		; Temporary holding term for calculation result
Position		DWORD	1		;The position of the displayed result in it's row. 

TAB = 9	;Horizontal Tab

; Extra Credit Declaration(s)
cred1dec		BYTE		"**EC: Program prints the numbers in aligned columns.", 0

.code
main PROC

;Introduce the program and state the extra credit attempts.
	mov	al, Tab
	call WriteChar

	mov	edx, OFFSET	project
	call WriteString

	mov	al, Tab
	call WriteChar

	mov	edx, OFFSET	myname
	call	WriteString
	call	Crlf

;Delcare extra credit.

	mov	edx, OFFSET	cred1dec
	call	WriteString
	call Crlf
	call Crlf

;Ask for the user's name

	mov	edx, OFFSET	askname
	call	WriteString

	mov edx, OFFSET	uname
	mov ecx, SIZEOF	uname
	call ReadString
	mov unCount,eax

	
;Greet user

	mov	edx, OFFSET	greet
	call	WriteString

	mov	edx, OFFSET	uname
	call	Writestring
	call	Crlf
	call	Crlf


;ask for the number of Fibonacci terms

	mov	edx, OFFSET	Fib1
	call	WriteString
	call Crlf

	mov	edx, OFFSET	range
	call	WriteString
	call Crlf
	call	Crlf


;validate input, display error message and ask again if out of range

ReEnter:
	mov	edx, OFFSET	howmany
	call	WriteString
	call Crlf

	call ReadInt
	call Crlf
	cmp eax, 47
	jge	Error1	;display error message if user enters 47 or larger.
	
	cmp eax, 0	;we must show at least 1 fibonnacci number.
	jz	Error1
	
	mov	nthTerm, eax
	jmp Calc

Error1:
	mov edx, OFFSET outrange
	call	WriteString
	jmp ReEnter

	Loop	L1 

;Calculate the Fibonacci sequence

Calc:
	mov	ecx, nthTerm ;Set Loop Counter
L1:
	;Perform the addition to get the next Fibonacci number
	mov	eax, Term1		
	add	eax, Term2
	mov	Result, eax		

	;Put Term1 into Term2 and the result into Term1
	mov	ebx, Term1
	mov	Term2, ebx
	mov	ebx, Result
	mov	Term1, ebx
		
;Display the sequence
	
	mov	edx,	Result
	call	WriteDec
	mov	al, Tab ; Horizontal tab to keep rows aligned.
	call WriteChar

	cmp Result, 14930352 ; If the result is 14930352 or greater, skip the next tab to keep the rows aligned.
	jge	skiptab

	mov	al, Tab
	call WriteChar

skiptab:
	; If there are 5 or more terms in this row, create a new row. 
	cmp	Position, 5
	jge	NewRow
	
	inc	Position
	loop	L1

;After the main loop completes
	jmp	runAgain 

NewRow:
	;Create a new row and reset the position counter.
	call Crlf
	mov	Position, 1
	loop L1	

; ask the user if they want to re-run the program

runAgain:

	; Reset both terms and position to starting values
	mov	Term1, 0
	mov	Term2, 1
	mov	Position, 1
	
	call Crlf
	call	Crlf
	mov	edx, OFFSET	again
	call	WriteString
	call	Crlf

; Get the user's choice and validate that the entry is either 1 or 0
Invalid:
	
	call Crlf
	mov	edx, OFFSET	choice
	call	WriteString
	call	Crlf

	call ReadInt
	cmp	eax, 1

	je	ReEnter
	cmp	eax, 0
	je	goodbye
	
;Error message if anything other than 0 or 1 is entered.
	mov	edx, OFFSET	error
	call	WriteString
	call	Crlf
	jmp	Invalid

;Bid Farewell

goodbye:
	call	Crlf
	mov	edx, OFFSET	certified
	call	WriteString
	call Crlf

	mov	edx, OFFSET	bye
	call	WriteString

	mov	edx, OFFSET	uname
	call	WriteString
	call	Crlf

; exit to operating system
	exit	
main ENDP

	
END main
