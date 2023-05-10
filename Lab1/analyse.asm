  # analyze.asm
  # This file written 2015 by F Lundevall. Edited 2022 by T Gustafsson
  # Copyright abandoned - this file is in the public domain.

	.text
main:
	li	$s0,0x30	# ASCII 0x30 = 0. Char 0 loads into s0
loop:
	move	$a0,$s0		# copy contents of s0 to a0 

	li	$v0,11		# function in SYSCALL system services: (v0, 11) a0 = char to print
	syscall			# will print char contained in a0 to Run I/O window

	addi	$s0,$s0,3	# adding immidiate value  3 to s0. CHANGED from 1 to 3
	
	li	$t0,0x5d	# 0x5b ([) to 0x5d (]).
	bne	$s0,$t0,loop	# If s0 not equal to t0 0x5d (]), loop. Else stop.
	
	nop			# delay slot filler (just in case)

stop:	j	stop		# loop forever here
	nop			# delay slot filler (just in case)
