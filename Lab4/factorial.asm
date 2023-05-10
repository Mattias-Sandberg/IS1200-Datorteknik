addi $a0, $0, 3		# a0 register d�r vi b�rjar med v�rat n v�rde
addi $v0, $0, 1		# return value = 1 to start with (!0 == 1)
addi $v1, $a0, 1	# l�gger p� 1 p� v�rat n v�rde och l�gger det ett annat register v1 
addi $a2, $0, 1		# s�tter v�rt i v�rde till 1 f�r den f�rsta loopen  

while:
	beq $a2, $v1, end	# om i inte �r lika med k och om i(a2) == k(v1) s� �r vi klara
	addi $a2, $a2, 1	# �kar v�rdet p� i, (som i++)
	addi $a1, $0, 0		# initsierar produkten till 0
	
	addi $a3,$0, 1		# s�tter j v�rdet till 1 s� typ samma som med i fast nu f�r inre loopen
	
mul:
	beq $a3, $a2, check	#  om j(a3) �r lika med i(a2) s� �r vi klara (multiadding)
	addi $a3, $a3, 1	# �kar v�rdet p� j (som j++)
	add $a1, $a1, $v0	# product == product + return
	beq $0, $0, mul		# hoppar tillbaks till multi loopen
	
check:
	addi $v0, $a1, 0	# s�tter return v�rdet till produkten av multiadding
	beq $0, $0, while	# hoppar tillbaka till den yttre loopen
	
end:
	beq $0, $0, end	# o�ndlig unconditional branch loop
