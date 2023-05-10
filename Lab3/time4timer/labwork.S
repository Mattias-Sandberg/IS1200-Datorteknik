  # labwork.S
  # Written 2015-2017 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1.
  # The macros PUSH and POP are in the public domain.
  # Please add your own code at the end of the file.

.global hexasc
.global delay
.global time2string
.global printDing
  #
  # Please keep the two macros PUSH and POP unchanged
  #
.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	\reg,0($sp)
.endm

.macro	POP reg
	lw	\reg,0($sp)
	addi	$sp,$sp,4
.endm
  #
  # Please add your own code below this line
  #
  .data
  .text
  
 hexasc:

	andi $t0, $a0, 0xf		# Bitwise AND, 0xf (15) to keep the 4 LSB from the argument and store in t0

	

	ble $t0, 0x9, number		# Branch if the input is less than or equal to 9, else continue

	nop				# delay slot filler

	

	ble $t0, 0xf, char		# Branch if the input is less than or equal to 15 and greater than 9

	nop				# Delay slot filler

	

	number:				# Subroutine for input 0-9

		addi $v0, $t0, 0x30	# ASCII numbers start at 30, so we add the input to zero (0x30)

		jr $ra			# Jump to return adress that was linked with function call		

		nop			# delay slot filler



	char:				# Subroutine for input 10-15

		addi $v0, $t0, 0x37	# Since ASCII letters start at 0x41, we add an offset of 7 

		jr $ra			# Jump to return adress that was linked with function call		

		nop			# delay slot filler



# Stub of the delay subroutine (Deprecated)

# delay:

#	jr $ra

#	nop

delay:	

	
	PUSH	$ra				# Sparar inehållet från $ra i stacken
	move 	$t1, $a0			# sparar värdet i $a0 temporärt så vi kan andvända det
	
	while:
		blt 	$t1, $zero, exit_delay	# kollar om $t1 (ms) är "branch less than" 0. om ms är mindre än noll, hoppa till exit_delay
		nop				# Slut på operation
		sub	$t1, $t1, 1 		# ms--, subtraherar 1 från ms efter varje "loop"
		
	li	$t2, 0				# Load immediate (int $t2 = 0)	
	for:
		bgt  	$t2, 4711, while	# kolla om 0 < andvändar input (ms), om det stämmer kör loopen annars hoppa till exit_delay
		nop				# Slut på operation
		addi	$t2, $t2, 1		# i++, adderar 1 till $t2 för varje gång loopen körs.
		j	for		        # går till nästa iteration av loopen
		nop				# Slut på operation
			
	exit_delay:				# slut på subroutine
		POP	$ra			# återhämtar retuneringsadressen från stacken
		jr	$ra			# Hoppar tillbaka till "Callar"
		nop				# Slut på operation
			


time2string:

	PUSH	$s0

	PUSH	$s1				 

	PUSH	$ra				

	move	$s1, $a1			

	move	$s0,$a0



	# First digit

	andi 	$t1, $s1, 0xf000		# Masking out bit from index 15 to 12

	srl 	$a0, $t1, 12			# Shifting bits right to lowest position, storing it in $a0 

	jal	hexasc				# 

	nop

	sb 	$v0, 0($s0)		 	# Saving the return value from hexasc in first position of $s0		



	# Second digit

	andi 	$t1, $s1, 0x0f00		# Masking out bit from index 11 to 8

	srl 	$a0, $t1, 8			# Shifting bits right to lowest position, storing it in $a0

	jal	hexasc				# Calling hexasc, converts decimal to hexadecimal

	nop

	sb 	$v0, 1($s0)		 	# Saving the return value from hexasc in second position of $s0	

				

	# Adding the colon

	li 	$t1, 0x3a			# Loading the ASCII for colon in $t1

	sb 	$t1, 2($s0)		 	# Saving the return value from hexasc in third position of $s0	

	

	# Third digit

	andi 	$t1, $s1, 0x00f0		# Mask out from index 7 to 4

	srl 	$a0, $t1, 4			# Shifting bits right to lowest position, storing it in $a0

	jal	hexasc				# Calling hexasc, converts decimal to hexadecimal

	nop					# Vi lägger till NOP (Null operation) Om vi inte gör detta kan instruktioner efter branchen köras före branchen.
						# Om det tar lämgre tid med delayd branching så vill man säkerställa att branchen körs klart innnan den hoppar till nästa program

	sb 	$v0, 3($s0)		 	# Saving the return value from hexasc in fourth position of $s0	

										

	# Forth digit

	andi 	$t1, $s1, 0x000f		# Masking out bit from index 3 to 0

	move 	$a0, $t1			# Shifting isn't necessary. Value is moved to $a0

	jal	hexasc				# Calling hexasc, converts decimal to hexadecimal

	nop

	sb 	$v0, 4($s0)		 	# Saving the return value from hexasc in fifth position of $s0	
	
	# Kollar om en minut har passerat
	andi 	$t1, $s1, 0x00ff		# Maskar ut sekundbitarna		
	beq 	$t1, 0x0000, printDing		# Om sekundbitarna = 0   (Branch if equal), hoppa till printDing funktionen
						

	# Adding the NUL byte

	li	$t1, 0x00			#

	sb 	$t1, 5($s0)		 	#

	j	exit_time2string		#



	# End of subroutine. Restoring registers and jumping back to caller.

	exit_time2string:																																																																																										

		POP	$ra

		POP	$s1

		POP	$s0	

 		jr 	$ra

 		nop	
 		
 		
 	printDing:
		li	$t1, 0x44		# sparar D i ASCII osv osv
		li	$t2, 0x49
		li 	$t3, 0x4e
		li	$t4, 0x47
		li	$t5, 0x00
		sb	$t1, 0($s0)		# Sparar värdet D på plats 0 osv osv
		sb  	$t2, 1($s0)
		sb	$t3, 2($s0)
		sb 	$t4, 3($s0)	
		sb	$t5, 4($s0)
		j	exit_time2string	# Hoppar tillbaka till exit_time2string
