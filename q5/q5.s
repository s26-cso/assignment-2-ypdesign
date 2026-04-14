.section .data
filename: .string "input.txt" # input file name
mode:     .string "r"
yes_str:  .string "Yes\n"
no_str:   .string "No\n"

.section .text
.globl main

main:
    addi sp, sp, -64
    sd   ra, 0(sp) # return adress
    sd   s0, 8(sp) # read from start
    sd   s1, 16(sp ) # read from end
    sd   s2, 24(sp) # loop counter
    sd   s3, 32(sp) # file length
    sd   s4, 40(sp) # char from start
    sd   s5, 48(sp) # char from end

    la   a0, filename
    la   a1, mode
    call fopen # opens input.txt
    mv   s0, a0 # store firsts file handle
    beqz s0, end_early # if any error while opening then close and exit

    la   a0, filename
    la   a1, mode
    call fopen
    mv   s1, a0  # store second file handle
    beqz s1, close_left # if any error while handling then close and exit

    mv   a0, s1
    li   a1, 0
    li   a2, 2
    call fseek # move to end of file

    mv   a0, s1
    call ftell # get the size of string inside input.txt
    mv   s3, a0 # store the size of string

    addi s3, s3, -1 # the right pointer to the string

    mv   a0, s1
    mv   a1, s3
    li   a2, 0
    call fseek

    mv   a0, s1
    call fgetc. # gets the next character
    li   t0, 10 # newline character
    bne  a0, t0, init_loop
    addi s3, s3, -1 # ignore trailing space

init_loop:
    li   s2, 0

check_loop:
    bge  s2, s3, print_yes

    mv   a0, s0
    call fgetc # read  char from start
    mv   s4, a0 # store the start char

    mv   a0, s1
    mv   a1, s3
    li   a2, 0
    call fseek

    mv   a0, s1
    call fgetc # read char from end
    mv   s5, a0 # store the end char

    bne  s4, s5, print_no # if not equal then it is not an palindrome

    addi s2, s2, 1 # increment loop counter
    addi s3, s3, -1  # move end index left
    j    check_loop

print_yes:
    la   a0, yes_str
    call printf
    j    cleanup

print_no:
    la   a0, no_str
    call printf

cleanup:
# close both file handles
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
    call fclose # close first handle
    j    end_early