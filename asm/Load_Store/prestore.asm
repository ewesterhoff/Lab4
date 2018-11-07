li $sp 0x3ffc

la 	$t0, my_array		# Store array base address in register (la pseudoinstruction)
addi	$t1, $zero, 3		# 6 elements in array, go through half of array
addi	$t7, $zero, 5		# 6 elements in array

# Solution pseudocode:
#    i = 0;
#    while i < 3 {
#	temp_var1 = my_array[i]
#	temp_var2 = my_array[8-i]
#       my_array[i] = temp_var2
#	my_array[6-i] = temp_var1
#	i++ }

# Initialize variables
addi	$t2, $zero, 0		# i, the current array element being accessed
addi	$t3, $t0, 0		# address of my_array[i] (starts from base address for i=0)
addi 	$t6, $t3, 20

lw	$t4, ($t3)		# temp1 = my_array[i]		{LOAD FROM MEMORY}
lw	$t5, ($t6)		# temp2 = my_array[8-i]		{LOAD FROM MEMORY}

sw	$t4, ($t6)		# my_array[i] = temp1		{STORE TO MEMORY}
sw	$t5, ($t3)		# my_array[8-i] = temp2		{STORE TO MEMORY}

addi	$t2, $t2, 1		# increment i counter
addi	$t3, $t3, 4		# increment address by 1 word
subi	$t6, $t6, 4		# increment address back by 1 word

lw	$t4, ($t3)		# temp1 = my_array[i]		{LOAD FROM MEMORY}
lw	$t5, ($t6)		# temp2 = my_array[8-i]		{LOAD FROM MEMORY}

sw	$t4, ($t6)		# my_array[i] = temp1		{STORE TO MEMORY}
sw	$t5, ($t3)		# my_array[8-i] = temp2		{STORE TO MEMORY}

addi	$t2, $t2, 1		# increment i counter
addi	$t3, $t3, 4		# increment address by 1 word
subi	$t6, $t6, 4		# increment address back by 1 word

lw	$t4, ($t3)		# temp1 = my_array[i]		{LOAD FROM MEMORY}
lw	$t5, ($t6)		# temp2 = my_array[8-i]		{LOAD FROM MEMORY}

sw	$t4, ($t6)		# my_array[i] = temp1		{STORE TO MEMORY}
sw	$t5, ($t3)		# my_array[8-i] = temp2		{STORE TO MEMORY}


# Pre-populate array data in memory
#  Note that I have given the data values a distinctive pattern to help with debugging
.data 
my_array:
0x11110000	# my_array[0]
0x22220000
0x44440000
0x66660000
0x88880000
0xAAAA0000