add $zero, $zero, $zero
add $zero, $zero, $zero

addi $t0, $zero, 10
addi $t1, $zero, 21
beq $t0, $t1, target

addi $t2, $zero 31
jal target
addi $t3, $zero, 10
j end

target:
addi $ra, $zero,48
add $t4,$t0,$t1
sub $t3,$t2,$t0

jr $ra
addi $t0, $zero, 10

end:
j end
