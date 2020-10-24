locals
.model small
.stack 100h
.data
;UUID Vars
	UUID				db	1,2,3,4,5,6,7,8,'-',1,2,3,4,'-',1,10,12,13,'-',11,1,2,3,'-',1,2,3,4,5,6,7,8,9,10,11,12,'$$$$'
	uuid_MultIndex		dw	0
	uuid_size			dw	36
;Random Vars
	Random				dw	0
	Modulo				dw	0
;Multiplicacion Vars
	ResultInitialValue	db	1, 19 dup ('$')
	Result				db	1, 19 dup ('$')
	Prod				dw	0
	Carry				dw	0
	MultIndex			dw	0
	Multiplier			db	0
	ResultActualSize	dw	1
;Date Vars
	Hour	db	0
	Minu	db	0
	Segu	db	0
	Cent	db	0
	SysTim	dw	0
.code
	main:
	;Load Data segment
		mov ax, @data
		mov ds, ax
	;Begin main code
	;Waiting for tick change to improve Randomness
		mov ah, 00h		;system timer on cx:dx
		int 1ah
		mov SysTim, dx
		WaitTickChange:
		int 1ah
		cmp SysTim, dx
		je WaitTickChange
	;Begin Generation of UUID
		call GenUUID
	;Printing UUID
		mov dx, offset UUID
		call PrintArrayDX
	;Final
		call Final
GenUUID proc near
		;individual digit generation
		call Hexadecimal; 1- 1
		call Hexadecimal; 2- 2
		call Hexadecimal; 3- 3
		call Hexadecimal; 4- 4
		call Hexadecimal; 5- 5
		call Hexadecimal; 6- 6
		call Hexadecimal; 7- 7
		call Hexadecimal; 8- 8
		call Hyphen  ;     - 9
		call Hexadecimal; 1-10
		call Hexadecimal; 2-11
		call Hexadecimal; 3-12
		call Hexadecimal; 4-13
		call Hyphen  ;     -14
		call One        ; 1-15
		call Hexadecimal; 2-16
		call Hexadecimal; 3-17
		call Hexadecimal; 4-18
		call Hyphen  ;     -19
		call EightToB   ; 1-20
		call Hexadecimal; 2-21
		call Hexadecimal; 3-22
		call Hexadecimal; 4-23
		call Hyphen  ;     -24
		call Hexadecimal; 1-25
		call Hexadecimal; 2-26
		call Hexadecimal; 3-27
		call Hexadecimal; 4-28
		call Hexadecimal; 5-29
		call Hexadecimal; 6-30
		call Hexadecimal; 7-31
		call Hexadecimal; 8-32
		call Hexadecimal; 9-33
		call Hexadecimal;10-34
		call Hexadecimal;11-35
		call Hexadecimal;12-36
		;Convert UUID numeric values to ascii values
		call ConvertUUIDtoASCII
		ret
GenUUID endp
Hexadecimal proc near
		call GenRandom		;Generate Random number
		xor dx, dx			;clean regs & vars to use
		mov ax, Random
		mov bx, 16
		div bx				;dx:ax / bx = Q -> ax, R -> dx
		mov Modulo, dx
		xor di, di			;clean Destination Register
		lea di, UUID		;load UUID into Destination Register
		add di, uuid_MultIndex	;move Destination Register to its MultIndex
		mov bx, Modulo		;saving Modulo value
		mov [di], bl
		inc uuid_MultIndex		;inc MultIndex for next digit
		ret
Hexadecimal endp
Hyphen proc near
		xor di, di			;clean regs
		lea di, UUID
		add di, uuid_MultIndex	;load UUID and position
		mov bl, '-'			;save -
		mov [di], bl
		inc uuid_MultIndex		;inc MultIndex for next digit
		ret
Hyphen endp
One proc near
		xor di, di			;clean regs
		lea di, UUID
		add di, uuid_MultIndex	;load UUID and position
		mov bl, 1			;save 1
		mov [di], bl
		inc uuid_MultIndex		;inc MultIndex for next digit
		ret
One endp
EightToB proc near
		call GenRandom		;Generate Random 
		xor dx, dx			;clean regs & vars to use
		mov ax, Random
		mov bx, 4
		div bx				;dx:ax / bx = Q -> ax, R -> dx
		add dx, 8
		mov Modulo, dx
		xor di, di
		lea di, UUID
		add di, uuid_MultIndex	;load UUID and position
		mov bx, Modulo
		mov [di], bl		;save Modulo value
		inc uuid_MultIndex		;inc MultIndex for next di
		ret
EightToB endp
ConvertUUIDtoASCII proc near
		xor si, si			;clean regs to use
		xor cx, cx
		xor bx, bx
		lea si, UUID
		mov cx, uuid_size	;load UUID
		Convert:
		mov bl, [si]
		cmp bl, '-'			;if hypen, jump convertion
		je ContinueLoop
		cmp bl, 9			;if greater than 9 jump to Letter
		jg Letter
		add bl, '0'			;else convert as a normal digit
		jmp ContinueLoop
		Letter:
		add bl, 55 			;10(Numeric value) + 55 =  A, 65(ascii) 
		ContinueLoop:
		mov [si], bl
		inc si				;inc UUID MultIndex
		loop Convert		;repeat
		lea si, UUID
		add si, uuid_size
		mov [si], '$'		;ensuring that there is escape character at the end
		ret
ConvertUUIDtoASCII endp
GenRandom proc near
		call GetDateTimeNumber;Get Date Time Number
		xor si, si			;clean regs & vars to use
		xor ax, ax
		xor bx, bx
		mov Random, bx
		lea si, Result		;load Result array
		mov bl, [si]
		xor bh, bh
		add Random, bx		;add Result[0] to Random
		inc si
		mov al, [si]
		mov ah, 10
		mul ah
		add Random, ax		;add Result[1]*10 to Random
		inc si
		mov al, [si]
		mov ah, 100
		mul ah
		add Random, ax		;add Result[2]*100 to Random
		inc si
		xor ah, ah
		mov al, [si]
		mov bx, 1000
		mul bx
		add Random, ax		;add Result[3]*1000 to Random
		xor dx, dx
		mov ax, Random
		mov bx, 113
		div bx
		mov Random, dx		;Random = residue(Random/113)
		mov ax, Random
		mov bx, 491
		mul bx				;Random(ax) = Random * 491 -> dx:ax
		xor dx, dx
		mov bx, 373
		div bx				;Random(ax) = residue(Random/373)
		add dx, 13			;Random(dx) += 13
		mov Random, dx		;Random = dx
		ret
GenRandom endp
GetDateTimeNumber proc near
		call ResetRes		;Reset Result array
	;Get time
		mov ah, 2ch
		int 21h
	;Save time
		mov Cent, dl
		mov Segu, dh
		mov Minu, cl
		mov Hour, ch
	;Clear Regs
		xor ax, ax
		xor dx, dx
		xor cx, cx
	;1st Multiply Phase
		;Cent
		mov dl, Cent		;move Cent to Multiplier
		inc dl				;ensuring that Multiplier is not 0
		mov Multiplier, dl
		call Multiplicacion	;Result *= Multiplier
		;Segu
		mov dl, Segu		;move Segu to Multiplier
		inc dl				;ensuring that Multiplier is not 0
		mov Multiplier, dl
		call Multiplicacion	;Result *= Multiplier
		;Minu
		mov dl, Minu		;move Minu to Multiplier
		inc dl				;ensuring that Multiplier is not 0
		mov Multiplier, dl
		call Multiplicacion	;Result *= Multiplier
		;Hour
		mov dl, Hour		;move Hour to Multiplier
		inc dl				;ensuring that Multiplier is not 0
		mov Multiplier, dl
		call Multiplicacion	;Result *= Multiplier
	;2nd Multiply Phase
		mov ah, 00h			;request system timer on cx:dx
		int 1ah
		inc dl				;ensuring that Multiplier is not 0
		mov Multiplier, dl
		call Multiplicacion	;Result *= Multiplier
	;3rd Multiply Phase
		mov dx, uuid_MultIndex
		inc dx
		mov Multiplier, dl
		call Multiplicacion	;Result *= Multiplier
	;Return
		ret
GetDateTimeNumber endp
ResetRes proc near
		xor cx, cx			;clean regs to use
		xor si, si
		xor di, di
		xor bx, bx
		lea si, ResultInitialValue	;load Result initial value
		lea di, Result				;load Result
		mov cx, 20
		Clean:						;move all initial values to Result
		mov bl, [si]
		mov [di], bl
		inc si						;inc indexers 
		inc di
		loop Clean
		mov ResultActualSize, 1		;default size for Result
		ret
ResetRes endp
Multiplicacion proc near
		xor ax, ax			;clean regs & vars to use
		xor bx, bx
		mov Carry, 0
		mov MultIndex, 0
		xor si, si
		lea si, Result		;load Result
		WhileMult:
		mov bx, MultIndex
		cmp bx, ResultActualSize	;while validation
		jge WhileMultEnd	;exit while
		mov al, [si]
		mov bl, Multiplier
		mul bl				;Result[Index] * Multiplier = ax
		add ax, Carry
		mov Prod, ax		;Prod = ax + Carry
		xor dx, dx
		mov bx, 10
		div bx	
		mov [si], dl		;Result[Index] = residue(Prod/10)
		xor ah, ah
		mov Carry, ax 		;Carry = quotient(Prod/10)
		inc MultIndex		;inc Index(for reference)
		inc si				;inc Index(for array)
		jmp WhileMult
		WhileMultEnd:
		xor di, di
		lea di, Result
		add di, ResultActualSize	;clean reg then load and positioning Result
		WhileCarry:
		cmp Carry, 0		;while validation
		je WhileCarryEnd	;exit while;cociente al, residuo ah
		mov ax, Carry
		mov bl, 10
		div bl				
		mov [di], ah		;save into Result[Last Index + 1] quotient(Carry/10)
		xor ah, ah
		mov Carry, ax		;save into Carry residue(Carry/10)
		inc ResultActualSize	;inc ResultActualSize
		inc di				;inc array indexer
		jmp WhileCarry
		WhileCarryEnd:
		ret
Multiplicacion endp
PrintArrayDX proc near
		mov ah, 09h			;print array in dx interruption
		int 21h
		ret
PrintArrayDX endp
Final proc near
		mov ah, 4ch 		;end of program interruption
		int 21h
Final endp
end main