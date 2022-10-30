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
addi $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $s0, 8($sp)
sw $s1, 12($sp)
sw $ra, 16($sp)
# corps
srlv $s0, $a0, $a1	# décalage de bits de n à droite de i fois -> $s0
and $s1, $s0, 1		# déterminer si le bit recherché est 1 ou 0 -> $s1
move $v0, $s1		# mettre le résultat dans le registre de retour -> $v0
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $s0, 8($sp)
lw $s1, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
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
addi $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $s0, 8($sp)
sw $s1, 12($sp)
sw $ra, 16($sp)
# corps
li $s0, 1
sllv $s0, $s0, $a1	# construire nombre binaire avec le bit numéro i = 1 -> $s0
or $s1, $a0, $s0	# remplacer le bit numéro i par 1 -> $s1
move $v0, $s1		# mettre le résultat dans le registre de retour -> $v0
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $s0, 8($sp)
lw $s1, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
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
addi $sp, $sp, -36
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $s0, 8($sp)
sw $s1, 12($sp)
sw $s2, 16($sp)
sw $s3, 20($sp)
sw $s4, 24($sp)
sw $s5, 28($sp)
sw $ra, 32($sp)
# corps
li $s0, 7					# compteur du Loop1 (modifier au besoin : compteur = nombreDeBitsRepresentifs - 1) -> $s0
sub $s1, $s0, $a1
subi $s1, $s1, 1				# condition du if dans Loop1 -> $s1
li $s2, 1
Loop1_cell_mettre_bit_a0:
beqz $s0, Exit_Loop1_cell_mettre_bit_a0		# boucle de construction du début du filtre "and" à utiliser pour changer le bit i en 0 -> $s2
sll $s2, $s2, 1					# remplissage avec des 1 les bits à gauche du bit numéro i -> $s2
sub $s0, $s0, 1					# décrementation compteur Loop1 -> $s0
sub $s1, $s1, 1					# décrementation condition if -> $s1
bltz $s1, Loop1_cell_mettre_bit_a0		# condition pour laisser le bit numéro i = 0
addi $s2, $s2, 1				# remplissage avec des 1 les bits à gauche du bit numéro i -> $s2
b Loop1_cell_mettre_bit_a0
Exit_Loop1_cell_mettre_bit_a0:
move $s1, $a1					# compteur du Loop2 -> $s1
sub $s1, $s1, 1
li $s3, 1
Loop2_cell_mettre_bit_a0:			# boucle de construction de la fin du filtre "and" à utiliser pour changer le bit i en 0 -> $s3
blez $s1, Exit_Loop2_cell_mettre_bit_a0
sll $s3, $s3, 1
addi $s3, $s3, 1				# remplissage des bits à droite du bit numéro i par des 1 -> $s3
sub $s1, $s1, 1
b Loop2_cell_mettre_bit_a0
Exit_Loop2_cell_mettre_bit_a0:
add $s4, $s2, $s3				# combinaison des deux parties "debut" et "fin" du filtre "and" à utiliser -> $s4
and $s5, $a0, $s4				# mettre à 0 le bit i de l'entier n de départ en utilisant le filtre "and" qui n'a seulement le bit i qui est égale à 0 tous les autres 1 -> $s5
move $v0, $s5					# mettre le résultat dans le registre de retour -> $v0
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $s0, 8($sp)
lw $s1, 12($sp)
lw $s2, 16($sp)
lw $s3, 20($sp)
lw $s4, 24($sp)
lw $s5, 28($sp)
lw $ra, 32($sp)
addi $sp, $sp, 36
jr $ra
####################



############################## Fonction st_creer
### 
### Cette fonction prend en entrée un paramètre tel qu'un entier
### et crée une représentation de pile sous forme d'un tableau d'entiers
### de taille donnée en paramètre plus 2 pour accomoder les informations
### sur la taille maximale et le nombre d'éléments actuel.
### 
### Entrées : un entier n représentant la taille ($a0)
### Sorties : l'adresse de la pile alloué ($v0)
### 
### Pré-conditions : n > 0
### Post-conditions : -
### 
st_creer:
# prologue
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $s0, 4($sp)
sw $ra, 8($sp)
# corps
mul $a0, $a0, 4		# convertir nombre d'entiers en nombre d'octets -> $a0
addi $a0, $a0, 8	# allocation pour 2 entiers de plus pour indiquer le nombre d'élements et la taille maximale de la pile -> $a0
li $v0, 9		# chargement du paramètre du syscall sbrk pour allouer la pile de taille n -> $v0
syscall			# adresse de la pile alloué -> $v0
lw $a0, 0($sp)		# restaurer le paramètre de la taille en nombre d'entiers -> $a0
sw $a0, 0($v0)		# enregistrer la taille maximale de la pile dans la pile elle-même -> 0($v0)
li $s0, 0
sw $s0, 4($v0)		# enregistrer le nombre d'éléments actuel de la pile dans la pile elle-même -> 4($v0)
# épilogue
lw $a0, 0($sp)
lw $s0, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
jr $ra
####################



############################## Fonction st_est_vide
### 
### Cette fonction prend en entrée un paramètre tel que l'adresse
### d'une pile et renvoie 1 si elle est vide et 0 sinon.
### 
### Entrées : l'adresse de la pile ($a0)
### Sorties : booléen qui indique si la pile est vide ($v0)
### 
### Pré-conditions : -
### Post-conditions : -
### 
st_est_vide:
# prologue
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $s0, 4($sp)
sw $ra, 8($sp)
# corps
lw $s0, 4($a0)			# chargement du nombre d'éléments de la pile -> $s0
bnez $s0, Else_st_est_vide	# condition If pour vérifier si la pile est vide
li $v0, 1			# s'il y a 0 éléments alors la pile est vide : 1 (vrai) -> $v0
b Endif_st_est_vide
Else_st_est_vide:
li $v0, 0			# s'il y a autre que 0 éléments alors la pile n'est pas vide : 0 (faux) -> $v0
Endif_st_est_vide:
# épilogue
lw $a0, 0($sp)
lw $s0, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
jr $ra
####################



############################## Fonction st_est_pleine
### 
### Cette fonction prend en entrée un paramètre tel que l'adresse
### d'une pile et renvoie 1 si elle est pleine et 0 sinon.
### 
### Entrées : l'adresse de la pile ($a0)
### Sorties : booléen qui indique si la pile est pleine ($v0)
### 
### Pré-conditions : -
### Post-conditions : -
### 
st_est_pleine:
# prologue
addi $sp, $sp, -16
sw $a0, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $ra, 12($sp)
# corps
lw $s0, 0($a0)				# chargement de la taille maximale de la pile -> $s0
lw $s1, 4($a0)				# chargement du nombre d'éléments de la pile -> $s1
bne $s0, $s1, Else_st_est_pleine	# condition If pour vérifier si la pile est pleine
li $v0, 1				# si les deux nombres sont égaux alors la pile est pleine : 1 (vrai) -> $v0
b Endif_st_est_pleine
Else_st_est_pleine:
li $v0, 0				# si les deux nombres sont différents alors la pile n'est pas pleine : 0 (faux) -> $v0
Endif_st_est_pleine:
# épilogue
lw $a0, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16
jr $ra
####################



############################## Fonction st_sommet
### 
### Cette fonction prend en entrée un paramètre tel que l'adresse d'une pile
### et renvoie la valeur de l'élément le plus récent (le sommet) de la pile.
### 
### Entrées : l'adresse de la pile ($a0)
### Sorties : la valeur du sommet de la pile ($v0)
### 
### Pré-conditions : La pile n'est pas vide
### Post-conditions : -
### 
st_sommet:
# prologue
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $s0, 4($sp)
sw $ra, 8($sp)
# corps
lw $s0, 4($a0)		# chargement du nombre d'éléments de la pile -> $s0
mul $s0, $s0, 4		# convertir le nombre d'éléments en nombre d'octets -> $s0
addi $s0, $s0, 4	# ajout du décalage d'octets dû aux informations de taille stocké au début de la pile -> $s0
add $s0, $s0, $a0	# calcul de l'adresse de l'élément le plus récent (le sommet) -> $s0
lw $v0, 0($s0)		# mettre la valeur du sommet dans le registre de retour -> $v0
# épilogue
lw $a0, 0($sp)
lw $s0, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
jr $ra
####################



############################## Fonction st_empiler
### 
### Cette fonction prend en entrée deux paramètres tel que l'adresse d'une pile
### et un entier. Elle modifie la pile en ajoutant l'entier donné au sommet de la pile.
### 
### Entrées : l'adresse de la pile ($a0), un entier à empiler ($a1)
### Sorties : -
### 
### Pré-conditions : La pile n'est pas pleine
### Post-conditions : La pile donnée en argument est modifié
### 
st_empiler:
# prologue
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
# corps
lw $t0, 4($a0)		# chargement du nombre d'éléments de la pile -> $t0
mul $t1, $t0, 4		# convertir le nombre d'éléments en nombre d'octets -> $t1
addi $t1, $t1, 8	# ajout du décalage d'octets dû aux informations de taille stocké au début de la pile -> $t1
add $t1, $t1, $a0	# calcul de l'adresse qui vient après le sommet -> $t1
sw $a1, 0($t1)		# écriture de l'entier donné en paramètre dans la pile -> 0($t1)
addi $t0, $t0, 1	# incrementer le nombre d'éléments de la pile -> $t0
sw $t0, 4($a0)		# écriture du nouveau nombre d'éléments dans la pile -> 4($a0)
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
jr $ra
####################



############################## Fonction st_depiler
### 
### Cette fonction prend en entrée un paramètre tel que l'adresse d'une pile.
### Elle modifie la pile en supprimant le sommet de la pile.
### 
### Entrées : l'adresse de la pile ($a0)
### Sorties : -
### 
### Pré-conditions : La pile n'est pas vide
### Post-conditions : La pile donnée en argument est modifié
### 
st_depiler:
# prologue
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $ra, 4($sp)
# corps
lw $t0, 4($a0)		# chargement du nombre d'éléments de la pile -> $t0
subi $t0, $t0, 1	# désincrementer le nombre d'éléments de la pile -> $t0
sw $t0, 4($a0)		# écriture du nouveau nombre d'éléments dans la pile -> 4($a0)
# épilogue
lw $a0, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
jr $ra
####################
