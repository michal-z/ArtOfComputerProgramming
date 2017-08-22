; Greatest common divisor (gcd).
; Algorithm 1.1E (Euclids's algorithm) implemented in x86_64 assembly language.
; To generate executable file open it in fasmw.exe editor and press F9.

format PE64 console
entry start

macro falign { align 16 }
macro icall addr* { call [addr] }
macro locals {
    virtual at rsp
    .shadow_ dq ?,?,?,?
    .fparam5 dq ?
    .fparam6 dq ?
    .fparam7 dq ?
    .fparam8 dq ?
}
macro endl {
    .localsize = $-$$
    end virtual
}

section '.text' code readable executable

falign
gcd:                            ; in: m (rcx), n (rdx) both positive integers
        cmp     rcx,rdx         ; switch m <-> n so that m = rdx, n = rcx (for easier division)
        jbe     .compute_loop   ; also make sure that n < m
        xchg    rcx,rdx
    .compute_loop:
        mov     rax,rdx         ; mov m (rdx) to rax for division
        xor     edx,edx         ; zero out rdx for division
        div     rcx             ; divide m / n (rdx:rax / rcx)
        inc     [iter_count]
        test    rdx,rdx         ; remainder r = rdx, if (r == 0) n (rcx) is the answer
        jz      .done
        xchg    rdx,rcx         ; set m = n, n = r
        jmp     .compute_loop   ; repeat
    .done:
        mov     rax,rcx
        ret
falign
print_answer:
    locals
    .m dq ?
    .n dq ?
    .d dq ?
    endl
        sub     rsp,.localsize
        mov     [.m],rcx
        mov     [.n],rdx
        mov     [.d],r8
        lea     rcx,[_answer]
        mov     rdx,[.m]
        mov     r8,[.n]
        mov     r9,[.d]
        mov     eax,[iter_count]
        mov     dword[.fparam5],eax
        icall   printf
        add     rsp,.localsize
        ret
falign
main:
        sub     rsp,32
        push    rsi
        xor     esi,esi
    .loop:
        mov     rcx,[inputs+rsi*8]
        test    rcx,rcx
        jz      .exit
        mov     rdx,[inputs+rsi*8+8]
        mov     [iter_count],0
        call    gcd
        mov     rcx,[inputs+rsi*8]
        mov     rdx,[inputs+rsi*8+8]
        mov     r8,rax
        call    print_answer
        add     esi,2
        jmp     .loop
    .exit:
        pop     rsi
        add     rsp,32
        ret
falign
start:
        sub     rsp,40
        lea     rcx,[_kernel32]
        icall   LoadLibrary
        mov     [kernel32],rax                  ; kernel32.dll
        lea     rcx,[_msvcrt]
        icall   LoadLibrary
        mov     [msvcrt],rax                    ; msvcrt.dll
        mov     rcx,[kernel32]
        lea     rdx,[_ExitProcess]
        icall   GetProcAddress
        mov     [ExitProcess],rax               ; ExitProcess
        mov     rcx,[msvcrt]
        lea     rdx,[_getch]
        icall   GetProcAddress
        mov     [getch],rax                     ; getch
        mov     rcx,[msvcrt]
        lea     rdx,[_printf]
        icall   GetProcAddress
        mov     [printf],rax                    ; printf
        call    main
        lea     rcx,[_exit]
        icall   printf
        icall   getch
        xor     ecx,ecx
        icall   ExitProcess

section '.data' data readable writeable

inputs          dq 270,192, 177,137688, 1000,10, 37123781,27821, 19999999999999,19999912341, 0
iter_count      dd 0

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
_answer         db 'gcd(%llu, %llu) = %llu (Number of iterations: %u).',13,10,0

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
