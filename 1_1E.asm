; Algorithm 1.1E (Euclids's algorithm) implemented in x86_64 assembly language.
; To generate executable file run 'fasm.exe 1_1E.asm' on the command line.

format PE64 console
entry start

macro falign { align 16 }

section '.text' code readable executable

falign
gcd:
        push    r12 r13
        sub     rsp,40
        mov     r12,rcx
        mov     r13,rdx
        cmp     rcx,rdx
        jbe     .compute_loop
        xchg    rcx,rdx
    .compute_loop:
        mov     rax,rdx
        xor     edx,edx
        div     rcx
        test    rdx,rdx
        jz      .done
        xchg    rdx,rcx
        jmp     .compute_loop
    .done:
        mov     r9,rcx
        lea     rcx,[_answer]
        mov     rdx,r12
        mov     r8,r13
        call    [printf]
        add     rsp,40
        pop     r13 r12
        ret

falign
main:
        sub     rsp,40
        mov     rcx,270
        mov     rdx,192
        call    gcd
        mov     rcx,177
        mov     rdx,137688
        call    gcd
        add     rsp,40
        ret

falign
start:
        sub     rsp,40
        lea     rcx,[_kernel32]
        call    [LoadLibrary]
        mov     [kernel32],rax                  ; kernel32.dll
        lea     rcx,[_msvcrt]
        call    [LoadLibrary]
        mov     [msvcrt],rax                    ; msvcrt.dll
        mov     rcx,[kernel32]
        lea     rdx,[_ExitProcess]
        call    [GetProcAddress]
        mov     [ExitProcess],rax               ; ExitProcess
        mov     rcx,[msvcrt]
        lea     rdx,[_getch]
        call    [GetProcAddress]
        mov     [getch],rax                     ; getch
        mov     rcx,[msvcrt]
        lea     rdx,[_printf]
        call    [GetProcAddress]
        mov     [printf],rax                    ; printf
        call    main
        lea     rcx,[_exit]
        call    [printf]
        call    [getch]
        xor     ecx,ecx
        call    [ExitProcess]

section '.data' data readable writeable

input0          dq 0
input1          dq 0
iter            dq 0

align 8
kernel32        dq 0
msvcrt          dq 0
getch           dq 0
ExitProcess     dq 0
printf          dq 0

_kernel32       db 'kernel32.dll',0
_msvcrt         db 'msvcrt.dll',0
_ExitProcess    db 'ExitProcess',0
_getch          db '_getch',0
_printf         db 'printf',0
_exit           db 'Hit any key to exit this program...',13,10,0
_answer         db 'Greatest common divisor of %d and %d is %d.',13,10,0

section '.idata' import data readable writeable

                dd 0,0,0
                dd rva _kernel32
                dd rva LoadLibrary
                dd 0,0,0,0,0
LoadLibrary     dq rva _LoadLibrary
GetProcAddress  dq rva _GetProcAddress
                dq 0
_LoadLibrary    dw 0
                db 'LoadLibraryA',0
_GetProcAddress dw 0
                db 'GetProcAddress',0
