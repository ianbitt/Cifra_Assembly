.686
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm


.data
output db "Hello World!", 0ah, 0h
outputHandle dd 0           ; Variável que vai armazenar o handle de saída
write_count dd 0            ; Variável que vai armazenar os caracteres escritos na console

.code
start:
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr output, sizeof output, addr write_count, NULL
   
    invoke ExitProcess, 0
end start