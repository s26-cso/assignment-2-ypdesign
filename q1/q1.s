.globl make_node
.globl insert
.globl get
.globl getAtMost
.text

make_node:
 addi sp,sp, -16
 sd ra, 8(sp)
 sw a0,0(sp)

 li a0,24
 call malloc

 beq a0,x0,null_done
 lw t0, 0(sp)
 sw t0, 0(a0)
 sd x0, 8(a0)
 sd x0, 16(a0)

null_done:
 ld ra, 8(sp)
 addi sp,sp, 16
 ret

insert:
  bne a0,x0,recursion
  mv a0,a1
  j make_node
recursion:
   addi sp, sp, -32
   sd ra, 24(sp)
   sd s0, 16(sp)
   sd s1, 8(sp)
   mv s0, a0
   mv s1, a1
   lw t0,0(s0)

   bge s1,t0,right

left:
 ld a0,8(s0)
 mv a1, s1
 call insert
 sd a0, 8(s0)
 j insertion_end

right:
  ld a0,16(s0)
  mv a1,s1
  call insert
  sd a0, 16(s0)

insertion_end:
  mv a0, s0
  ld ra, 24(sp)
  ld s0, 16(sp)
  ld s1, 8(sp)
  addi sp,sp, 32
  ret

get:
  bne a0, x0, check
  ret
check: 
  lw t0, 0(a0)            
  ld t1, 8(a0)            
  beq t0, a1, found       
  bge a1, t0, get_right   
get_left:                 
  mv a0, t1               
  j get  
get_right:
  ld a0, 16(a0)           
  j get
found:
  ret

getAtMost:
  li t2, -1
  bne a1, x0, loop
  j end
loop:
  lw t0, 0(a1)
  bgt t0, a0, getAtMost_left
  mv t2, t0
  ld a1, 16(a1)
  bne a1, x0, loop
  j end
getAtMost_left:
  ld a1, 8(a1)
  bne a1, x0, loop
end:
  mv a0, t2
  ret






