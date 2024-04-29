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
mensagem1 db "Bem vindos ao nosso programa de criptografia!", 0ah, 0h
barra db "-------------------------------------", 0ah, 0h
options db "Selecione uma das opcoes:", 0ah, 0h 
option1 db "1. Criptografar", 0ah, 0h
option2 db "2. Descriptografar", 0ah, 0h
option3 db "3. Sair", 0ah, 0h
confirm1 db "Voce selecionou a opcao de criptografar!", 0ah, 0h
confirm2 db "Voce selecionou a opcao de descriptografar!", 0ah, 0h
confirm3 db "Voce selecionou sair. Obrigado por utilizar nosso programa!", 0ah, 0h
arqentr db "Digite o nome do arquivo para ser lido: ", 0ah, 0h
arqsai db "Digite o nome do arquivo de saida: ", 0ah, 0h
chavecript db "Digite a chave de criptografia (0-7): ", 0ah, 0h
inputString db 50 dup(0)
inputStringArqEntr db 50 dup(0)
inputStringArqSaid db 50 dup(0)
inputStringChave db 11 dup(0)
fileBuffer dd 8 dup(0)
fileBuffer2 dd 8 dup(0)
arraysize dd 8
fileHandle1 dd 0
fileHandle2 dd 0
inputHandle dd 0
outputHandle dd 0           
write_count dd 0            
tamanho_string dd 0 
readCount dd 0
writeCount dd 0
integer1 dd 0  
contador dd 0
Chave dd 0
         

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
    

    invoke atodw, addr inputString ; Com o input do usu�rio, selecionar qual fun��o deseja executar
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
    
    ;----------------Fazer a abertura do arquivo que vai ser lido-----------------

    mov esi, offset inputStringArqEntr ; Tratamento de erro para reconhecimento do caracter de retorno
proximo1:
    mov al, [esi] ; 
    inc esi ; 
    cmp al, 13 ; Verificar se eh o caractere ASCII CR - FINALIZAR
    jne proximo1
    dec esi ; 
    xor al, al ;
    mov [esi], al ;

    invoke CreateFile, addr inputStringArqEntr, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov fileHandle1, eax

    ;------------Fazer a abertura do arquivo que vai ser escrito------------------
    mov esi, offset inputStringArqSaid ; Tratamento de erro para reconhecimento do caracter de retorno
proximo2:
    mov al, [esi] ; 
    inc esi ; 
    cmp al, 13 ; Verificar se eh o caractere ASCII CR - FINALIZAR
    jne proximo2
    dec esi ; 
    xor al, al ;
    mov [esi], al ;

    invoke CreateFile, addr inputStringArqSaid, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    mov fileHandle2, eax 

lerescrevercripto:
    ;------------Zerar os buffers antes de cada ciclo de leitura e escrita----------
    mov eax, 0
zerar:                                     
    mov fileBuffer[eax], 0
    mov fileBuffer2[eax], 0
    inc eax
    cmp eax, 8
    jl zerar



    ;-------------Fazer a leitura do arquivo que vai ser lido---------------------

    invoke ReadFile, fileHandle1, addr fileBuffer, 8, addr readCount, NULL

    
    mov contador, 0
    ciclocripto:

        mov esi, offset inputStringChave
        add esi, contador
        mov al, [esi]
        sub al, 48   
        movzx eax, al
        mov Chave, eax                     ;Chave vira um modificador de acesso (representando em qual posi��o mostrada pela chave, o caracter indicado na posi�ao filebuffer[cont] deve ir)
      

        mov esi, offset fileBuffer         ;Colocar em esi o ponteiro para o filebuffer
        add esi, contador                  ;Adicionar com o contador do ciclo qual caracter do filebuffer estamos acessando [0], [1], [2]....
        mov edi, offset fileBuffer2        ;Atribuir a edi o ponteiro para o filebuffer2 que � o filebuffer de sa�da
     

        mov al, [esi]                      ;Mover para al o conte�do do filebuffer apontado por esi
        add edi, Chave                     ;Adicionar � edi (usando a Chave) a posi��o que o caracter deve ficar 
        mov [edi], al                      ;Mover para o conte�do da posi��o que edi aponta o al (o que existe no esi na posi��o indicada)
    
        inc contador                       ;Contador que � usado para avan�ar no �ndice de filebuffer. A exemplo de filebuffer[0] no primieiro ciclo e filebuffer[1] no segundo
        cmp contador, 8
        jl ciclocripto

    
    ;------------Fazer a escrita no arquivo de destino----------------------------
    invoke WriteFile, fileHandle2, addr fileBuffer2, 8, addr writeCount, NULL

    
    cmp readCount, 8                       ;Quando ele n�o ler 8 caracteres, fecha os arquivos de Read e Write pois j� chegou no final do arquivo.
    jne terminarciclo
    jmp lerescrevercripto

terminarciclo:
    ;------------Fazer o fechamento do arquivo de sa�da---------------------------
    invoke CloseHandle, fileHandle1

    ;------------Fazer o fechamento do arquivo que foi lido-----------------------
    invoke CloseHandle, fileHandle2
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

    ;----------------Fazer a abertura do arquivo que vai ser lido-----------------

    mov esi, offset inputStringArqEntr ; Tratamento de erro para reconhecimento do caracter de retorno
proximo3:
    mov al, [esi] ; 
    inc esi ; 
    cmp al, 13 ; Verificar se eh o caractere ASCII CR - FINALIZAR
    jne proximo3
    dec esi ; 
    xor al, al ;
    mov [esi], al ;

    invoke CreateFile, addr inputStringArqEntr, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov fileHandle1, eax

    ;------------Fazer a abertura do arquivo que vai ser escrito------------------
    mov esi, offset inputStringArqSaid ; Tratamento de erro para reconhecimento do caracter de retorno
proximo4:
    mov al, [esi] ; 
    inc esi ; 
    cmp al, 13 ; Verificar se eh o caractere ASCII CR - FINALIZAR
    jne proximo4
    dec esi ; 
    xor al, al ;
    mov [esi], al ;

    invoke CreateFile, addr inputStringArqSaid, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    mov fileHandle2, eax 

lerescreverdescripto:
    ;------------Zerar o buffer antes de cada ciclo de leitura e escrita----------
    mov eax, 0
zerar1:                                     
    mov fileBuffer[eax], 0
    mov fileBuffer2[eax], 0

    add eax, 4
    cmp eax, 32
    jl zerar1


    ;-------------Fazer a leitura do arquivo que vai ser lido---------------------

    invoke ReadFile, fileHandle1, addr fileBuffer, 8, addr readCount, NULL

    mov contador,0

ciclodescripto:

    mov esi, offset inputStringChave
    add esi, contador
    mov al, [esi]
    sub al, 48   
    movzx eax, al
    mov Chave, eax                         ;Chave vira um modificador de acesso (representando em qual posi��o mostrada pela chave, o caracter indicado na posi�ao filebuffer2[cont] deve ir)
      

    mov esi, offset fileBuffer             ;Colocar em esi o ponteiro para o filebuffer
    add esi, Chave                         ;Adicionar com o valor da Chave qual caracter do filebuffer estamos acessando [0], [1], [2]....
    mov edi, offset fileBuffer2            ;Atribuir a edi o ponteiro para o filebuffer2 que � o filebuffer de sa�da

    mov al, [esi]                          ;Mover para al o conte�do do filebuffer apontado por esi
    add edi,  contador                     ;Adicionar � edi (usando o contador) a posi��o que o caracter deve ficar para descriptografar
    mov [edi], al                          ;Mover para o conte�do da posi��o que edi aponta o al (o que existe no esi na posi��o indicada)
    
    inc contador                           ;Contador que � usado para avan�ar no �ndice de filebuffer2. A exemplo de filebuffer2[0] no primieiro ciclo e filebuffer2[1] no segundo
    cmp contador, 8                        
    jl ciclodescripto



    ;------------Fazer a escrita no arquivo de destino----------------------------
    invoke WriteFile, fileHandle2, addr fileBuffer2, 8, addr writeCount, NULL
    
    cmp readCount, 8                       ;Quando ele n�o ler 8 caracteres, fecha os arquivos de Read e Write pois j� chegou no final do arquivo.
    jne terminarciclo1
    jmp lerescreverdescripto

terminarciclo1:
    ;------------Fazer o fechamento do arquivo de sa�da---------------------------
    invoke CloseHandle, fileHandle1

    ;------------Fazer o fechamento do arquivo que foi lido-----------------------
    invoke CloseHandle, fileHandle2

    jmp comeco


   
 fim:
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr confirm3, sizeof confirm3, addr write_count, NULL
    invoke ExitProcess, 0
end start