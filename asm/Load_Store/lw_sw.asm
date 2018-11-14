li $sp 0x3ffc


addi	$t0, $zero, 5
addi $t1, $zero, 33

sw	$t0, 4($t1)
lw 	$t3, 4($t1)

addi	$t2, $zero, 8
addi	$t1, $zero, 9
