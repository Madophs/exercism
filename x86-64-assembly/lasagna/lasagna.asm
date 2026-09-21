; Everything that comes after a semicolon (;) is a comment

; Assembler-time constants may be defined using 'equ'

EXPECTED_MIN_OVEN equ 40
PREP_TIME_MIN equ 2

section .text

; You should implement functions in the .text section

; the global directive makes a function visible to the test files
global expected_minutes_in_oven
expected_minutes_in_oven:
    ; TODO: This function has no arguments
    mov rax, EXPECTED_MIN_OVEN
    ret

global remaining_minutes_in_oven
remaining_minutes_in_oven:
    ; TODO: define the 'remaining_minutes_in_oven' function
    call expected_minutes_in_oven
    ; substract remaining time (rdi) from expected time (rax)
    sub rax, rdi
    ret

global preparation_time_in_minutes
preparation_time_in_minutes:
    ; TODO: define the 'preparation_time_in_minutes' function
    mov rax, rdi
    imul rax, PREP_TIME_MIN
    ret

global elapsed_time_in_minutes
elapsed_time_in_minutes:
    ; TODO: define the 'elapsed_time_in_minutes' function
    call preparation_time_in_minutes
    add rax, rsi
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
