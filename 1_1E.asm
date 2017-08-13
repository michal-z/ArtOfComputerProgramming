; Algorithm 1.1E (Euclids's algorithm) implemented in x86_64 assembly language.
; To generate executable file run 'fasm.exe 1_1E.asm' on the command line.

format PE64 console
entry Start

section '.text' code readable executable

gcd:    PUSH    r12 r13
        SUB     rsp,40
        MOV     r12,rcx
        MOV     r13,rdx
        CMP     rcx,rdx
        JBE     .1
        XCHG    rcx,rdx
.1:     MOV     rax,rdx
        XOR     edx,edx
        DIV     rcx
        TEST    rdx,rdx
        JZ      .2
        XCHG    rdx,rcx
        JMP     .1
.2:     MOV     r9,rcx
        LEA     rcx,[_answer]
        MOV     rdx,r12
        MOV     r8,r13
        CALL    [printf]
        ADD     rsp,40
        POP     r13 r12
        RET
Main:   SUB     rsp,40
        MOV     rcx,270
        MOV     rdx,192
        CALL    gcd
        MOV     rcx,177
        MOV     rdx,137688
        CALL    gcd
        ADD     rsp,40
        RET
Start:  SUB     rsp,40
        LEA     rcx,[_kernel32]
        CALL    [LoadLibrary]
        MOV     [kernel32],rax                  ; kernel32.dll
        LEA     rcx,[_msvcrt]
        CALL    [LoadLibrary]
        MOV     [msvcrt],rax                    ; msvcrt.dll
        MOV     rcx,[kernel32]
        LEA     rdx,[_ExitProcess]
        CALL    [GetProcAddress]
        MOV     [ExitProcess],rax               ; ExitProcess
        MOV     rcx,[msvcrt]
        LEA     rdx,[_getch]
        CALL    [GetProcAddress]
        MOV     [getch],rax                     ; getch
        MOV     rcx,[msvcrt]
        LEA     rdx,[_printf]
        CALL    [GetProcAddress]
        MOV     [printf],rax                    ; printf
        CALL    Main
        LEA     rcx,[_exit]
        CALL    [printf]
        CALL    [getch]
        XOR     ecx,ecx
        CALL    [ExitProcess]

section '.data' data readable writeable

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
