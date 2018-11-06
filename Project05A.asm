TITLE Program #5A     (program05A.asm)

; Author: Meghan Dougherty
; Last Modified: 7/5/2018
; OSU email address: dougherm@oregonstate.edu
; Course number/section: CS271 sec. 400
; Assignment Number: 5A                Due Date: 7/13/2018
; Description: A program that Implement and test custom ReadVal and WriteVal procedures for unsigned integers using macros.

INCLUDE Irvine32.inc

getString		MACRO address, size

	push	edx
	push	ecx
	mov  edx, address
	mov  ecx, size

	call	ReadString
	pop	ecx
	pop	edx
ENDM

displayString	MACRO stringIn
	push	edx
	mov edx, OFFSET stringIn
	call WriteString
	pop edx
ENDM


.data

; Constant Definitions.
inputLength = 10

; (insert variable definitions here)
project	BYTE		"Designing low-level I/O procedures ", 0
myname	BYTE		"by Meghan Dougherty", 0
intro	BYTE		" ", 0

input1	BYTE		"Please Enter 10 numbers: ",0
errorMSG	BYTE		"Number out of range. Try Again.", 0
dispMSG	BYTE		"Your Numbers are: ", 0
sumMSG	BYTE		"The sum of your numbers is, ", 0
bye		BYTE		"Results Certified by Meghan Dougherty. Goodbye!", 0
punct	BYTE		", ", 0
aveMSG	BYTE		"The average of your numbers is: ", 0
inputStr	BYTE		32 DUP (?)	
inputBuffer	BYTE	200 Dup (0)

numArray	DWORD	inputLength DUP(0)
inputNum	DWORD	0
sum		DWORD	0
average	DWORD	0

cred1dec	BYTE		"**EC:", 0
cred2dec	BYTE		"**EC:", 0


.code
main PROC


;introduce the programmer 
call introduce
call Crlf


;Get 10 valid integers from the user and store them in an array


	mov	ecx, inputLength			;set up the loop counter with a constant (10)
	mov	edi,	OFFSET numArray		;move the address of the number array to edi

	moreInput:
	displayString	input1

	
	push	OFFSET inputBuffer
	push	SIZEOF inputBuffer
	call	ReadVal

	mov	eax, DWORD PTR inputBuffer
	mov [edi], eax
	add	edi, 4
	loop	moreInput

	mov	ecx,	inputLength
	mov	esi,	OFFSET numArray
	mov	ebx, 0

	displayString	dispMSG

	
;calculate and display their sum
moreSum:

	mov	eax, [esi]
	add	ebx,	eax

	push	eax
	push OFFSET inputSTR
	call WriteVal
	cmp	ecx, 1
	jg	comma
back:	
	add	esi, 4
	loop moreSum
	jmp skip
comma:
	displayString	punct
	jmp back
skip:
	mov	eax, ebx
	mov	sum, eax
	
	call Crlf

	displayString	sumMSG

	push sum
	push OFFSET inputSTR
	call WriteVal
	call Crlf

;calculate and display their average

	mov	eax, sum
	mov	ebx, inputLength		
	mov	edx, 0

	div	ebx

	mov	ecx, eax
	mov eax, edx
	mov	edx, 2
	mul	edx
	
	cmp	eax, ebx
	mov	eax, ecx
	mov	average, eax
	jb	noRoundReq
	inc	eax
	mov	average, eax

noRoundReq:
	displayString	aveMSG
	push	average
	push OFFSET inputSTR
	call	WriteVal
	call Crlf

; Say goodbye
call Crlf

call goodBye

; exit to operating system
	exit	
main ENDP



;-----------------------------------------------------------------------------------
; This procedure introduces the programmer, the title of the program
; and states the extra credit attempts.
; Recieves: nothing
; Returns: Nothing
;-----------------------------------------------------------------------------------

introduce PROC
;Introduce the programmer
	mov	al, 9		;tab character
	call WriteChar

	displayString	project

	mov	al, 9		;tab character
	call WriteChar

	displayString myname

;Extra credit declarations	

introduce ENDP

;-----------------------------------------------------------------------------------
;This proceecdure converts a numeric value to a string of digits, 
; and invokes the displayString macro to produce the output.  
; Recieves: an address of a buffer and the size of that buffer.
; Returns: nothing
;-----------------------------------------------------------------------------------


ReadVal	PROC

;Set up the stack and save all registers
	push	ebp
	mov	ebp, esp
	pushad

restart:


;get user string of digits
	mov	edx, [ebp+12]		;address of inputBuffer
	mov	ecx, [ebp+8]		;size of inputBuffer

	getString	edx, ecx		;invoke getString(macro) to get user's string of digits

	mov	esi, edx
	mov eax, 0
	mov ecx, 0
	mov ebx, inputLength		

parseByte:

	lodsb
	cmp	ax, 0			;see if the end of the string has been reached.
	je	finish

	cmp	ax, 48			;0 is ASCII 48
	jb	error			;lower than 48, the character isn't a number

	cmp	ax, 57			;57 is ASCII 9
	ja	error			;higher than 57, the character isn't a number

	sub	ax, 48
	xchg	eax, ecx
	mul	ebx				;mult by 10 for correct digit place
	jc	Error		;output error message if the carry flag is triggered

	add	eax, ecx
	xchg	eax, ecx			;Exchange for the next loop through	
	jmp	parseByte			;Parse next byte

Error:

	displayString	errorMSG
	jmp restart

finish:
	xchg	ecx, eax
	mov	DWORD PTR inputBuffer, eax	;Save int in passed variable
	popad
	pop ebp
	ret 8

ReadVal	ENDP

;-----------------------------------------------------------------------------------
;This proceecdure converts a numeric value to a string of digits, 
; and invokes the displayString macro to produce the output.  
; Recieves: an address of an integer variable and a string variable.
; Returns: nothing
;-----------------------------------------------------------------------------------

WriteVal	PROC

	;set up the stack
	push	ebp
	mov	ebp, esp
	pushad		;save registers

;Set up the integer Loop

	mov		eax, [ebp+12]	;move integer to convert to string to eax
	mov		edi, [ebp+8]	;move string variable to edi to store string
	mov		ebx, 10
	push	0				;set up the stack for popping numbers later

Convert:					;convert the digit to ASCII
	mov		edx, 0
	div		ebx
	add		edx, 48
	push	edx				;push the digit onto stack

;Check if at end
	cmp		eax, 0
	jne		Convert

;Pop numbers off the stack
PopNum:
	pop		[edi]		;pop the digit into the string variable
	mov		eax, [edi]	;set up to compare
	inc		edi			;increase the position in the string
	cmp		eax, 0		;check if the end
	jne		PopNum

;Write as string using macro
	mov		edx, [ebp+8]
	displayString inputSTR
	

	popad		;restore registers
	pop ebp
	ret 8		;clear the stack

WriteVal	ENDP
;-----------------------------------------------------------------------------------
;This proceecdure bids the user farewell.
; Recieves: nothing
; Returns: nothing
;-----------------------------------------------------------------------------------

goodBye	PROC

	mov	edx,OFFSET bye
	call	WriteString
	call	Crlf
	
	ret
goodBye	ENDP

END main
