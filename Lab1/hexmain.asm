  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.
  # Edited 2022-01-20 by T Gustafsson

	.text
main:
	li	$a0,10		# change this to test different values

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

  # You can write your own code for hexasc here
  #
hexasc:
	andi 	$a0,$a0, 0xf 		# to keep the 4 LSB in the argument
	
	ble 	$a0, 0x9, number	# branch if the input is less than or equal to 9, else continue
	nop				# delay slot filler (just in case)
	
	ble 	$a0, 0xf, char		# branch if the input if less than or equal to 15 (but greater than 9)
	nop				# delay slot filer (just in case)
	
	number:				# 0-9
	addi	$v0, $a0, 0x30		# ASCII numbers start at 0x30 (0), so add $a0 to that for correct output 
	jr	$ra			
	nop
	
	char:				# 10-15
	addi	$v0, $a0, 0x37		# ASCII letters start at 0x41 (A)
	jr	$ra
	nop
