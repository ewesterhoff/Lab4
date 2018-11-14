li $sp 0x3ffc

addi $t0, $zero, 5
addi $t1, $zero, 6

j TARGET:

addi $t3, $t0, 2

TARGET:
addi	$t4, $t1, 1
addi	$t5, $t0, 1
