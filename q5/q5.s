.section .data
filename: .string "input.txt"
mode:     .string "r"
yes_str:  .string "Yes\n"
no_str:   .string "No\n"

.section .text
.globl main

main:
    addi sp, sp, -64
    sd   ra, 0(sp)
    sd   s0, 8(sp)
    sd   s1, 16(sp)
    sd   s2, 24(sp)
    sd   s3, 32(sp)
    sd   s4, 40(sp)
    sd   s5, 48(sp)

    la   a0, filename
    la   a1, mode
    call fopen
    mv   s0, a0
    beqz s0, end_early

    la   a0, filename
    la   a1, mode
    call fopen
    mv   s1, a0
    beqz s1, close_left

    mv   a0, s1
    li   a1, 0
    li   a2, 2
    call fseek

    mv   a0, s1
    call ftell
    mv   s3, a0

    addi s3, s3, -1

    mv   a0, s1
    mv   a1, s3
    li   a2, 0
    call fseek

    mv   a0, s1
    call fgetc
    li   t0, 10
    bne  a0, t0, init_loop
    addi s3, s3, -1

init_loop:
    li   s2, 0

check_loop:
    bge  s2, s3, print_yes

    mv   a0, s0
    call fgetc
    mv   s4, a0

    mv   a0, s1
    mv   a1, s3
    li   a2, 0
    call fseek

    mv   a0, s1
    call fgetc
    mv   s5, a0

    bne  s4, s5, print_no

    addi s2, s2, 1
    addi s3, s3, -1
    j    check_loop

print_yes:
    la   a0, yes_str
    call printf
    j    cleanup

print_no:
    la   a0, no_str
    call printf

cleanup:
    mv   a0, s0
    call fclose
    
    mv   a0, s1
    call fclose

end_early:
    ld   ra, 0(sp)
    ld   s0, 8(sp)
    ld   s1, 16(sp)
    ld   s2, 24(sp)
    ld   s3, 32(sp)
    ld   s4, 40(sp)
    ld   s5, 48(sp)
    addi sp, sp, 64
    li   a0, 0
    ret

close_left:
    mv   a0, s0
    call fclose
    j    end_early