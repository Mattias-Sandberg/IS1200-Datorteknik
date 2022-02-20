  # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "text more text lots of text\0"
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,2
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

  # you can write your code for subroutine "hexasc" below this line
  #
  
  hexasc:
   	andi	$a0,$a0,0xf		# För att spara det 4:a LSB I register a0

   	ble 	$a0,0x9,number		# if branch ($a0) is less or equal to (0xa), gå till number algoritmen
   	nop				# Slut på operation

   	ble	$a0,0xf,char		# if branch ($v0) is less or equal to (0xf), gå till char algoritmen
   	nop				# Slut på operation

   	number:				# för decimaltal mellen 0-9
   	addi	$v0,$a0,0x30		# adderar $a0 värdet med noll (0x30 i ASCII är 0) och sparar det i $v0
   	jr	$ra
   	nop				# Slut på operation

   	char:				# För decimaltal mellan 10-15
   	addi	$v0,$a0,0x37		# adderar värdet 7 (0x37 i ASCII är 7) med värdet och sparar det i $v0, hoppar över 7 steg
   	jr	$ra			# Kopierar inehållet i $ra till datorn "hoppae till adressen i $ra
   	nop				# Slut på operation

  delay: 
	
	PUSH	($ra)				# Sparar inehållet från $ra i stacken
	move 	$t1, $a0			# sparar värdet i $a0 temporärt så vi kan andvända det
	
	while:
		blt 	$t1, $zero, exit_delay	# kollar om $t1 (ms) är "branch less than" 0. om ms är mindre än noll, hoppa till exit_delay
		nop				# Slut på operation
		sub	$t1, $t1, 1 		# ms--, subtraherar 1 från ms efter varje "loop"
		
	li	$t2, 0				# Load immediate (int $t2 = 0)	
	for:
		bgt  	$t2, 1000, while	# kolla om 0 < andvändar input (ms), om det stämmer kör loopen annars hoppa till exit_delay
		nop				# Slut på operation
		addi	$t2, $t2, 1		# i++, adderar 1 till $t2 för varje gång loopen körs.
		j	for		        # går till nästa iteration av loopen
		nop				# Slut på operation
			
	exit_delay:				# slut på subroutine
		POP	($ra)			# återhämtar retuneringsadressen från stacken
		jr	$ra			# Hoppar tillbaka till "Callar"
		nop				# Slut på operation
  
  time2string:
	PUSH	($s0)				# Sparar inehållet i $s0 för att kunna återhämta det i slutet på funktionen
	PUSH	($s1)				# Sparar inehållet i $s1 för att kunna återhämta det i slutet på funktionen
	PUSH	($ra)				# Sparar retuneringsadressen på stacken
	move	$s1, $a1			# Flyttar inehåll från $a1 to $s1 så att vi kan använda registret
	move	$s0,$a0				# Flyttar inehåll från $a0 to $s0 så att vi kan använda registret

	# första siffran (timmen)
	andi 	$t1, $s1, 0xf000		# Maskar ut bitar från index 15 till 12 (4 bitar)
	srl 	$a0, $t1, 12			# Shiftar biten till LSB och sparar det i $a0 för hexasc
	jal	hexasc				# Anropppar hexasc som omvandlar värdet från decimal till hexadecimal
	nop					# Slut på operation
	sb 	$v0, 0($s0)		 	# sparar retuneringsvärdet från hexasc i den första "byte" positionen $s1 pekar på (store byte)
											

	# Andra siffran (minuten)
	andi 	$t1, $s1, 0x0f00		# maskar ut bitar från index 11 till 8 (4 bitar)
	srl 	$a0, $t1, 8			# Shiftar biten till LSB och sparar det i $a0 för hexasc
	jal	hexasc				# Anropppar hexasc som omvandlar värdet från decimal till hexadecimal
	nop					# Slut på operation
	sb 	$v0, 1($s0)		 	# sparar retuneringsvärdet från hexasc i den andra "byte" positionen $s1 pekar på (store byte)
	
	
	# Lägger till kolon (hm:ss)
	li 	$t1, 0x3a			# laddar in ASCII koden för kolon
	sb 	$t1, 2($s0)		 	# sparar retuneringsvärdet från hexasc i den tredje "byte" positionen $s1 pekar på (store byte)
	
	
	# tredje siffran (sekunden)
	andi 	$t1, $s1, 0x00f0		# maskar ut bitar från index 7 till 4 (4 bitar)
	srl 	$a0, $t1, 4			# Shiftar biten till LSB och sparar det i $a0 för hexasc
	jal	hexasc				# Anropppar hexasc som omvandlar värdet från decimal till hexadecimal
	nop					# Slut på operation
	sb 	$v0, 3($s0)		 	# sparar retuneringsvärdet från hexasc i den fjärde "byte" positionen $s1 pekar på (store byte)
	
										
	# fjärde siffran (sekunden)
	andi 	$t1, $s1, 0x000f		# maskar ut bitar från index 3 till 0 (4 bitar)
	move 	$a0, $t1			# Shiftar biten till LSB och sparar det i $a0 för hexasc
	jal	hexasc				# Anropppar hexasc som omvandlar värdet från decimal till hexadecimal
	nop					# Slut på operation
	sb 	$v0, 4($s0)		 	# sparar retuneringsvärdet från hexasc i den femte "byte" positionen $s1 pekar på (store byte)
						
        # adderar "NUL byte" för att slippa "text more text lots of text\0"
	li	$t1, 0x00			# laddar ASCII koden  NUL
	sb 	$t1, 5($s0)		 	# sparar retuneringsvärdet från hexasc i den sjätte "byte" positionen $s1 pekar på (store byte)
	j	exit_time2string		# hoppar till påståendet på målets adress
	
	# slut subroutine. Återställer register och hoppar tillbaka till caller.
	exit_time2string:																																																																																										
		POP	($ra)
		POP	($s1)
		POP	($s0)	
 		jr 	$ra
 		nop																																																																																																																																																														
	
