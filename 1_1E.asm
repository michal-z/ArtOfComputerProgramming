; Algorithm 1.1E (Euclids's algorithm) implemented in x86_64 assembly language.
; To generate executable file run 'fasm.exe 1_1E.asm' on the command line.

format pe64 console
entry start

section '.text' code readable executable

gcd:    PUSH    r12 r13
        SUB     rsp,40
        MOV     r12,rcx
        MOV     r13,rdx
        CMP     rcx,rdx
        JBE     .begin
        XCHG    rcx,rdx
.begin: MOV     rax,rdx
        XOR     edx,edx
        DIV     rcx
        TEST    rdx,rdx
        JZ      .done
        XCHG    rdx,rcx
        JMP     .begin
.done:  MOV     r9,rcx
        LEA     rcx,[_answer]
        MOV     rdx,r12
        MOV     r8,r13
        CALL    [printf]
        ADD     rsp,40
        POP     r13 r12
        RET
main:   SUB     rsp,40
        MOV     rcx,270
        MOV     rdx,192
        CALL    gcd
        MOV     rcx,177
        MOV     rdx,137688
        CALL    gcd
        ADD     rsp,40
        RET
start:  SUB     rsp,40
        LEA     rcx,[_kernel32_dll]
        CALL    [LoadLibrary]
        MOV     [kernel32_dll],rax
        LEA     rcx,[_msvcrt_dll]
        CALL    [LoadLibrary]
        MOV     [msvcrt_dll],rax
        MOV     rcx,[kernel32_dll]
        LEA     rdx,[_ExitProcess]
        CALL    [GetProcAddress]
        MOV     [ExitProcess],rax
        MOV     rcx,[msvcrt_dll]
        LEA     rdx,[_getch]
        CALL    [GetProcAddress]
        MOV     [getch],rax
        MOV     rcx,[msvcrt_dll]
        LEA     rdx,[_printf]
        CALL    [GetProcAddress]
        MOV     [printf],rax
        CALL    main
        LEA     rcx,[_exit_msg]
        CALL    [printf]
        CALL    [getch]
        XOR     ecx,ecx
        CALL    [ExitProcess]

section '.data' data readable writeable

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
_answer db 'Greatest common divisor of %d and %d is %d.',13,10,0

section '.idata' import data readable writeable

dd 0,0,0,rva _kernel32_dll,rva _kernel32_table
dd 0,0,0,0,0

_kernel32_table:
  LoadLibrary dq rva _LoadLibrary
  GetProcAddress dq rva _GetProcAddress
  dq 0

_LoadLibrary dw 0
  db 'LoadLibraryA',0
_GetProcAddress dw 0
  db 'GetProcAddress',0
