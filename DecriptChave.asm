.686
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
includelib \masm32\lib\masm32.lib 
include \masm32\macros\macros.asm

.data
chavecript db "Digite a chave de criptografia: ", 0ah, 0h
inputStringChave db 50 dup(0)
arqentr db "Digite o nome do arquivo para ser lido: ", 0ah, 0h
inputStringArqEntr db 50 dup(' ')
fileBuffer db 8 dup(0)
fileBuffer2 db 8 dup(0)
outputHandle dd 0
readCount dd 0
writeCount dd 0
inputHandle dd 0
write_count dd 0 
fileHandle1 dd 0
counter dd 0
variavel dd 0
beto db 4
cont dd 0

.code
start:
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr chavecript, sizeof chavecript, addr write_count, NULL

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke ReadConsole, inputHandle, addr inputStringChave, sizeof inputStringChave, addr write_count, NULL

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr arqentr, sizeof arqentr, addr write_count, NULL

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke ReadConsole, inputHandle, addr inputStringArqEntr, sizeof inputStringArqEntr, addr write_count, NULL

    mov esi, offset inputStringChave ; Tratamento de erro para reconhecimento do caracter de retorno
proximochave:
    mov al, [esi] ; 
    inc esi ; 
    cmp al, 13 ; Verificar se eh o caractere ASCII CR - FINALIZAR
    jne proximochave
    dec esi ; 
    xor al, al ;
    mov [esi], al ;

     mov esi, offset inputStringArqEntr ; Tratamento de erro para reconhecimento do caracter de retorno
proximoentr:
    mov al, [esi] ; 
    inc esi ; 
    cmp al, 13 ; Verificar se eh o caractere ASCII CR - FINALIZAR
    jne proximoentr
    dec esi ; 
    xor al, al ;
    mov [esi], al ;

    invoke CreateFile, addr inputStringArqEntr, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov fileHandle1, eax

    invoke ReadFile, fileHandle1, addr fileBuffer, 8, addr readCount, NULL

    

ciclo:
    xor edi,edi
    xor esi,esi

    mov esi, offset inputStringChave
    add esi, cont
    mov al, [esi]
    sub al, 48   
    movzx eax, al
    mov variavel, eax
      

    mov esi, offset fileBuffer
    add esi, variavel
    mov edi, offset fileBuffer2

    mov al, [esi]
    add edi,  cont
    mov [edi], al
    
    inc cont
    cmp cont, 8
    jl ciclo



    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr inputStringChave, sizeof inputStringChave, addr write_count, NULL
    
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr fileBuffer2, sizeof fileBuffer2, addr write_count, NULL


    invoke CloseHandle, fileHandle1

    invoke ExitProcess, 0
end start







.686
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
includelib \masm32\lib\masm32.lib 
include \masm32\macros\macros.asm

.data
chavecript db "Digite a chave de criptografia: ", 0ah, 0h
inputStringChave db 50 dup(0)
arqentr db "Digite o nome do arquivo para ser lido: ", 0ah, 0h
inputStringArqEntr db 50 dup(' ')
fileBuffer db 8 dup(0)
fileBuffer2 db 8 dup(0)
outputHandle dd 0
readCount dd 0
writeCount dd 0
inputHandle dd 0
write_count dd 0 
fileHandle1 dd 0
counter dd 0
variavel dd 0
beto db 4
cont dd 0

.code
start:
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr chavecript, sizeof chavecript, addr write_count, NULL

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke ReadConsole, inputHandle, addr inputStringChave, sizeof inputStringChave, addr write_count, NULL

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr arqentr, sizeof arqentr, addr write_count, NULL

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke ReadConsole, inputHandle, addr inputStringArqEntr, sizeof inputStringArqEntr, addr write_count, NULL

    mov esi, offset inputStringChave ; Tratamento de erro para reconhecimento do caracter de retorno
proximochave:
    mov al, [esi] ; 
    inc esi ; 
    cmp al, 13 ; Verificar se eh o caractere ASCII CR - FINALIZAR
    jne proximochave
    dec esi ; 
    xor al, al ;
    mov [esi], al ;

     mov esi, offset inputStringArqEntr ; Tratamento de erro para reconhecimento do caracter de retorno
proximoentr:
    mov al, [esi] ; 
    inc esi ; 
    cmp al, 13 ; Verificar se eh o caractere ASCII CR - FINALIZAR
    jne proximoentr
    dec esi ; 
    xor al, al ;
    mov [esi], al ;

    invoke CreateFile, addr inputStringArqEntr, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov fileHandle1, eax

    invoke ReadFile, fileHandle1, addr fileBuffer, 8, addr readCount, NULL

    

ciclo:

    mov esi, offset inputStringChave
    add esi, cont
    mov al, [esi]
    sub al, 48   
    movzx eax, al
    mov variavel, eax
      

    mov esi, offset fileBuffer
    add esi, variavel
    mov edi, offset fileBuffer2

    mov al, [esi]
    add edi, cont
    mov [edi], al
    
    inc cont
    cmp cont, 8
    jl ciclo



    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr inputStringChave, sizeof inputStringChave, addr write_count, NULL
    
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr fileBuffer2, sizeof fileBuffer2, addr write_count, NULL


    invoke CloseHandle, fileHandle1

    invoke ExitProcess, 0
end start







