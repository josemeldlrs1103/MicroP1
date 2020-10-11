.model small 									;Declaración de modelo
.data 											;Inicia segmento de datos
	Opc1 	  DB	'1-Generar UUID',10,13,'$'
	Opc2 	  DB	'2-Validar UUID',10,13,'$'
	Opc3	  DB	'3-Cerrar programa',10,13,'$'
	EntNV	  DB	'No se reconce la entrada, intente de nuevo',10,13,'$'
	P1	      DB	'Salto a generador de UUID',10,13,'$'
	P2	      DB	'Ingrese un UUID para validar; Escribir en mayusculas: ',10,13,'$'
	NLinea    DB	10,13,'$'
	Aceptar    DB	'Identificador UUID aceptado',10,13,'$'
	Anular    DB	'Caracter no permitido en UUID',10,13,'$'
.stack
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
	MOV DX, OFFSET P1
	MOV AH, 09h
	INT 21h
	JMP Menu
	
Salto1:
	JMP Salto2
Validar:										;Procedimiento validación de identificador UUID
	MOV DX, OFFSET NLinea
	MOV AH, 09h
	INT 21h
	MOV DX, OFFSET P2
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
	JNE Cancelar
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
	
Salto2:
	JMP Salida
	
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
	
Salida:	
	;Finalización del programa
	MOV AH, 4Ch
	INT 21h
END Programa