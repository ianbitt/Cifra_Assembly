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


.data
um dd 1
dois dd 2
tres dd 3
mensagem1 db "Bem vindos ao nosso programa de criptografia!", 0ah, 0h
barra db "-------------------------------------", 0ah, 0h
options db "Selecione uma das opcoes:", 0ah, 0h 
option1 db "1. Criptografar", 0ah, 0h
option2 db "2. Descriptografar", 0ah, 0h
option3 db "3. Sair", 0ah, 0h
confirm1 db "Voce selecionou a opcao de criptografar", 0ah, 0h
confirm2 db "Voce selecionou a opcao de descriptografar", 0ah, 0h
confirm3 db "Voce selecionou sair do programa. Obrigado por utilizar!", 0ah, 0h
arqentr db "Digite o nome do arquivo para ser lido: ", 0ah, 0h
arqsai db "Digite o nome do arquivo de saida: ", 0ah, 0h
chavecript db "Digite a chave de criptografia: ", 0ah, 0h
inputString db 50 dup(0)
inputStringArqEntr db 50 dup(0)
inputStringArqSaid db 50 dup(0)
inputStringChave db 50 dup(0)
inputHandle dd 0
outputHandle dd 0           ; Variável que vai armazenar o handle de saída
write_count dd 0            ; Variável que vai armazenar os caracteres escritos na console
tamanho_string dd 0 
comparar dd 0
integer1 dd 0           

.code
start:
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr barra, sizeof barra, addr write_count, NULL
    
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr mensagem1, sizeof mensagem1, addr write_count, NULL
    
comeco:
    xor eax, eax
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr barra, sizeof barra, addr write_count, NULL

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr options, sizeof options, addr write_count, NULL

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr option1, sizeof option1, addr write_count, NULL

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr option2, sizeof option2, addr write_count, NULL

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr option3, sizeof option3, addr write_count, NULL

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr write_count, NULL

    mov esi, offset inputString ; Tratamento de erro para reconhecimento do caracter de retorno
proximo:
    mov al, [esi] ; 
    inc esi ; 
    cmp al, 13 ; Verificar se eh o caractere ASCII CR - FINALIZAR
    jne proximo
    dec esi ; 
    xor al, al ;
    mov [esi], al ;
    

    invoke atodw, addr inputString
    mov integer1, eax
    
    cmp integer1, 1
    je criptografar

    cmp integer1, 2
    je descriptografar
    
    cmp integer1, 3
    je fim
    


criptografar:
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr confirm1, sizeof confirm1, addr write_count, NULL

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr barra, sizeof barra, addr write_count, NULL

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr arqentr, sizeof arqentr, addr write_count, NULL

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke ReadConsole, inputHandle, addr inputStringArqEntr, sizeof inputStringArqEntr, addr write_count, NULL

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr arqsai, sizeof arqsai, addr write_count, NULL

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke ReadConsole, inputHandle, addr inputStringArqSaid, sizeof inputStringArqSaid, addr write_count, NULL

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr chavecript, sizeof chavecript, addr write_count, NULL

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke ReadConsole, inputHandle, addr inputStringChave, sizeof inputStringChave, addr write_count, NULL



    
    jmp comeco


descriptografar:
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr confirm2, sizeof confirm2, addr write_count, NULL

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr barra, sizeof barra, addr write_count, NULL

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr arqentr, sizeof arqentr, addr write_count, NULL

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke ReadConsole, inputHandle, addr inputStringArqEntr, sizeof inputStringArqEntr, addr write_count, NULL

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr arqsai, sizeof arqsai, addr write_count, NULL

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke ReadConsole, inputHandle, addr inputStringArqSaid, sizeof inputStringArqSaid, addr write_count, NULL

    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr chavecript, sizeof chavecript, addr write_count, NULL

    invoke GetStdHandle, STD_INPUT_HANDLE
    mov inputHandle, eax
    invoke ReadConsole, inputHandle, addr inputStringChave, sizeof inputStringChave, addr write_count, NULL

    jmp comeco


   
 fim:
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr confirm3, sizeof confirm3, addr write_count, NULL
    invoke ExitProcess, 0
end start