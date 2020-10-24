.model small 									;Declaración de modelo
.data 											;Inicia segmento de datos
	;Variables usadas para menú y validación
	Opc1 	  DB	'1-Generar UUID',10,13,'$'
	Opc2 	  DB	'2-Validar UUID',10,13,'$'
	Opc3	  DB	'3-Cerrar programa',10,13,'$'
	EntNV	  DB	'No se reconce la entrada, intente de nuevo',10,13,'$'
	Instruc2  DB	'Ingrese un UUID para validar; Escribir en mayusculas: ',10,13,'$'
	NLinea    DB	10,13,'$'
	Aceptar   DB	'Identificador UUID aceptado',10,13,'$'
	Anular    DB	'Caracter no permitido en UUID',10,13,'$'
	;Variables usadas para generador
	TextoFinal	db	10,13,'Fin del programa.',10,13,'Pulsa una tecla para cerrar.$'
	UUID		db	1,2,3,4,5,6,7,8,'-',1,2,3,4,'-',1,10,12,13,'-',11,1,2,3,'-',1,2,3,4,5,6,7,8,9,10,11,12,'$$$$'
	uuid_index	dw	0
	uuid_size	dw	36
	;Random Vars
	Random		dw	0
	Modulo		dw	0
	;Multiplicacion Vars
	Res_InitVal	db	1, 19 dup ('$')
	cb_Res		db	1, 19 dup ('$')
	prod		dw	0
	carry		dw	0
	index		dw	0
	sub_n		db	0
	res_size	dw	1
	;Date Vars
	anio_i	db	0
	mes__i	db	0
	dias_i	db	0
	hora_i	db	0
	minu_i	db	0
	segu_i	db	0
	cent_i	db	0
	sysTim	dw	0
	sysTim2 dw	0
	delay_val dw 2290;6690
	delay_default dw 2290
	;Debug Vars
	varx	dw 0
	vary	dw 0
	Num			dw	0
	Char		db	'x'
	q	dw 0
	r	dw 0
	ax_	dw	0
	bx_	dw	0
	cx_	dw	0
	dx_	dw	0
	times_ dw	0
	test_text db 10,13,'texto de prueba',10,13,'$'
	texto_emerg db 10,13,'Salida de emergencia',10,13,'$'
.stack 100h
.code
Programa:
	;Inicialización del programa
	MOV AX, @Data 								;Obtener dirección del inicio de segmento de datos
	MOV DS, AX									;Inicializa segmento de datos
Menu:
	;Impresión de menú principal
	MOV DX, OFFSET Opc1
	MOV AH, 09h
	INT 21h
	MOV DX, OFFSET Opc2
	INT 21h
	MOV DX, OFFSET Opc3
	INT 21h
	;Lectura de opción elegida
	XOR AX, AX									;Limpieza de registro AX
	MOV AH, 01h
	INT 21h
	CMP AL,31h
	JE Generar									;Salto a sección generador
	CMP AL,32h
	JE Validar									;Salto a sección validador
	CMP AL,33h
	JE Salto1									;Salto a salida del programa
	MOV AH, 09h
	MOV DX, OFFSET EntNV						;Opción no reconocida, desplegar el menú de nuevo
	INT 21h
	JMP Menu

Generar:
	MOV DX, OFFSET NLinea
	MOV AH, 09h
	INT 21h
	JMP SaltoAux1
	
Salto1:
	JMP Salto2
	
Validar:										;Procedimiento validación de identificador UUID
	MOV DX, OFFSET NLinea
	MOV AH, 09h
	INT 21h
	MOV DX, OFFSET Instruc2
	INT 21H
	XOR CX,CX
	MOV CX, 08h
	CALL ValIn
	MOV AH, 01h
	INT 21h
	CMP AL,2DH
	JNE Salto3
	XOR CX,CX
	MOV CX, 04h
	CALL ValIn
	MOV AH, 01h
	INT 21h
	CMP AL,2Dh
	JNE Salto3
	MOV AH, 01h
	INT 21h
	CMP AL,31h
	JNE Salto3
	XOR CX,CX
	MOV CX, 03h
	CALL ValIn
	MOV AH, 01h
	INT 21h
	CMP AL,2Dh
	JNE Salto3
	CALL ValG2
	XOR CX,CX
	MOV CX, 03h
	CALL ValIn
	MOV AH, 01h
	INT 21h
	CMP AL,2Dh
	JNE Cancelar
	XOR CX,CX
	MOV CX, 0ch
	CALL ValIn
	MOV AH,09h
	MOV DX, OFFSET NLinea
	INT 21h
	MOV DX, OFFSET Aceptar
	INT 21h
	XOR AX,AX
	XOR BX,BX
	XOR CX,CX
	XOR DX,DX
	JMP Menu

SaltoAux1:
	JMP SaltoAux2
	
Salto2:
	JMP Salida

Salto5:
	JMP Menu	
	
Salto3:
	JMP Cancelar	
	
ValIn PROC NEAR									;Ciclo para evaluación de caracteres según ER
	Aux:
	JMP LectIn
	RepCiclo:
		LOOP LectIn
		JMP FinProc
	LectIn:
		MOV AH, 01h
		INT 21h
		MOV AH, 0h
		SUB AL, 30h
		CMP AL, 0h
		JL Cancelar
		CMP AL,09h
		JLE RepCiclo
		SUB AL, 11h
		CMP AL, 0h
		JL Cancelar
		CMP AL, 05h
		JLE RepCiclo
		CMP AL,05h
		JG Cancelar
	FinProc:
	XOR CX,CX
	ret
ValIn ENDP

SaltoAux2:
	JMP SaltoAux3

ValG2 PROC NEAR
	MOV AH, 01h
	INT 21h
	CMP AL,38h
	JE EntVal
	CMP AL,39h
	JE EntVal
	CMP AL,41h
	JE EntVal
	CMP AL,42h
	JE EntVal
	JMP Cancelar
	EntVal:
	ret
ValG2 ENDP

Cancelar:										;Saltar al menú en caso de caracteres no aceptados
	MOV DX, OFFSET NLinea
	MOV AH, 09h
	INT 21h
	MOV DX, OFFSET Anular 
	INT 21h
	JMP Menu

Salto4:
	JMP Salto5

Salida:	
	;Finalización del programa
	MOV AH, 4Ch
	INT 21h	

SaltoAux3:
	;prueba masewal begin
	mov ah, 00h		;system timer on cx:dx
	int 1ah
	mov sysTim, dx
	EsperaCambioTick:
	int 1ah
	cmp sysTim, dx
	je EsperaCambioTick
	call GenUUID
	mov dx, offset UUID
	call PrintArrayDX
	MOV AH, 09h
	MOV DX, OFFSET NLinea
	INT 21h
	JMP Salto4

GenUUID proc near
		;8-4-[1]3-[8-b]3-12
		;Generate UUID
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
		;Convert UUID to ascii UUID
		call ConvertUUIDtoASCII
		ret
GenUUID endp
Hexadecimal proc near
		call GenRandom
		xor dx, dx
		mov ax, Random
		mov bx, 16
		div bx;cociente ax, residuo dx
		mov Modulo, dx
		;Valid Random Generated
		xor di, di
		lea di, UUID
		add di, uuid_index
		mov bx, Modulo
		mov [di], bl
		inc uuid_index
		ret
Hexadecimal endp
Hyphen proc near
		xor di, di
		lea di, UUID
		add di, uuid_index
		mov bl, '-'
		mov [di], bl
		inc uuid_index
		ret
Hyphen endp
One proc near
		xor di, di
		lea di, UUID
		add di, uuid_index
		mov bl, 1
		mov [di], bl
		inc uuid_index
		ret
One endp
EightToB proc near
		;8 - 11
		call GenRandom
		xor dx, dx
		mov ax, Random
		mov bx, 4
		div bx;cociente ax, residuo dx
		add dx, 8
		mov Modulo, dx
		;Valid Random Generated
		xor di, di
		lea di, UUID
		add di, uuid_index
		mov bx, Modulo
		mov [di], bl
		inc uuid_index
		ret
EightToB endp
ConvertUUIDtoASCII proc near
		xor si, si
		xor cx, cx
		xor bx, bx
		lea si, UUID
		mov cx, uuid_size
		Convert:
		mov bl, [si]
		cmp bl, '-'
		je ContinueLoop
		cmp bl, 9
		jg Letter
		add bl, '0'
		jmp ContinueLoop
		Letter:
		add bl, 55 ; A = 65(ascii), A = 10(val numerico)
		ContinueLoop:
		mov [si], bl
		inc si
		loop Convert
		lea si, UUID
		add si, uuid_size
		mov [si], '$'
		ret
ConvertUUIDtoASCII endp
GenRandom proc near
		;Get Date Time Number
		call GetDateTimeNumber
		;Get Last 4 Digit from cb_Res
		xor si, si
		xor ax, ax
		xor bx, bx
		mov Random, bx
		lea si, cb_Res
		mov bl, [si]
		xor bh, bh
		add Random, bx
		inc si
		mov al, [si]
		mov ah, 10
		mul ah
		add Random, ax
		inc si
		mov al, [si]
		mov ah, 100
		mul ah
		add Random, ax
		inc si
		xor ah, ah
		mov al, [si]
		mov bx, 1000
		mul bx
		add Random, ax
		xor dx, dx
		mov ax, Random
		mov bx, 113
		div bx
		mov Random, dx
		mov ax, Random
		mov bx, 491
		mul bx
		;producto en dx:ax
		xor dx, dx
		mov bx, 373
		div bx
		add dx, 13
		mov Random, dx
		ret
GenRandom endp
GetDateTimeNumber proc near
		;call Delay
		;Reset cb_Res
		call ResetRes
	;Get time
		mov ah, 2ch
		int 21h
	;Save time
		mov cent_i, dl
		mov segu_i, dh
		mov minu_i, cl
		mov hora_i, ch
	;Clear Regs
		xor ax, ax
		xor dx, dx
		xor cx, cx
	;1st Multiply Phase
		;Cent
		mov dl, cent_i
		mov sub_n, dl
		;debug5
		;xor dh, dh
		;mov Num, dx
		;mov Char, 'c'
		;call PrintNumIlLine
		;debug5
		call Multiplicacion
		;Segu
		mov dl, segu_i
		mov sub_n, dl
		call Multiplicacion
		;Minu
		mov dl, minu_i
		cmp dl, 0
		jne SkipInc1
		inc dl
		SkipInc1:
		mov sub_n, dl
		call Multiplicacion
		;Hora
		mov dl, hora_i
		cmp dl, 0
		jne SkipInc2
		inc dl
		SkipInc2:
		mov sub_n, dl
		call Multiplicacion
	;2nd Multiply Phase
		mov ah, 00h		;system timer on cx:dx
		int 1ah
		mov sub_n, dl
		call Multiplicacion
	;3rd Multiply Phase
		mov dx, uuid_index
		inc dx
		mov sub_n, dl
		call Multiplicacion
	;Return
		ret
GetDateTimeNumber endp
Delay proc near
		cmp delay_val, 0
		jg SkipDelayReset
		mov bx, delay_default
		mov delay_val, bx
		SkipDelayReset:
		; start delay
		call SaveRegs
		call CleanRegs
		mov si, delay_val
		mov di, delay_val
		delay_tag:
		dec si
		nop
		jnz delay_tag
		dec di
		cmp di,0    
		jnz delay_tag
		; end delay
		mov bx, Modulo
		sub delay_val, bx
		call LoadRegs
		ret
Delay endp
ResetRes proc near
		xor cx, cx
		xor si, si
		xor di, di
		xor bx, bx
		lea si, Res_InitVal
		lea di, cb_Res
		mov cx, 20
		Clean:
		mov bl, [si]
		mov [di], bl
		inc si
		inc di
		loop Clean
		mov res_size, 1
		ret
ResetRes endp
Multiplicacion proc near
		xor ax, ax ;se usara para div y mul
		xor bx, bx ;se usara para comparaciones y mov
		mov carry, 0
		mov index, 0
		xor si, si
		lea si, cb_Res
		while_m:
		mov bx, index
		cmp bx, res_size
		jge while_m_end
		mov al, [si]
		mov bl, sub_n
		mul bl
		;producto en ax (ah:al)
		add ax, carry 
		mov prod, ax
		xor dx, dx
		mov bx, 10
		div bx	;conciente al, residuo ah (necesita revisar)
		;cociente ax, residuo dx
		mov [si], dl ;residuo 
		xor ah, ah
		mov carry, ax ;cociente
		inc index
		inc si
		jmp while_m
		while_m_end:
		xor di, di
		lea di, cb_Res
		add di, res_size
		while_carry:
		cmp carry, 0
		je while_carry_end
		mov ax, carry
		mov bl, 10
		div bl ;cociente al, residuo ah
		mov [di], ah
		xor ah, ah
		mov carry, ax
		inc res_size
		inc di
		jmp while_carry
		while_carry_end:
		ret
Multiplicacion endp
PrintArrayDX proc near
		mov ah, 09h
		int 21h
		ret
PrintArrayDX endp
;Debug proc begin
SaveRegs proc near
;save all regs
		mov ax_, ax
		mov bx_, bx
		mov cx_, cx
		mov dx_, dx
		ret
SaveRegs endp
LoadRegs proc near
;load all regs
		mov ax, ax_
		mov bx, bx_
		mov cx, cx_
		mov dx, dx_
		ret
LoadRegs endp
CleanRegs proc near
		xor ax, ax
		xor bx, bx
		xor cx, cx
		xor dx, dx
		ret
CleanRegs endp
PrintNum proc near
		call SaveRegs
		;Printing
		call CleanRegs
		mov ax, Num
		mov bx, 10000
		div bx ;(dx:ax/16b)=Q->ax,R->dx
		mov q, ax
		mov r, dx
		xor dx, dx
		mov dx, q
		add dl, '0'
		mov ah, 2h
		int 21h
		xor ax, ax
		mov ax, r
		xor dx, dx
		mov bx, 1000
		div bx ;(dx:ax/16b)=Q->ax,R->dx
		mov q, ax
		mov r, dx
		xor dx, dx
		mov dx, q
		add dl, '0'
		mov ah, 2h
		int 21h
		xor ax, ax
		mov ax, r
		xor dx, dx
		mov bx, 100
		div bx ;(dx:ax/16b)=Q->ax,R->dx
		mov q, ax
		mov r, dx
		xor dx, dx
		mov dx, q
		add dl, '0'
		mov ah, 2h
		int 21h
		xor ax, ax
		mov ax, r
		xor dx, dx
		mov bx, 10
		div bx ;(dx:ax/16b)=Q->ax,R->dx
		mov q, ax
		mov r, dx
		xor dx, dx
		mov dx, q
		add dl, '0'
		mov ah, 2h
		int 21h
		mov dx, dx
		mov dx, r
		add dl, '0'
		mov ah, 2h
		int 21h
		call LoadRegs
		ret
PrintNum endp
PrintNumIlLine proc near
		call SaveRegs
		call CleanRegs
		mov ah, 2h
		mov dl, Char
		int 21h
		mov dl, 10
		int 21h
		mov dl, 13
		int 21h
		call PrintNum
		mov ah, 2h
		mov dl, 10
		int 21h
		mov dl, 13
		int 21h
		mov dl, Char
		int 21h
		mov dl, 10
		int 21h
		mov dl, 13
		int 21h
		call LoadRegs
		ret
PrintNumIlLine endp	
END Programa