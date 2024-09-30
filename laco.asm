%macro FOR 3
    mov dword [%2], %3 ; 
    %1:                ; Início
    jmp %1##_verifica  ; Jump para verificar a condição
%endmacro

%macro FOR_COND 4
    %1##_verifica:     ; Label para verificar a condição
    cmp dword [%2], %3 ; Comparação da variável do loop
    %4 %1##_fim        ; Fazer o jump condicionalmente caso seka falso (exemplo, jge para i >= limite)
%endmacro

%macro FOR_INC 2
    inc dword [%2]     ; Fazer o incremento da variável do loop
    jmp %1##_verifica  ; Jump para verificar a condição
%endmacro

%macro FOR_FIM 1
    %1##_fim:          ; Label de fim
%endmacro

section .bss
    i resd 1                      ; Designar espaço para a variável do loop
    num resb 12                   ; Buffer referente a string do número

section .data
    nl db 10                      ; Caractere para nova linha

section .text
    extern printf
    global _start

_start:
    ; Definir o loop
    FOR meu_loop, i, 0
    FOR_COND meu_loop, i, 10, jge

    ; Corpo do loop
    ; Imprimir o valor de i
    mov eax, dword [i]           ; Receber o valor de i
    call imprime_num             ; Fazer a impressão do número

    ; Imprimir nova linha
    mov eax, 4                   ; syscall: sys_write
    mov ebx, 1                   ; descritor de arquivo: stdout
    mov ecx, nl                  ; endereço do caractere de nova linha
    mov edx, 1                   ; número de bytes
    int 0x80                     ; syscall

    FOR_INC meu_loop, i
    FOR_FIM meu_loop

    ; Finalização do programa
    mov eax, 1                   ; syscall: sys_exit
    xor ebx, ebx                 ; status: 0
    int 0x80                     ; syscall

imprime_num:
    ; Fazer a conversão do inteiro em eax para string em num
    mov ecx, num + 11            ; Apontar ecx para o final do buffer
    mov byte [ecx], 0            ; Terminar a string com nulo
    mov ebx, 10                  ; Divisor para a conversão
.loop_conversao:
    xor edx, edx                 ; Limpar edx
    div ebx                      ; Dividir eax por 10
    add dl, '0'                  ; Converter o resto para ASCII
    dec ecx                      ; Mover para o caractere anterior
    mov [ecx], dl                ; Armazenar caractere
    test eax, eax                ; Verificar se o quociente é 0
    jnz .loop_conversao          ; Se não, continuar convertendo

    ; Imprimir a string em num
    mov eax, 4                   ; syscall: sys_write
    mov ebx, 1                   ; descritor de arquivo: stdout
    mov edx, num + 11            ; Fim da string
.encontra_nulo:
    dec edx                      ; Mover para o caractere anterior
    cmp byte [edx], 0            ; Encontrar o terminador nulo
    jnz .encontra_nulo           ; Loop até o terminador nulo
    mov edx, num + 11            ; Fim da string
    sub edx, ecx                 ; Comprimento da string
    int 0x80                     ; fazer syscall
    ret

section .data
    dez db 10                    ; Valor constante 10
