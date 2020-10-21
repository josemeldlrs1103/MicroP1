locals
.model small
.stack 100h
.data
	TextoFinal	db	10,13,'Fin del programa.',10,13,'Pulsa una tecla para cerrar.$'
	;UUID Vars
	;UUID		db	40	dup ('$')
				   ;8               -  4        - [1]3         -[8-b]3      -  12
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
.code
	main:
	;Load Data segment
		mov ax, @data
		mov ds, ax
	;Begin main code
		
		;prueba masewal begin
		mov ah, 00h		;system timer on cx:dx
		int 1ah
		mov sysTim, dx
		EsperaCambioTick:
		int 1ah
		cmp sysTim, dx
		je EsperaCambioTick
		;prueba masewal end
		;prueba masewal2 begin
		;mov ah, 2ch
		;int 21h
		;xor dh, dh
		;mov cent_i, dl
		;EsperaCambioCent:
		;int 21h
		;cmp cent_i, dl
		;je EsperaCambioCent
		;prueba masewal2 end
		
		call GenUUID
		mov dx, offset UUID
		call PrintArrayDX
		
	;Final
		call Final
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
		;debug4
		;xor dh, dh
		;mov Num, dx
		;mov Char, 't'
		;call PrintNumIlLine
		;debug4
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
		;debug2
		;mov ah, 2h
		;mov dl, '#'
		;int 21h
		;int 21h
		;debug2
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
		;debug1
		;mov Num, ax
		;call PrintNumIlLine
		;mov ax, Num
		;debug1
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
		;debug3
		;mov Num, ax
		;call PrintNumIlLine
		;mov ax, Num
		;debug3
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
;Debug proc end
Final proc near
		;mov dx, offset TextoFinal
		;mov ah, 09h
		;int 21h
		;mov ah, 1h
		;int 21h
		mov ah, 4ch 
		int 21h
Final endp
end main