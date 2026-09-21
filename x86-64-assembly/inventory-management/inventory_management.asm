; Everything that comes after a semicolon (;) is a comment

WEIGHT_OF_EMPTY_BOX equ 500
TRUCK_HEIGHT equ 300
PAY_PER_BOX equ 5
PAY_PER_TRUCK_TRIP equ 220

section .text

; You should implement functions in the .text section
; A skeleton is provided for the first function

; the global directive makes a function visible to the test files
global get_box_weight
get_box_weight:
    ; This function takes the following parameters:
    ; - The number of items for the first product in the box, as a 16-bit non-negative integer
    ; - The weight of each item of the first product, in grams, as a 16-bit non-negative integer
    ; - The number of items for the second product in the box, as a 16-bit non-negative integer
    ; - The weight of each item of the second product, in grams, as a 16-bit non-negative integer
    ; The function must return the total weight of a box, in grams, as a 32-bit non-negative integer

    ; backup rdx as is crucial for division
    movzx r12d, dx
    ; first item weight computation
    xor rdx, rdx
    movzx eax, di
    mul eax, esi
    ; save result in rdi (no longer needed)
    mov edi, eax
    ; Second item weight computation
    xor rdx, rdx
    mov eax, r12d
    mul eax, ecx

    ; Add the first item weight result
    add eax, edi
    add eax, WEIGHT_OF_EMPTY_BOX
    ret

global max_number_of_boxes
max_number_of_boxes:
    ; TODO: define the 'max_number_of_boxes' function
    ; This function takes the following parameter:
    ; - The height of the box, in centimeters, as a 8-bit non-negative integer
    ; The function must return how many boxes can be stacked vertically, as a 8-bit non-negative integer
    mov ax, TRUCK_HEIGHT
    div dil
    ret

global items_to_be_moved
items_to_be_moved:
    ; TODO: define the 'items_to_be_moved' function
    ; This function takes the following parameters:
    ; - The number of items still unaccounted for a product, as a 32-bit non-negative integer
    ; - The number of items for the product in a box, as a 32-bit non-negative integer
    ; The function must return how many items remain to be moved, after counting those in the box, as a 32-bit integer
    sub edi, esi
    mov eax, edi
    ret

global calculate_payment
calculate_payment:
    ; TODO: define the 'calculate_payment' function
    ; This function takes the following parameters:
    ; - (rdi) The upfront payment, as a 64-bit non-negative integer
    ; - (rsi) The total number of boxes moved, as a 32-bit non-negative integer
    ; - (rdx) The number of truck trips made, as a 32-bit non-negative integer
    ; - (rcx) The number of lost items, as a 32-bit non-negative integer
    ; - (r8) The value of each lost item, as a 64-bit non-negative integer
    ; - (r9) The number of other workers to split the payment/debt with you, as a 8-bit positive integer
    ; The function must return how much you should be paid, or pay, at the end, as a 64-bit integer (possibly negative)
    ; Remember that you get your share and also the remainder of the division
    ; store rdx in r12 as will be overriden by mul
    mov r12, rdx

    xor rax, rax
    mov eax, PAY_PER_BOX
    mul esi
    ; r13 will be our accumulator
    mov r13, rax
    mov rax, PAY_PER_TRUCK_TRIP
    mul r12
    add r13, rax

    ; Lost items cost
    mov rax, rcx
    mul r8
    sub r13, rax ; sub lost items
    sub r13, rdi ; sub upfront pay

    mov rax, r13
    cqo ; Sign-extends RAX into RDX, this allows to get negative results
    inc r9 ; you + the worker
    idiv r9
    add rax, rdx ; add the remainder (pay/debt) to result
    ret

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
