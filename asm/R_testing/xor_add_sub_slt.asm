add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

li $sp 0x3ffc

addi	$t0, $zero, 21		# i, the current array element being accessed
addi	$t1, $zero, 30	

add $t2, $t0, $t1	#51
add $zero, $zero, $zero
add $zero, $zero, $zero
sub $t3, $t0, $t1	#-9

xori $t4, $t0, 42	#21 xori 42 
xori $t5, $t0, 21	#21 xori 21

slt $t6, $t0, $t1
slt $t7, $t1, $t0

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
