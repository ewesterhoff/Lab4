addi $t0, $zero, 10
addi $t1, $zero, 20

beq $t0, $t1, equal
addi $zero, $zero, 0
addi $zero, $zero, 0

bne $t0, $t1, noteq
addi $zero, $zero, 0
addi $zero, $zero, 0

equal:
j equal

noteq:
j noteq