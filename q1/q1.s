.globl make_node
.globl insert
.globl get
.globl getAtMost
.text
make_node:
 addi sp,sp,-16
 sd ra,8(sp)
 sw a0,0(sp)
 li a0,24
 call malloc
 beq a0,x0,null_done
 lw t0,0(sp)
 sw t0,0(a0)
 sd x0,8(a0)
 sd x0,16(a0)
null_done:
 ld ra,8(sp)
 addi sp,sp,16
 ret
insert:
 bne a0,x0,recursion
 mv a0,a1
 j make_node
 ret
recursion:
 addi sp,sp,-32
 sd ra,24(sp)
 sd s0,16(sp)
 sd s1,8(sp)
 mv s0,a0
 mv s1,a1
 lw t0,0(s0)
 blt s1,t0,left
 j right
left:
 ld a0,8(s0)
 mv a1,s1
 call insert
 sd a0,8(s0)
 j end_insert
right:
 ld a0,16(s0)
 mv a1,s1
 call insert
 sd a0,16(s0)
end_insert:
 mv a0,s0
 ld ra,24(sp)
 ld s0,16(sp)
 ld s1,8(sp)
 addi sp,sp,32
 ret
get:
 beq a0,x0,ret_null
 lw t0,0(a0)
 beq t0,a1,found
 blt a1,t0,left_g
right_g:
 ld a0,16(a0)
 j get
left_g:
 ld a0,8(a0)
 j get
found:
 ret
ret_null:
 mv a0,x0
 ret
getAtMost:
 li t2,-1
loop:
 beq a1,x0,end
 lw t0,0(a1)
 bgt t0,a0,left_m
 mv t2,t0
 ld a1,16(a1)
 j loop
left_m:
 ld a1,8(a1)
 j loop
end:
 mv a0,t2
 ret
