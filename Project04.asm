TITLE Program #4     (program04.asm)

; Author: Meghan Dougherty
; Last Modified: 7/5/2018
; OSU email address: dougherm@oregonstate.edu
; Course number/section: CS271 sec. 400
; Assignment Number: 4                Due Date: 7/5/2018
; Description: A program that generates a random array of integers based on user input,
;then sorts the integers in descending order and calculates the median value. 
INCLUDE Irvine32.inc



.data

; Constant Definitions.
min = 10
max = 200
lo = 100
hi = 999

; (insert variable definitions here)
project	BYTE		"Sorting Random Integers", 0
myname	BYTE		"by Meghan Dougherty", 0
intro	BYTE		" This program generates random numbers in the range [100 ... 999], displays the original list, sorts the list, and calculates the median value. Finally, it displays the list sorted in descending order. ", 0

input1	BYTE		"How many numbers should be generated?",0
errorMSG	BYTE		"Number out of range. Try Again.", 0
randDisp	BYTE		"The unsorted random numbers:", 0
medDisp	BYTE		"The median is ", 0
sortDisp	BYTE		"The sorted list: ", 0

bye		BYTE		"Results Certified by Meghan Dougherty. Goodbye!", 0

numArray	DWORD	MAX DUP(0)
inputNum	DWORD	0

cred1dec	BYTE		"**EC:Output Columns are Aligned.", 0
cred2dec	BYTE		"**EC: Program displays up to 1,000 composites, but one page of a 10x10 grid at a time.", 0


.code
main PROC

;Generate a psuedo random numer
call Randomize

;introduce the programmer 
call introduce

; Get User Data
push	OFFSET inputNum
call getData

;Fill the array  with random numbers
push OFFSET numArray
push	inputNum
call	fillArray

;Display the randomized array.
mov	edx, OFFSET randDisp
call	WriteString
call	Crlf

push OFFSEt numArray
push	inputNum
call	listDisplay

;Sort the array into descending order
push OFFSEt numArray
push	inputNum
call	sortList

;Calculate and Display the median
push OFFSET numArray
push	inputNum
call	Median
call Crlf

;Display the sorted array
mov	edx, OFFSET sortDisp
call	WriteString
call	Crlf

push OFFSEt numArray
push	inputNum
call	listDisplay

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

	mov	edx, OFFSET project
	call	WriteString

	mov	al, 9		;tab character
	call WriteChar

	mov	edx, OFFSET myname
	call	WriteString
	call	Crlf

;Extra credit declarations	
	mov	edx, OFFSET cred1dec
	call	WriteString
	call	Crlf

	mov	edx, OFFSET cred2dec
	call	WriteString
	call	Crlf
	call	Crlf

	mov	edx, OFFSET intro
	call	WriteString
	call	Crlf
	ret

introduce ENDP
;-----------------------------------------------------------------------------------
; This proceedure prompts the user to input the size of the array then validates the 
; input
; Recieves: address of the inputNum variable
; Returns: nothing
;-----------------------------------------------------------------------------------

getData Proc 

	;set up the stack frame
	push ebp
	mov ebp, esp

	mov edx, OFFSET input1
	call WriteString
	Call crlf

	;move the address of the inputVal variable into edx
	mov ebx, [ebp+8]


GreaterThan:
	;compare the input to the maximum value

	call	ReadInt
	cmp	eax, MAX
	jle	LESSTHAN
	jg	INVALID

LESSTHAN:
	;compare the input to the minimum value

	cmp eax, MIN
	jl	INVALID
	jmp	VALID

INVALID:
	mov edx, OFFSET errorMSG		;Print error message
	call WriteString
	call	Crlf
	
	jmp	GreaterThan			;Jump back to get user input and retest

VALID:
	;if input is valid, store it in the inputNum variable.
	mov [ebx], eax
	
	pop	ebp					
	ret	4					;return bytes pushed before call

getData ENDP

;-----------------------------------------------------------------------------------
; This procedure generates the random numbers and fills the array. 
; Recieves: address of an integer array and its size
; Returns: nothing
;-----------------------------------------------------------------------------------
fillArray Proc
	
	;set up the stack frame
	push ebp
	mov ebp, esp

	mov	edi, [ebp+12]			;address of the array
	mov	ecx,	[ebp+8]			;make the size of the array the loop counter

addNum:
	
	mov	eax, HI				;Using the gloab high and low constraints, create a 
	sub	eax, LO				;psuedo random integer.
	add	eax, 1

	call	RandomRange
	add	eax, LO
	mov	[edi], eax			;store the integer in the array
	add	edi, 4				;move the pointer to the next position in the array

	loop	addNum				;loop back for more input

	pop	ebp
	ret	8					;return bytes pushed before call
fillArray ENDP

;-----------------------------------------------------------------------------------
;This proceedure sorts the array in descending order using the Bubble Sort algorithm.
;Recieves: address for an array of integers and the size of that array
;Returns: nothing.
;-----------------------------------------------------------------------------------

sortList PROC
	;set up the stack frame
	push ebp
	mov ebp, esp

	
	mov	ecx, [ebp+8]	;set up the loop counter
	dec	ecx			;decrement by 1 to avoid accessing out of range.

L1:
	push	ecx			; save outer loop count
	mov	esi, [ebp+12]	;assign the address of the array to esi

L2: 
	mov	eax,[esi]		; get array value
	cmp	[esi+4],eax	; compare a pair of values

	jg L3			; if the first value is greater than the second, no exchange.
	xchg eax,[esi+4]	; exchange the pair
	mov [esi],eax

L3: 
	add esi,4			; move both pointers forward
	loop L2			; inner loop

	pop ecx			; retrieve outer loop count
	loop L1			; else repeat outer loop


L4: 
	pop	ebp
	ret	8			;return bytes pushed before call
sortList ENDP

;-----------------------------------------------------------------------------------
; This procedure calculates and displays the median.
; Recieves: address of an integer array and the size of that array
; Returns: nothing.
;-----------------------------------------------------------------------------------
Median PROC

	;set up the stack frame
	push ebp
	mov	ebp, esp

	mov	esi, [ebp+12]	;assign the array address
	mov	eax, [ebp+8]	;assign the array size
	mov	edx, 0		;initiate edx to 0, otherwise garbage values sneak in
	

	;Find the middle term. 
	mov	ebx, 2			;divide the size by 2. 
	div	ebx
	cmp	edx, 0			;is there a remainder?
	je	evenArray			; If the array has an even number of elements, more calculations are required.

	;Locate the middle term
	mov	ebx, 4			
	mul	ebx				;multiply the division result by 4
	add	esi, eax			;add the result to the starting address of the array to get location of median
	mov	eax, [esi]		;prep the median term for printing.


printMedian:
	call	Crlf
	mov	edx, OFFSET medDisp
	call	WriteString

	call	WriteDec
	call Crlf
	jmp	allDone

evenArray:
	;Find term on rigth side of center.
	mov	ebx, 4
	mul	ebx
	add	esi, eax
	mov	edx, [esi]

	;Find term on left side of center
	mov	eax, esi
	sub	eax, 4
	mov	esi, eax
	mov	eax, [esi]

	;average the terms
	add	eax, edx
	mov	edx, 0
	mov	ebx, 2
	div	ebx

	;print
	jmp printMedian


allDone:
	pop ebp
	ret 8			;return bytes pushed before call

Median ENDP
;-----------------------------------------------------------------------------------
;This proceedure displays the array. 
; Receives: address of integer array and array size
; Returns: nothing
;-----------------------------------------------------------------------------------
listDisplay PROC

	;set up the stack frame.
	push ebp
	mov ebp, esp

	mov	esi, [ebp+12]		;set up the array address.
	mov	ecx, [ebp+8]		;create a loop counter 
	mov	ebx, 1			;create a row counter

L1:
	cmp	ebx, LO			;Global low is ten, which is also max amount of integers per row.
	jg	newRow			;start a new row if ebx is greater than 10
	mov	eax, [esi]		;Print the next term in the array
	call	WriteDec		
	mov	al, 9			;print a tab between each number
	call WriteChar

	add	esi, 4			;navigate to the next term in the array
	add	ebx, 1			;increase the row counter
	loop L1				;start again
	jmp	lpDone

newRow:
	call Crlf				;start a new row
	mov	ebx, 1
	jmp L1

lpDone:
	pop ebp
	ret 8				;return the bytes pushed before call
listDisplay ENDP

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
