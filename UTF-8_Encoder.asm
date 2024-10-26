# UTF-8 Encoder -- Dylan Burkholder
	.data
	.text
	.globl	main
main:

	# initialization
	li	$s1, 2			# j = 2
	li	$s2, 3			# n = 3
	
	# for (i = 0; i <= 16; i++)
	li	$s0, 0			# i = 0
	la	$t0, testcase		# address of testcase[i]
	bgt	$s0, 16, bottom
top:
	lw	$s1, 0($t0)		# j = testcase[i]
	# calculate n from j
	#if
		bge $s1, 0x80, Else1
		lw $s2, 0($s1)
	Else1:
		bgt $s1, 0x7FF, Else2

	Else2:
		bgt $s1, 0xFFFF, Else3

	Else3:
		bgt $s1, ox10FFFF, Else4

	Else4:
		li $s2 , 0xFFFFFFFF
	
	# print i, j and n
	move	$a0, $s0	# i
	jal	Print_integer
	la	$a0, sp		# space
	jal	Print_string
	move	$a0, $s1	# j
	jal	Print_hex
	la	$a0, sp		# space
	jal	Print_string
	move	$a0, $s2	# n
	jal	Print_hex
	la	$a0, sp		# space
	jal	Print_string
	move	$a0, $s1	# j
	jal	Print_bin
	la	$a0, sp		# space
	jal	Print_string
	move	$a0, $s2	# n
	jal	Print_bin
	la	$a0, nl		# newline
	jal	Print_string
	
	# for (i = 0; i <= 16; i++)
	addi	$s0, $s0, 1	# i++
	addi	$t0, $t0, 4	# address of testcase[i]
	ble	$s0, 16, top	# i <= 16
bottom:
	
	la	$a0, done	# mark the end of the program
	jal	Print_string
	
	jal	Exit0	# end the program, default return status

	.data
	# global data is defined here
sp:
	.asciiz	" "	# space
nl:
	.asciiz	"\n"	# newline
done:
	.asciiz	"All done!\n"

testcase:
	# UTF-8 representation is one byte
	.word 0x0000	# nul		# Basic Latin, 0000 - 007F
	.word 0x0024	# $ (dollar sign)
	.word 0x007E	# ~ (tilde)
	.word 0x007F	# del

	# UTF-8 representation is two bytes
	.word 0x0080	# pad		# Latin-1 Supplement, 0080 - 00FF
	.word 0x00A2	# cent sign
	.word 0x0627	# Arabic letter alef
	.word 0x07FF	# unassigned

	# UTF-8 representation is three bytes
	.word 0x0800
	.word 0x20AC	# Euro sign
	.word 0x2233	# anticlockwise contour integral sign
	.word 0xFFFF

	# UTF-8 representation is four bytes
	.word 0x10000
	.word 0x10348	
	.word 0x22E13	# randomly-chosen character
	.word 0x10FFFF
	.word 0x89ABCDEF	# randomly chosen bogus value

# Wrapper functions around some of the system calls

	.text

	.globl	Print_integer
Print_integer:	# print the integer in register $a0 (decimal)
	li	$v0, 1
	syscall
	jr	$ra

	.globl	Print_string
Print_string:	# print the string whose starting address is in register $a0
	li	$v0, 4
	syscall
	jr	$ra

	.globl	Exit
Exit:		# end the program, no explicit return status
	li	$v0, 10
	syscall
	jr	$ra	# this instruction is never executed

	.globl	Exit0
Exit0:		# end the program, default return status
	li	$a0, 0	# return status 0
	li	$v0, 17
	syscall
	jr	$ra	# this instruction is never executed

	.globl	Exit2
Exit2:		# end the program, with return status from register $a0
	li	$v0, 17
	syscall
	jr	$ra	# this instruction is never executed

# The following syscalls work on MARS, but not on QtSPIM

	.globl	Print_hex
Print_hex:	# print the integer in register $a0 (hexadecimal)
	li	$v0, 34
	syscall
	jr	$ra

	.globl	Print_bin
Print_bin:	# print the integer in register $a0 (binary)
	li	$v0, 35
	syscall
	jr	$ra


