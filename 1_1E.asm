; Algorithm 1.1E (Euclids's algorithm) implemented in x86_64 assembly language.
; To generate executable file run 'fasm.exe 1_1E.asm' on the command line.

format pe64 console
entry start

macro icall addr* { call [addr] }

section '.text' code readable executable

align 16
gcd:
; in: m = rcx, n = rdx positive integers
        sub     rsp,40
        cmp     rcx,rdx                 ; [Ensure m >= n] If m < n, exchange m <-> n.
        jbe     .begin
        xchg    rcx,rdx
    .begin:                             ; rcx = n, rdx = m
        mov     rax,rdx                 ; rax = m
        xor     edx,edx
        div     rcx                     ; m / n
        test    rdx,rdx
        jz      .done
        xchg    rdx,rcx
        jmp     .begin
    .done:
        mov     rdx,rcx
        lea     rcx,[_divisor_is]
        icall   printf
        add     rsp,40
        ret

align 16
main:
        sub     rsp,40
        mov     rcx,180
        mov     rdx,60
        call    gcd
        add     rsp,40
        ret

align 16
start:
        sub     rsp,40                  ; 32 bytes for shadow space, 8 bytes for 16 byte alignment
        lea     rcx,[_kernel32_dll]
        icall   LoadLibrary
        mov     [kernel32_dll],rax
        lea     rcx,[_msvcrt_dll]
        icall   LoadLibrary
        mov     [msvcrt_dll],rax
        mov     rcx,[kernel32_dll]
        lea     rdx,[_ExitProcess]
        icall   GetProcAddress
        mov     [ExitProcess],rax
        mov     rcx,[msvcrt_dll]
        lea     rdx,[_getch]
        icall   GetProcAddress
        mov     [getch],rax
        mov     rcx,[msvcrt_dll]
        lea     rdx,[_printf]
        icall   GetProcAddress
        mov     [printf],rax
        call    main
        lea     rcx,[_exit_msg]
        icall   printf
        icall   getch
        xor     ecx,ecx
        icall   ExitProcess

section '.data' data readable writeable

align 8
kernel32_dll dq 0
msvcrt_dll dq 0
getch dq 0
ExitProcess dq 0
printf dq 0

_kernel32_dll db 'kernel32.dll',0
_msvcrt_dll db 'msvcrt.dll',0
_ExitProcess db 'ExitProcess',0
_getch db '_getch',0
_printf db 'printf',0
_exit_msg db 'Hit any key to exit this program...',13,10,0
_divisor_is db 'Greatest common divisor is %d.',13,10,0

section '.idata' import data readable writeable

dd 0,0,0,rva _kernel32_dll,rva _kernel32_table
dd 0,0,0,0,0

align 8
_kernel32_table:
  LoadLibrary dq rva _LoadLibrary
  GetProcAddress dq rva _GetProcAddress
  dq 0

_LoadLibrary dw 0
  db 'LoadLibraryA',0
_GetProcAddress dw 0
  db 'GetProcAddress',0
