TITLE Program #1     (program01.asm)

; Author: Meghan Dougherty
; Last Modified: 7/29/2018
; OSU email address: dougherm@oregonstate.edu
; Course number/section: CS271 sec. 400
; Assignment Number: 3                Due Date: 7/29/2018
; Description: A program that calculates and displayscomposit numbers from 1 to n, where n is a user inputted integer integer between 1 and 400 inclusive. 

INCLUDE Irvine32.inc



.data

; Constant Definitions.
upLimit = 1000
rowMax = 10

; (insert variable definitions here)
project	BYTE		"Composit Numbers", 0
myname	BYTE		"by Meghan Dougherty", 0
intro	BYTE		"Enter the number of composite numbers you would like to see. ", 0
intro2	BYTE		"I’ll accept orders for up to 400 composites.", 0
input1	BYTE		"Enter the number of composites you want to see.",0
errorMSG	BYTE		"Number out of range. Try Again.", 0
pageMSG	BYTE		"Press any key to view a new page.", 0

bye		BYTE		"Results Certified by Meghan Dougherty. Goodbye!", 0

inputInt	DWORD	?

testVal	DWORD	4
isPrime	DWORD	?
compCount	DWORD	0
rows		DWORD	0


cred1dec	BYTE		"**EC:Output Columns are Aligned.", 0
cred2dec	BYTE		"**EC: Program displays up to 1,000 composites, but one page of a 10x10 grid at a time.", 0


.code
main PROC

;introduce the programmer 
call introduce

; Get User Data
  call getUserData


;display composites
call showComposites

; Say goodbye
call Crlf
call Crlf
call goodBye

; exit to operating system
	exit	
main ENDP


; This procedure introduces the programmer, the title of the program
; and states the extra credit attempts.
introduce PROC
;Introduce the programmer
	mov	al, 9
	call WriteChar

	mov	edx, OFFSET project
	call	WriteString

	mov	al, 9
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
	
	mov	edx, OFFSET intro2
	call	WriteString
	call	Crlf
	call	Crlf
	ret
introduce ENDP

;This proceedure prompts the user to input the number of composits. 
;calls the validate proceedure to validate the user data. 
getUserData Proc

	mov	edx, OFFSET input1
	call	WriteString
	call	Crlf

	call validate

	ret
getUserData ENDP

;This proceedure validates the user data. First compares the integer to 0, then to the upper limit. 
;if the data is good, the program stores the input. 
validate PROC

	call ReadInt

;Make sure the integer is positive
Test1:
	cmp eax, 0
	ja Test2
	mov edx, OFFSET errorMSG
	call Writestring
	call Crlf

	mov	edx, OFFSET input1
	call	WriteString
	call	Crlf

	call ReadInt

;Make sure the integer is below the upper limit. 
Test2:
	cmp eax, upLimit

	jbe goodInput

	mov edx, OFFSET errorMSG
	call Writestring
	call Crlf

	mov	edx, OFFSET input1
	call	WriteString
	call	Crlf

	call ReadInt
	jmp Test1

;store the input if it's good.
goodInput:
	mov	inputInt, eax
	ret

validate ENDP

;This proceedure prints the composites. The display is a 10x10 grid. If additional displays are needed
;the program will wait for user input, then print another 10x10 grid on a new page. This process
;repeats until all the composites are displayed. 

showComposites Proc

;Set the loop counter
	mov	ecx, inputInt


printLoop:
	;Compare the current rows to the page max
	cmp	rows, rowMax
	je	newPage
	
	;call the composite calculator. 
	call isComposite

	;make sure the number is not prime. 
	cmp	isPrime, 1
	
	;if not prime, jump to the print formatting.
	jne	testSpacing

	inc	testVal
	jmp	printLoop



testSpacing:			;Test if 10 numbers have been printed. If so, print a new line
	cmp	compCount, 9
	jne	testSpacing2
	inc	rows

testSpacing2:
	cmp	compCount, 10
	jne	printComp
	call	CRLF

	mov	compCount, 0

printComp:
	mov	eax, testVal
	call	WriteDec
	
	mov	al, 9
	call WriteChar
	
	jmp	contLoop



contLoop:
	inc compCount
	inc testVal
	
	loop	printLoop

	cmp	ecx, 0
	je	done

;Create a new page.
newPage:
	call Crlf
	mov	edx, OFFSET pageMSG
	call	WriteString

;Wait for the user input to start a new page.
anyKey:
	mov	eax, 50
	call Delay
	call	ReadKey
	jz	anyKey

	call ClrScr
	call Crlf
	
	mov	rows, 0

	jmp	printLoop

done:
	ret

showComposites ENDP

;This proceedure calculates if a number is a composite. 
isComposite PROC
	
	;set up the registers to divide the test value.
	mov	eax, testVal
	mov	ebx, 2
	mov	edx, 00000000h

	;divide the test value by 2. If the remainder (edx) is 0, then the
	;number is a composite. 
	div	ebx
	cmp	edx,0
	je	isComp
	
	;if the number is divisible by 2, increase the divisor. 
	inc	ebx

divLoop:

	;clear the registries. 
	mov	edx, 00000000h
	mov	eax, 00000000h

	;compare the test val  to ebx. If they're equal, then the number is prime. 
	cmp	testVal, ebx
	je	isPrimeNum
	
	;divide. If the remainder is 0, the number is a composite.
	mov	eax, testVal
	div	ebx
	cmp	edx, 0

	je	isComp

	add ebx, 2
	jmp	divLoop

;Set the is prime flag to 1 if the number is prime.
isPrimeNum:	
	mov	isPrime, 1
	ret

;Set the is prime flag to 0 if the number is a composite.
isComp:
	add	ebx, 2
	mov isPrime, 0
	ret

isComposite ENDP

;This proceecdure bids the user farewell.
goodBye	PROC

	mov	edx,OFFSET bye
	call	WriteString
	call	Crlf
	
	ret
goodBye	ENDP

END main
