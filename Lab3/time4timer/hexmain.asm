  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.
	.text
main:
	li	$a0,16        # change this to test different values

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
   	andi	$a0,$a0,0xf		# To Keep the 4 Least significant bits in the argument

   	ble 	$a0,0x9,number		# if branch ($a0) is less or equal to 0xa, gå till nummer
   	nop				# delay slot filler (just in case)

   	ble	$a0,0xf,char		# if branch ($v0) is less or equal to 0xf, gå till char
   	nop				# delay slot filler (just in case)

   	number:				# 0-9
   	addi	$v0,$a0,0x30		# adderar $a0 värdet med noll och sparar det i $v0
   	jr	$ra
   	nop				# delay slot filler (just in case)

   	char:				# 10-15
   	addi	$v0,$a0,0x37		# adderar symbolen 7 med värdet och sparar det i $v0
   	jr	$ra
   	nop				# delay slot filler (just in case)
