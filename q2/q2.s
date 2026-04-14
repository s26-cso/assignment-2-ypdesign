.section .rodata
fmt_out:
  .string "%d "
fmt_out1:
  .string "%d\n"
.section .text
.globl main
# stack_empty (if size == 0 then 1 else 0)
stack_empty:
   beq a0, x0,empty
   li a0,0
   ret
empty:
   li a0, 1
   ret
 # stack.top  returns the index on the top of stack
stack.top:
  addi t1, a1 ,-1
  slli t1, t1, 2
  add t0, a0, t1
  lw a0, 0(t0) 
  ret
  # stack.pop (decreases size by 1 )
stack.pop:
addi a0,a0,-1
ret
# we push the array index into the stack
stack.push:
   slli t0 ,a1, 2 
   add t0, a0,t0
   sw a2, 0(t0)
   addi a0,a1, 1
   ret

main:
   addi sp,sp, -80
   sd ra, 0(sp) 
   sd s0, 8(sp) # arr base
   sd s1, 16(sp) # stack base
   sd s2, 24(sp) # stack size
   sd s3, 32(sp) # number of elements
   sd s4, 40(sp) # result arr base
   sd s5, 48(sp) # loop index
   sd s6, 56(sp)    # argv base
  # malloc applied to the arrays 

   addi s3,a0,-1 # to shift to 0's indexing
   mv s6, a1
   li s5, 0
  # checking the limit on no of elements in CLI is 1e9
   li t0, 1000000000
   bgt s3, t0, input_limit_error
  # arr
   slli a0, s3, 2
   call malloc
   beq a0,x0, malloc_error
   mv s0,a0
  # stack
   slli a0,s3,2
   call malloc
   beq a0,x0, malloc_error
   mv   s1, a0
  # result
   slli a0,s3, 2
   call malloc
   beq a0,x0, malloc_error
   mv s4, a0
# Read each argv[i] and convert to int with atoi
  string_loop:
    bge s5,s3,done

    addi t0,s5, 1
    slli t0,t0, 3
    add t0, s6,t0
    ld a0, 0(t0)
    call atoi

    slli t0, s5, 2
    add t0, s0, t0
    sw a0, 0(t0)

    addi s5, s5, 1
    j string_loop

  done: 
    addi s5, s3, -1
    li s2, 0

# Build the monotonic stack from right to left
# Store the next-greater candidate or -1 if none exists
# Print the result array
 func_loop:
   blt s5, x0, exit

 inner_loop:
  mv a0,s2
  call stack_empty
  bne a0,x0, inner_done

  mv a0, s1
  mv a1, s2
  call stack.top

  slli t0,a0, 2
  add t0, s0,t0
  lw t2,0(t0)

   # we are targetting specific array element from base address bu adding offset
  slli t3,s5, 2
  add t4, s0,t3
  lw  t3,0(t4)

  # check the contrasting condition of what should be there to continue the loop
  bgt t2,t3,inner_done
  mv a0,s2
  call stack.pop
  mv s2, a0
  j inner_loop

inner_done:
  mv a0,s2
  call stack_empty
  bne a0,x0 ,store_neg
  mv a0, s1
  mv a1, s2
  call stack.top
  slli t0, a0, 2
  add t0, s0, t0
  lw a0,0(t0)
  j store_final

store_neg:
  li a0, -1

store_final:
   slli t1, s5, 2
   add t2, s4, t1
   sw a0, 0(t2)

   mv a0, s1
   mv a1, s2
   mv a2, s5
   call stack.push
   mv s2, a0

    addi s5,s5, -1
    j func_loop

 exit:
    li s5, 0

print_loop:
    bge s5, s3, print_done

    slli t0, s5, 2
    add  t0, s4, t0
    lw   a1, 0(t0)         

    addi t0, s3, -1
    beq  s5, t0, last     

    la   a0, fmt_out        
    j    do_print

last:
    la   a0, fmt_out1      

do_print:
    call printf

    addi s5, s5, 1
    j    print_loop

print_done:
    ld ra,  0(sp)
    ld s0,  8(sp)
    ld s1, 16(sp)
    ld s2, 24(sp)
    ld s3, 32(sp)
    ld s4, 40(sp)
    ld s5, 48(sp)
    ld s6, 56(sp)
    addi sp, sp, 80
    li   a0, 0
    ret

   input_limit_error:    
    malloc_error:
    ld ra,  0(sp)
    ld s0,  8(sp)
    ld s1, 16(sp)
    ld s2, 24(sp)
    ld s3, 32(sp)
    ld s4, 40(sp)
    ld s5, 48(sp)
    ld s6, 56(sp)
    addi sp, sp, 80
    li   a0, 1
    ret  
   










     
  

    


