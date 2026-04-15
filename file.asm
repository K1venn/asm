section .data
    filename       db  "readme.txt", 0
    content        db  "Yes Sir"
    content_length equ $ - content

section .bss
    bytesWritten resq 1
    
section .text
    global _start
    extern WriteFile
    extern CloseHandle
    extern CreateFileA
    extern ExitProcess

_start:
    sub rsp, 64

    call _readme

    jmp Exit

_readme:
    mov rcx, filename
    mov rdx, 0x40000000 ; GENERIC_WRITE
    mov r8,  3          ; FILE_SHARE_READ | FILE_SHARE_WRITE
    xor r9,  r9         ; lpSecurityAttributes = NULL

    mov qword [rsp+32], 2    ; CREATE_ALWAYS
    mov qword [rsp+40], 0x80 ; FILE_ATTRIBUTE_NORMAL
    mov qword [rsp+48], 0    ; hTemplateFile = NULL

    call CreateFileA

    mov rbx, rax ; save handle

    mov rcx, rax
    mov rdx, content
    mov r8,  content_length
    lea r9,  [rel bytesWritten]

    mov  qword [rsp+32], 0
    call WriteFile

    mov  rcx, rbx
    call CloseHandle

    ret

Exit:
    xor  rcx, rcx
    call ExitProcess