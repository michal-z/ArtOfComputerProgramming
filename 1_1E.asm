; Algorithm 1.1E (Euclids's algorithm)
format pe64 console
entry start

section '.text' code readable executable

align 16
main:
        ret

align 16
start:
        sub     rsp,40                  ; 32 bytes for shadow space, 8 bytes for 16 byte alignment
        lea     rcx,[_kernel32_dll]
        call    [LoadLibrary]
        mov     [kernel32_dll],rax
        lea     rcx,[_msvcrt_dll]
        call    [LoadLibrary]
        mov     [msvcrt_dll],rax
        mov     rcx,[kernel32_dll]
        lea     rdx,[_ExitProcess]
        call    [GetProcAddress]
        mov     [ExitProcess],rax
        mov     rcx,[msvcrt_dll]
        lea     rdx,[_getch]
        call    [GetProcAddress]
        mov     [getch],rax
        mov     rcx,[msvcrt_dll]
        lea     rdx,[_printf]
        call    [GetProcAddress]
        mov     [printf],rax
        call    main
        lea     rcx,[_exit_msg]
        call    [printf]
        call    [getch]
        xor     ecx,ecx
        call    [ExitProcess]

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
_exit_msg db 'Hit any key to close this window...',13,10,0

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
