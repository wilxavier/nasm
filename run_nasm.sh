#!/bin/bash

# Nome do arquivo ASM sem a extensão
ASM_FILE="laco"

# Montar o código fonte ASM
nasm -f elf64 -o ${ASM_FILE}.o ${ASM_FILE}.asm
if [ $? -ne 0 ]; then
    echo "Erro ao montar o arquivo ${ASM_FILE}.asm"
    exit 1
fi

# Linkar o arquivo objeto
ld -o ${ASM_FILE} ${ASM_FILE}.o
if [ $? -ne 0 ]; then
    echo "Erro ao linkar o arquivo ${ASM_FILE}.o"
    exit 1
fi

# Executar o programa
./${ASM_FILE}
if [ $? -ne 0 ]; then
    echo "Erro ao executar o programa ${ASM_FILE}"
    exit 1
fi
