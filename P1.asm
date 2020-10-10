.model small 									;Declaración de modelo
.data 											;Inicia segmento de datos
	Opc1 	  DB	'1-Generar UUID',10,13,'$'
	Opc2 	  DB	'2-Validar UUID',10,13,'$'
	Opc3	  DB	'3-Cerrar programa',10,13,'$'
	EntNV	  DB	'No se reconce la entrada, intente de nuevo',10,13,'$'
	P1	      DB	'Salto a generador de UUID',10,13,'$'
	P2	      DB	'Salto a validador de UUID',10,13,'$'
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
	JE Generar
	CMP AL,32h
	JE Validar
	CMP AL,33h
	JE Salida
	MOV AH, 09h
	MOV DX, OFFSET EntNV
	INT 21h
	JMP Menu

Generar:
	MOV DX, OFFSET P1
	MOV AH, 09h
	INT 21h
	JMP Menu

Validar:
	MOV DX, OFFSET P2
	MOV AH, 09h
	INT 21h
	JMP Menu
	
Salida:	
	;Finalización del programa
	MOV AH, 4Ch
	INT 21h
END Programa