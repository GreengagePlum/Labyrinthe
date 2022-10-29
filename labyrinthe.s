.data

.text
.globl __start

__start:






############################## Fonction cell_lecture_bit
### 
### Cette fonction prend en entrée deux paramètres tels qu'un entier
### et la position d'un des bits de cet entier. Elle retourne la valeur
### du bit recherché de l'entier.
### 
### Entrées : un entier n ($a0), la position d'un bit i ($a1)
### Sorties : la valeur d'un bit ($v0)
### 
### Pré-conditions : 0 <= i <= 7
### Post-conditions : -
### 
cell_lecture_bit:
# prologue
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
# corps
srlv $t0, $a0, $a1	# décalage de bits de n à droite de i fois -> $t0
and $t1, $t0, 1		# déterminer si le bit recherché est 1 ou 0 -> $t1
move $v0, $t1		# mettre le résultat dans le registre de retour -> $v0
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
jr $ra
####################



############################## Fonction cell_mettre_bit_a1
### 
### Cette fonction prend en entrée deux paramètres tels qu'un entier
### et la position d'un des bits de cet entier. Elle remplace la valeur
### du bit recherché de l'entier par un 1.
### 
### Entrées : un entier n ($a0), la position d'un bit i ($a1)
### Sorties : entier avec le bit numéro i = 1 ($v0)
### 
### Pré-conditions : 0 <= i <= 7
### Post-conditions : -
### 
cell_mettre_bit_a1:
# prologue
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
# corps
li $t0, 1
sllv $t0, $t0, $a1	# construire nombre binaire avec le bit numéro i = 1 -> $t0
or $t1, $a0, $t0	# remplacer le bit numéro i par 1 -> $t1
move $v0, $t1		# mettre le résultat dans le registre de retour -> $v0
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
jr $ra
####################



############################## Fonction cell_mettre_bit_a0
### 
### Cette fonction prend en entrée deux paramètres tels qu'un entier
### et la position d'un des bits de cet entier. Elle remplace la valeur
### du bit recherché de l'entier par un 0.
### 
### Entrées : un entier n ($a0), la position d'un bit i ($a1)
### Sorties : entier avec le bit numéro i = 0 ($v0)
### 
### Pré-conditions : 0 <= i <= 7
### Post-conditions : -
### 
cell_mettre_bit_a0:
# prologue
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
# corps
li $t0, 7					# compteur du Loop1 (modifier au besoin : compteur = nombreDeBitsRepresentifs - 1) -> $t0
sub $t1, $t0, $a1
subi $t1, $t1, 1				# condition du if dans Loop1 -> $t1
li $t2, 1
Loop1_cell_mettre_bit_a0:
beqz $t0, Exit_Loop1_cell_mettre_bit_a0		# boucle de construction du début du filtre "and" à utiliser pour changer le bit i en 0 -> $t2
sll $t2, $t2, 1					# remplissage avec des 1 les bits à gauche du bit numéro i -> $t2
sub $t0, $t0, 1					# décrementation compteur Loop1 -> $t0
sub $t1, $t1, 1					# décrementation condition if -> $t1
bltz $t1, Loop1_cell_mettre_bit_a0		# condition pour laisser le bit numéro i = 0
addi $t2, $t2, 1				# remplissage avec des 1 les bits à gauche du bit numéro i -> $t2
b Loop1_cell_mettre_bit_a0
Exit_Loop1_cell_mettre_bit_a0:
move $t1, $a1					# compteur du Loop2 -> $t1
sub $t1, $t1, 1
li $t3, 1
Loop2_cell_mettre_bit_a0:			# boucle de construction de la fin du filtre "and" à utiliser pour changer le bit i en 0 -> $t3
blez $t1, Exit_Loop2_cell_mettre_bit_a0
sll $t3, $t3, 1
addi $t3, $t3, 1				# remplissage des bits à droite du bit numéro i par des 1 -> $t3
sub $t1, $t1, 1
b Loop2_cell_mettre_bit_a0
Exit_Loop2_cell_mettre_bit_a0:
add $t4, $t2, $t3				# combinaison des deux parties "debut" et "fin" du filtre "and" à utiliser -> $t4
and $t5, $a0, $t4				# mettre à 0 le bit i de l'entier n de départ en utilisant le filtre "and" qui n'a seulement le bit i qui est égale à 0 tous les autres 1 -> $t5
move $v0, $t5					# mettre le résultat dans le registre de retour -> $v0
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
jr $ra
####################
