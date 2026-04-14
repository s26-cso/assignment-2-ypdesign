.globl make_node
.globl insert
.globl get
.globl getAtMost
.text
# make_node
# 24 bytes taken 
# for int value,left ptr,right ptr

make_node:
 addi sp,sp,-16 
 sd ra,8(sp) # store the return adress
 sw a0,0(sp) # the int value( int)
 li a0,24
 call malloc
 beq a0,x0,null_done
 lw t0,0(sp) # load the value into temp register t0
 sw t0,0(a0) # node->value=value
 sd x0,8(a0) # node->left=NULL
 sd x0,16(a0) # node->right=NULL
null_done:
 ld ra,8(sp)
 addi sp,sp,16
 ret
 # insert the value into a bst with given tree and value as input
insert:
 bne a0,x0,recursion # a0 is the ptr to root if not null then we go forward with recursive calls
 mv a0,a1
 j make_node
recursion:
 addi sp,sp,-32
 sd ra,24(sp)
 sd s0,16(sp)
 sd s1,8(sp)
 mv s0,a0
 mv s1,a1
 lw t0,0(s0) # we load node->value
 blt s1,t0,left # decides to go left or right
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
# get function take a0 as root,a1 as value
get:
 beq a0,x0,ret_null # null check on root
 lw t0,0(a0) # load the value
 beq t0,a1,found # if we find the given value then go found part
 blt a1,t0,left_g # comparator to decide to go to left or right
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
 # getAtMost input as the value and root 
getAtMost:
 li t2,-1
loop:
 beq a1,x0,end # checks if equal to 0
 lw t0,0(a1) # loads the value
 bgt t0,a0,left_m # decides to go to which subtree
 mv t2,t0
 ld a1,16(a1)
 j loop
left_m:
 ld a1,8(a1)
 j loop
end:
 mv a0,t2
 ret
