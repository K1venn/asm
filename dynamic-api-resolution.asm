section .data
    user32 db "user32.dll", 0
    msgbox db "MessageBoxA", 0
    title  db "Title", 0
    body   db "Body!", 0

section .text
    global _start
    extern LoadLibraryA
    extern GetProcAddress
    extern ExitProcess

_start:
    sub rsp, 28h

    ; LoadLibraryA("user32.dll")
    lea  rcx, [rel user32]
    call LoadLibraryA
    test rax, rax
    jz   fail
    mov  rbx, rax

    ; GetProcAddress(handle, "MessageBoxA")
    mov  rcx, rbx
    lea  rdx, [rel msgbox]
    call GetProcAddress
    test rax, rax
    jz   fail
    mov  r12, rax

    ; MessageBoxA(NULL, "Body!", "Title", MB_OK)
    xor  rcx, rcx
    lea  rdx, [rel body]
    lea  r8,  [rel title]
    xor  r9,  r9
    call r12

fail:
    xor  rcx, rcx
    call ExitProcess