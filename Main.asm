.data
#Mensagens
msg_final: .asciiz "Binario: "
input: .asciiz "Insira um valor inteiro e positivo para ser convertido: "
Erro: .asciiz "Entrada inválida. Insira apenas números inteiros e positivos\n"

# Entrada do usuário vai ser recebida como um vetor para analizar antes de prosseguir
vetor: .space 40
# Vetor para armazenar os caracteres convertidos em binario
vetor_bin: .space 40


.text

main:
	li $t0, 0 # t0 vai ser o contador
	li $t1, 0 # t1 vai auxiliar
	
	# t3 e t4 vão ser usados para verificacao da entrada
	li $t3, 48  # ascii '0'
	li $t4, 57  # ascii '9'

	# Exibir input
	li $v0, 4
	la $a0, input
	syscall

	# Ler a entrada do usuário
	li $v0, 8
	la $a0, vetor
	li $a1, 20
	syscall
	
	# Verificar a entrada
	jal vetor_numero
	
	# registradores para a funcao de binario
	li $s0, 0 # contador geral
	li $s1, 2 # divisor
		
	# Move o numero para o registrador a0
	move $a0, $t1
	
	jal decimal_para_binario
	
	
	# Exibir o numero em binario
	li $v0, 4
	la $a0, msg_final
	syscall
	
	jal print_bin
	
	# Finaliza o programa
	li $v0, 10
	syscall
	
	
	
vetor_numero:
	# t2 recebe o valor na posicao t0
	lb $t2, vetor($t0)

	# fim de loop no \n
	beq $t2, 10, fim_L1

	# Verifica se o caractere está entre 0 e 9
	blt $t2, $t3, mensagem_erro
	bgt $t2, $t4, mensagem_erro
	
	# Converter o caractere em número
	sub $t2, $t2, $t3
	
	# 10 multiplica t1 para add concatenar ao inves de somar
	mul $t1, $t1, 10
	add $t1, $t1, $t2
	
	# Incrementa o contador e recomeca o loop
	addi $t0, $t0, 1
	j vetor_numero
	
	
	
fim_L1:
	# Volta para a main
	jr $ra
	
	
	
mensagem_erro:
	# Exibir mensagem de erro
	li $v0, 4
	la $a0, Erro
	syscall
	j main



decimal_para_binario: 
	# divisao de a0 por s1
	divu $a0, $s1
	
	# mover o resto para t4 e guardar no vetor
	mfhi $t4
	add $t4, $t4, 48
	sb $t4, vetor_bin($s0)
	
	# t2 recebe o quociente
	mflo $t2
	
	# Verificacao para sair do loop
	beqz $t2, fim_L2
	
	# incrementar contador e a0 recebe quociente
	add $s0, $s0, 1
	move $a0, $t2
	
	j decimal_para_binario
	
	
	
fim_L2:
	# Volta para a main
	jr $ra



print_bin:
	bltz $s0, fim_L3
	# t0 recebe o caractere na posicao s0
	lb $t0, vetor_bin($s0)
	
	
	# Imprimir o caractere
	li $v0, 11			  
	move $a0, $t0		   
	syscall
	
	# Decrementar o contador
	sub $s0, $s0, 1  
		  
	j print_bin



fim_L3:
	# volta para a main
	jr $ra
	
