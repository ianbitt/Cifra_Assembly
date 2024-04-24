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
    catita dd 10
    beto dd 20


.code

somar:
    push ebp
    mov ebp, esp
    sub esp, 8

    mov eax, DWORD PTR [ebp+8]
    add eax, DWORD PTR [ebp+12]

    mov esp, ebp
    pop ebp
    ret 8
    


start:
    push catita
    push beto
    call somar
    printf("O valor da soma = %d",eax)
    

    invoke ExitProcess, 0
end start