;Projeto Assembly - Arquitetura de Computadores I - Ewerton Monteiro
;Grupo: Ian Bittencourt, Nelly Stanford

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
mensagem1 db "Bem vindos ao nosso programa de criptografia!", 0ah, 0h        ;Textos utilizados ao longo do programa
barra db "-------------------------------------", 0ah, 0h
options db "Selecione uma das opcoes:", 0ah, 0h 
option1 db "1. Criptografar", 0ah, 0h
option2 db "2. Descriptografar", 0ah, 0h
option3 db "3. Sair", 0ah, 0h
confirm1 db "Voce selecionou a opcao de criptografar!", 0ah, 0h
confirm2 db "Voce selecionou a opcao de descriptografar!", 0ah, 0h
confirm3 db "Voce selecionou sair. Obrigado por utilizar nosso programa!", 0ah, 0h
arqentr db "Digite o nome do arquivo para ser lido: (Nao exceder 50 caracteres)", 0ah, 0h
arqsai db "Digite o nome do arquivo de saida: (Nao exceder 50 caracteres)", 0ah, 0h
chavecript db "Digite a chave de criptografia (0-7): ", 0ah, 0h
inputString db 4 dup(0)               ;Array para armazenar a opção escolhida pelo usuário
inputStringArqEntr db 50 dup(0)       ;Array para armazenar o nome do arquivo de entrada
inputStringArqSaid db 50 dup(0)       ;Array para armazenar o nome do arquivo de saída
inputStringChave db 11 dup(0)         ;Array para armazenar a chave digitada pelo usuário
fileBuffer dd 8 dup(0)                ;Array do buffer do arquivo de entrada
fileBuffer2 dd 8 dup(0)               ;Array que vai ser utilizado como buffer do arquivo de saída
fileHandle1 dd 0                      ;Handle utilizado na função ReadFile
fileHandle2 dd 0                      ;Handle utilizado na função WriteFile
inputHandle dd 0                      ;Handle utilizado na função ReadConsole
outputHandle dd 0                     ;Handle utilizado na função WriteConsole
write_count dd 0                      ;Contador de caracteres escritos pelas funções WriteConsole e ReadConsole
readCount dd 0                        ;Contador de caracteres lidos na função ReadFile
writeCount dd 0                       ;Contador de caracteres escritos na função WriteFile
integer1 dd 0                         ;Variável que recebe a opção escolhida pelo usuário no menu inicial
contador dd 0                         ;Variável de contagem de ciclos na função criptografar e descriptografar
Chave dd 0                            ;Variável que vai armazenar o valor lido na posição [contador] do array da chave

.code
start:
    invoke GetStdHandle, STD_OUTPUT_HANDLE               ;Usar a função GetStdHandle para guardar o handle de printar na variável outputHandle
    mov outputHandle, eax
    invoke WriteConsole, outputHandle, addr barra, sizeof barra, addr write_count, NULL
    
    invoke WriteConsole, outputHandle, addr mensagem1, sizeof mensagem1, addr write_count, NULL
    
comeco:

    xor eax, eax
    invoke WriteConsole, outputHandle, addr barra, sizeof barra, addr write_count, NULL

    invoke WriteConsole, outputHandle, addr options, sizeof options, addr write_count, NULL

    invoke WriteConsole, outputHandle, addr option1, sizeof option1, addr write_count, NULL

    invoke WriteConsole, outputHandle, addr option2, sizeof option2, addr write_count, NULL

    invoke WriteConsole, outputHandle, addr option3, sizeof option3, addr write_count, NULL

    invoke GetStdHandle, STD_INPUT_HANDLE     ;Usar a função GetStdHandle para guardar o handle de input na variável inputHandle
    mov inputHandle, eax
    invoke ReadConsole, inputHandle, addr inputString, sizeof inputString, addr write_count, NULL

    push offset inputString
    call FazerTratamentoCR      ; Tratamento de erro para reconhecimento do caracter de retorno                  

    invoke atodw, addr inputString ; Com o input do usuï¿½rio, selecionar qual funï¿½ï¿½o deseja executar
    mov integer1, eax
    
    cmp integer1, 1
    je criptografar

    cmp integer1, 2
    je descriptografar
    
    cmp integer1, 3
    je fim
    


criptografar:
    ;----------------Printar e receber o input do nome dos arquivos e chave---------
    
    invoke WriteConsole, outputHandle, addr confirm1, sizeof confirm1, addr write_count, NULL                 

    invoke WriteConsole, outputHandle, addr barra, sizeof barra, addr write_count, NULL

    invoke WriteConsole, outputHandle, addr arqentr, sizeof arqentr, addr write_count, NULL

    invoke ReadConsole, inputHandle, addr inputStringArqEntr, sizeof inputStringArqEntr, addr write_count, NULL

    invoke WriteConsole, outputHandle, addr arqsai, sizeof arqsai, addr write_count, NULL

    invoke ReadConsole, inputHandle, addr inputStringArqSaid, sizeof inputStringArqSaid, addr write_count, NULL

    invoke WriteConsole, outputHandle, addr chavecript, sizeof chavecript, addr write_count, NULL

    invoke ReadConsole, inputHandle, addr inputStringChave, sizeof inputStringChave, addr write_count, NULL
    
    ;----------------Fazer a abertura do arquivo que vai ser lido-----------------

    push offset inputStringArqEntr ; Tratamento de erro para reconhecimento do caracter de retorno
    call FazerTratamentoCR


    invoke CreateFile, addr inputStringArqEntr, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov fileHandle1, eax

    ;------------Fazer a abertura do arquivo que vai ser escrito------------------
    push offset inputStringArqSaid ; Tratamento de erro para reconhecimento do caracter de retorno
    call FazerTratamentoCR

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

    cmp readCount, 0           ;Quando não ler 8 caracteres, fecha os arquivos de Read e Write pois já chegou no final do arquivo.
    je terminarciclocripto
    
    push offset inputStringChave
    push offset fileBuffer2
    push offset fileBuffer
    call FazerCriptografia     ;Função para criptografar o fileBuffer e atribuir a fileBuffer2 a versão criptografada
    
    ;------------Fazer a escrita no arquivo de destino----------------------------
    invoke WriteFile, fileHandle2, addr fileBuffer2, 8, addr writeCount, NULL

    jmp lerescrevercripto                  ;Depois de escrever no arquivo de saída, voltar para o início do ciclo de criptografia

terminarciclocripto:
    ;------------Fazer o fechamento do arquivo de sa?da---------------------------
    invoke CloseHandle, fileHandle1

    ;------------Fazer o fechamento do arquivo que foi lido-----------------------
    invoke CloseHandle, fileHandle2
    jmp comeco


descriptografar:
    ;----------------Printar e receber o input do nome dos arquivos e chave---------
    
    invoke WriteConsole, outputHandle, addr confirm2, sizeof confirm2, addr write_count, NULL

    invoke WriteConsole, outputHandle, addr barra, sizeof barra, addr write_count, NULL

    invoke WriteConsole, outputHandle, addr arqentr, sizeof arqentr, addr write_count, NULL

    invoke ReadConsole, inputHandle, addr inputStringArqEntr, sizeof inputStringArqEntr, addr write_count, NULL

    invoke WriteConsole, outputHandle, addr arqsai, sizeof arqsai, addr write_count, NULL

    invoke ReadConsole, inputHandle, addr inputStringArqSaid, sizeof inputStringArqSaid, addr write_count, NULL

    invoke WriteConsole, outputHandle, addr chavecript, sizeof chavecript, addr write_count, NULL

    invoke ReadConsole, inputHandle, addr inputStringChave, sizeof inputStringChave, addr write_count, NULL

    ;----------------Fazer a abertura do arquivo que vai ser lido-----------------

    push offset inputStringArqEntr ; Tratamento de erro para reconhecimento do caracter de retorno
    call FazerTratamentoCR

    invoke CreateFile, addr inputStringArqEntr, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov fileHandle1, eax

    ;------------Fazer a abertura do arquivo que vai ser escrito------------------
    push offset inputStringArqSaid ; Tratamento de erro para reconhecimento do caracter de retorno
    call FazerTratamentoCR

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

    cmp readCount, 0                       ;Quando não ler 8 caracteres, fecha os arquivos de Read e Write pois já chegou no final do arquivo.
    je terminarciclodescripto

    push offset inputStringChave
    push offset fileBuffer2
    push offset fileBuffer
    call FazerDescriptografia   ;Função para descriptografar o fileBuffer e atribuir a fileBuffer2 a versão descriptografada


    ;------------Fazer a escrita no arquivo de destino----------------------------
    invoke WriteFile, fileHandle2, addr fileBuffer2, 8, addr writeCount, NULL
    
    jmp lerescreverdescripto               ;Depois de escrever no arquivo de saida, voltar para o inicio do ciclo de descriptografia

terminarciclodescripto:
    ;------------Fazer o fechamento do arquivo de sa?da---------------------------
    invoke CloseHandle, fileHandle1

    ;------------Fazer o fechamento do arquivo que foi lido-----------------------
    invoke CloseHandle, fileHandle2

    jmp comeco

FazerTratamentoCR:
    push ebp
    mov ebp, esp
    sub esp, 4

    mov eax, DWORD PTR [ebp+8]
    mov DWORD PTR [ebp-4], eax

    mov esi, DWORD PTR [ebp-4] ; Tratamento de erro para reconhecimento do caracter de retorno
proximo:
    mov al, [esi] ; 
    inc esi ; 
    cmp al, 13 ; Verificar se eh o caractere ASCII CR - FINALIZAR
    jne proximo
    dec esi ; 
    xor al, al ;
    mov [esi], al ;

mov esp, ebp
pop ebp
ret 4

FazerCriptografia:                     ;Função de Criptografar
    push ebp
    mov ebp, esp
    sub esp, 4

    mov ecx, DWORD PTR [ebp+8]         ; Aponta para o buffer do arquivo de entrada (fileBuffer)
    mov ebx, DWORD PTR [ebp+12]        ; Aponta para o buffer do arquivo de saida (fileBuffer2)
    mov eax, DWORD PTR [ebp+16]        ; Aponta para a chave de criptografia

    mov DWORD PTR [ebp-4], eax

    mov contador, 0

ciclocripto:
    mov esi, DWORD PTR [ebp-4]
    add esi, contador
    mov al, [esi]
    sub al, 48   
    movzx eax, al                       ;Movendo al para eax (Registrador de 32bits) usando o método movzx que transforma o conteúdo de al em 32bits ao completar com 0
    mov Chave, eax                      ;Chave vira um modificador de acesso (representando em qual posicao mostrada pela chave, o caracter indicado na posicao filebuffer[cont] deve ir)
   

    mov esi, ecx                        ;Colocar em esi o ponteiro para o filebuffer
    add esi, contador                   ;Adicionar com o contador do ciclo qual caracter do filebuffer estamos acessando [0], [1], [2]....
    mov edi, ebx                        ;Atribuir a edi o ponteiro para o filebuffer2 que eh o filebuffer de saida
     

    mov al, [esi]                       ;Mover para al o conteúdo do filebuffer apontado por esi
    add edi, Chave                      ;Adicionar a edi (usando a Chave) a posição que o caracter deve ficar 
    mov [edi], al                       ;Mover para o conteúdo da posição que edi aponta o al (o que existe no esi na posição indicada)
    
    inc contador                        ;Contador que é usado para avancar no índice de filebuffer. A exemplo de filebuffer[0] no primieiro ciclo e filebuffer[1] no segundo
    cmp contador, 8
    jl ciclocripto

mov esp, ebp
pop ebp
ret 12

FazerDescriptografia:                  ; Função de Descriptografar
    push ebp
    mov ebp, esp
    sub esp, 4
    
    mov ecx, DWORD PTR [ebp+8]         ; Aponta para o buffer do arquivo de entrada (fileBuffer)
    mov ebx, DWORD PTR [ebp+12]        ; Aponta para o buffer do arquivo de saida (fileBuffer2)
    mov eax, DWORD PTR [ebp+16]        ; Aponta para a chave de descriptografia

    mov DWORD PTR [ebp-4], eax

    mov contador, 0
    
ciclodescripto:
    mov esi, DWORD PTR [ebp-4]      
    add esi, contador
    mov al, [esi]
    sub al, 48   
    movzx eax, al                        ;Movendo al para eax (Registrador de 32bits) usando o método movzx que transforma o conteúdo de al em 32bits ao completar com 0
    mov Chave, eax                       ;Chave vira um modificador de acesso (representando em qual posi??o mostrada pela chave, o caracter indicado na posição filebuffer2[cont] deve ir)
      

    mov esi, ecx                         ;Colocar em esi o ponteiro para o filebuffer
    add esi, Chave                       ;Adicionar com o valor da Chave qual caracter do filebuffer estamos acessando [0], [1], [2]....
    mov edi, ebx                         ;Atribuir a edi o ponteiro para o filebuffer2 que é o filebuffer de saída

    mov al, [esi]                        ;Mover para al o conte?do do filebuffer apontado por esi
    add edi,  contador                   ;Adicionar a edi (usando o contador) a posição que o caracter deve ficar para descriptografar
    mov [edi], al                        ;Mover para o conteúdo da posição que edi aponta o al (o que existe no esi na posição indicada)
    
    inc contador                         ;Contador que é usado para avancar no índice de filebuffer2. A exemplo de filebuffer2[0] no primieiro ciclo e filebuffer2[1] no segundo
    cmp contador, 8                        
    jl ciclodescripto

mov esp, ebp
pop ebp
ret 12

   
 fim:
    invoke WriteConsole, outputHandle, addr confirm3, sizeof confirm3, addr write_count, NULL
    invoke ExitProcess, 0
end start