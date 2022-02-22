  # analyze.asm
  # This file written 2015 by F Lundevall
  # Copyright abandoned - this file is in the public domain.

	.text
main:
	li	$s0,0x30	# Load immediate 0 till $s0
loop:
	move	$a0,$s0		# kopierar värdet från $s0 (0) to $a0
	
	li	$v0,11		# syscall med v0 = 11 kommer printas ut -
	syscall			# en "byte" från a0 till Run I/O fönstret

	addi	$s0,$s0,3	# konstanten är ändrad till 3 för att printa ut var tredje värde
	
	li	$t0,0x5d        # 0x5b "[" är ändrad till 0x5d "]" för att få programmet att stanna, 0x5d är tredje värdet efter Z.
	bne	$s0,$t0,loop    # "Branch not equal" för att kolla om stopp-värdet är samma som det nuvarande värdet och då stoppa loopen.
	nop			# Färdig med operation
	
stop:	j	stop		# loopa i oändlighet här
	nop			# Färdig med operation

