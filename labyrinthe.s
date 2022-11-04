.data
Espace: 	.asciiz " "
NouvLigne:	.asciiz "\n"

.text
.globl __main

__main:







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
blez $s0, Exit_Loop1_cell_mettre_bit_a0		# boucle de construction du début du filtre "and" à utiliser pour changer le bit i en 0 -> $s2
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
bltz $s1, Elseif_cell_mettre_bit_a0		# condition pour vérifier s'il faut combiner les deux parties du filtre construit
add $s4, $s2, $s3				# combinaison des deux parties "debut" et "fin" du filtre "and" à utiliser -> $s4
b Endif_cell_mettre_bit_a0
Elseif_cell_mettre_bit_a0:
move $s4, $s2					# saut de la combinaison, utilisation du début seulement (pour le cas de la modification du bit 0)
Endif_cell_mettre_bit_a0:
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
addi $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $s0, 8($sp)
sw $s1, 12($sp)
sw $ra, 16($sp)
# corps
lw $s0, 4($a0)		# chargement du nombre d'éléments de la pile -> $s0
mul $s1, $s0, 4		# convertir le nombre d'éléments en nombre d'octets -> $s1
addi $s1, $s1, 8	# ajout du décalage d'octets dû aux informations de taille stocké au début de la pile -> $s1
add $s1, $s1, $a0	# calcul de l'adresse qui vient après le sommet -> $s1
sw $a1, 0($s1)		# écriture de l'entier donné en paramètre dans la pile -> 0($t1)
addi $s0, $s0, 1	# incrementer le nombre d'éléments de la pile -> $s0
sw $s0, 4($a0)		# écriture du nouveau nombre d'éléments dans la pile -> 4($a0)
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $s0, 8($sp)
lw $s1, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
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
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $s0, 4($sp)
sw $ra, 8($sp)
# corps
lw $s0, 4($a0)		# chargement du nombre d'éléments de la pile -> $s0
subi $s0, $s0, 1	# décrementer le nombre d'éléments de la pile -> $s0
sw $s0, 4($a0)		# écriture du nouveau nombre d'éléments dans la pile -> 4($a0)
# épilogue
lw $a0, 0($sp)
lw $s0, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
jr $ra
####################



############################## Fonction st_afficher
### 
### Cette fonction prend en entrée un paramètre tel que l'adresse d'une pile.
### Elle affiche le contenu de la pile sur une ligne sans saut de ligne à la fin.
### 
### Entrées : l'adresse de la pile ($a0)
### Sorties : -
### 
### Pré-conditions : -
### Post-conditions : Affichage des entiers sans saut de ligne
### 
st_afficher:
# prologue
addi $sp, $sp, -16
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $s0, 8($sp)
sw $ra, 12($sp)
# corps
jal st_est_vide
bnez $v0, Exit_st_afficher			# condition de récursivité du cas base : la pile est-elle vide ?
jal st_sommet
move $s0, $v0					# sommet de la pile -> $s0
move $a0, $s0					# affichage du sommet
li $v0, 1
syscall
la $a0, Espace					# affichage d'un espace après l'entier
li $v0, 4
syscall
lw $a0, 0($sp)					# restaurer l'adresse de la pile -> $a0
jal st_depiler					# passer au cas plus petit d'un cran pour préparer l'appel récursive
jal st_afficher
move $a1, $s0					# préparer le paramètre de la fonction st_empiler avec le sommet de la pile -> $a1
jal st_empiler					# empiler le sommet qui était dépilé avant pour reconstruire la pile du début
Exit_st_afficher:
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $s0, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16
jr $ra
####################



############################## Fonction st_reinitialiser
### 
### Cette fonction prend en entrée un paramètre tel que l'adresse d'une pile.
### Elle la dépile jusq'à ce qu'elle a 0 éléments.
### 
### Entrées : l'adresse d'une pile ($a0)
### Sorties : -
### 
### Pré-conditions : -
### Post-conditions : La pile est modifié
### 
st_reinitialiser:
# prologue
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $s0, 4($sp)
sw $ra, 8($sp)
# corps
jal st_est_vide
beq $v0, 1, Exit_st_est_vide	# si la pile est vide ne fait rien
lw $s0, 4($a0)			# sinon, charger la taille de la pile comme compteur de boucle -> $s0
Loop_st_est_vide:
blez $s0, Exit_st_est_vide	# boucle pour dépiler tous les éléments de la pile
jal st_depiler
subi $s0, $s0, 1		# décrementer le compteur de boucle -> $s0
b Loop_st_est_vide
Exit_st_est_vide:
# épilogue
lw $a0, 0($sp)
lw $s0, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
jr $ra
####################



############################## Fonction creer_laby
### 
### Cette fonction prend en entrée un paramètre tel qu'un entier
### qui indique la taille en cellules des cotés d'un labyrinthe carré.
### Elle crée une pile et la remplit avec des cellules du labyrinthe
### qui sont entourés de murs chacune.
### 
### Entrées : un entier n pour le nombre de cellules d'un coté ($a0)
### Sorties : l'adresse de la pile représentant le labyrinthe ($v0)
### 
### Pré-conditions : n >= 2
### Post-conditions : -
### 
creer_laby:
# prologue
addi $sp, $sp, -16
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $s0, 8($sp)
sw $ra, 12($sp)
# corps
mul $a0, $a0, $a0			# calcul du nombre total de cellules -> $a0
move $s0, $a0				# compteur de la boucle Loop1 pour remplir la pile avec des cellules -> $s0
subi $s0, $s0, 2			# on supprime 2 car les cellules d'entrée et de sortie sont empilés hors boucle -> $s0
jal st_creer				# création de la pile de taille n x n
move $a0, $v0				# l'adresse de la pile créée -> $a0
li $a1, 47				# paramètre de la fonction st_empiler, sa valeur indique la cellule de sortie -> $a1
jal st_empiler				# la cellule de sortie empilée
li $a1, 15				# paramètre de la fonction st_empiler, sa valeur indique des cellules autre que l'entrée et la sortie -> $a1
Loop1_creer_laby:			# boucle pour remplir la pile des cellules autres que l'entrée et la sortie
blez $s0, Exit_Loop1_creer_laby
jal st_empiler				# empiler une cellule (n x n) - 2 fois
subi $s0, $s0, 1			# décrémenter le compteur de boucle -> $s0
b Loop1_creer_laby
Exit_Loop1_creer_laby:
li $a1, 31				# paramètre de la fonction st_empiler, sa valeur indique la cellule d'entrée -> $a1
jal st_empiler				# empiler la cellule d'entrée
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $s0, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16
jr $ra
####################



############################## Fonction afficher_laby
### 
### Cette fonction prend en paramètre l'adresse d'une pile
### qui représente un labyrinthe et affiche ce dernier.
### 
### Entrées : l'adresse d'un labyrinthe ($a0)
### Sorties : -
### 
### Pré-conditions : 2 <= taille d'une ligne ou colonne <= 99
### Post-conditions : Affichage des nombres
### 
afficher_laby:
# prologue
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $ra, 4($sp)
# corps
move $s0, $a0			# copier l'adresse de la pile pour ne pas l'écraser -> $s0
lw $a0, 0($s0)			# charger le nombre total de cellules du labyrinthe -> $a0
jal racine_carre		# calcul de la racine carré du nombre total de cellules pour trouver la taille d'une ligne
move $s1, $v0			# taille d'une ligne du labyrinthe -> $s1
move $a0, $s1			# préparation du paramètre de la fonction afficher_taille_laby -> $a0
jal afficher_taille_laby	# affichage de la taille du labyrinthe sur la première ligne
lw $a0, 0($sp)			# restaurer l'adresse de la pile -> $a0
move $a1, $s1			# préparation du paramètre de la fonction afficher_contenu_laby
jal afficher_contenu_laby	# affichage des cellules du labyrinthe ligne par ligne
# épilogue
lw $a0, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
jr $ra
####################



############################## Fonction afficher_taille_laby
### 
### Cette fonction prend en paramètre la taille d'un coté
### d'un labyrinthe et l'affiche sur la première ligne.
### 
### Entrées : la taille d'un coté d'un labyrinthe n ($a0)
### Sorties : -
### 
### Pré-conditions : 0 <= n <= 99
### Post-conditions : Affichage des nombres
### 
afficher_taille_laby:
# prologue
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $ra, 4($sp)
# corps
bge $a0, 10, Endif_afficher_taille_laby		# verifier si la cellule est un nombre à un chiffre
li $a0, 0					# si oui, affichage de 0 à gauche pour alignement
li $v0, 1
syscall
lw $a0, 0($sp)
Endif_afficher_taille_laby:
li $v0, 1					# affichage de la cellule
syscall
la $a0, NouvLigne				# affichage d'un caractère de saut de ligne après le nombre pour passer à la ligne suivante
li $v0, 4
syscall
# épilogue
lw $a0, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
jr $ra
####################



############################## Fonction afficher_contenu_laby
### 
### Cette fonction prend en paramètre l'adresse d'une pile
### qui représente un labyrinthe et la longueur d'une de ses
### lignes. Elle affiche le labyrinthe ligne par ligne.
### 
### Entrées : l'adresse d'un labyrinthe ($a0), la taille d'un coté n ($a1)
### Sorties : -
### 
### Pré-conditions : 2 <= n <= 99
### Post-conditions : Affichage des nombres
### 
afficher_contenu_laby:
# prologue
addi $sp, $sp, -16
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $s0, 8($sp)
sw $ra, 12($sp)
# corps
jal st_est_vide
bnez $v0, Exit_afficher_contenu_laby		# condition de récursivité du cas base : la pile est-elle vide ?
jal st_sommet
move $s0, $v0					# sommet de la pile (première cellule du labyrinthe) -> $s0
bge $s0, 10, Endif1_afficher_contenu_laby	# verifier si la cellule est un nombre à un chiffre
li $a0, 0					# si oui, affichage de 0 à gauche pour alignement
li $v0, 1
syscall
Endif1_afficher_contenu_laby:
move $a0, $s0					# affichage de la cellule
li $v0, 1
syscall
ble $a1, 1, Else2_afficher_contenu_laby		# condition pour vérifier s'il faut mettre un espace ou un saut de ligne après le nombre
la $a0, Espace					# affichage d'un espace après le nombre
li $v0, 4
syscall
subi $a1, $a1, 1				# décrementer la taille de ligne qui indique si on est à la fin d'une ligne -> $a1
b Endif2_afficher_contenu_laby
Else2_afficher_contenu_laby:
la $a0, NouvLigne				# affichage d'un caractère de saut de ligne après le nombre pour passer à la ligne suivante
li $v0, 4
syscall
lw $a0, 0($sp)					# restaurer l'adresse de la pile -> $a0
lw $a1, 0($a0)					# charger la taille de la pile -> $a1
move $a0, $a1					# passer la taille de la pile en paramètre pour la fonction racine carré -> $a0
jal racine_carre
move $a1, $v0					# calcul de la longueur d'une ligne de départ pour recommencer une nouvelle ligne -> $a1
Endif2_afficher_contenu_laby:
lw $a0, 0($sp)					# restaurer l'adresse de la pile -> $a0
jal st_depiler					# passer au cas plus petit d'un cran pour préparer l'appel récursive
jal afficher_contenu_laby			# appel récursive pour afficher tous les nombres jusqu'à arriver à pile vide
move $a1, $s0					# préparer le paramètre de la fonction st_empiler avec le sommet de la pile -> $a1
jal st_empiler					# empiler le sommet qui était dépilé avant pour reconstruire la pile du début
Exit_afficher_contenu_laby:
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $s0, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16
jr $ra
####################



############################## Fonction racine_carre
###
### Inspiré par https://www.educba.com/square-root-in-c/
### 
### Cette fonction prend la racine carré d'un entier
### donné en paramètre. 
### 
### Entrées : un entier n ($a0)
### Sorties : un entier r ($v0)
### 
### Pré-conditions : n >= 0
### Post-conditions : -
### 
racine_carre:
# prologue
addi $sp, $sp, -16
sw $a0, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $ra, 12($sp)
# corps
li $s0, 1				# initalisation du compteur pour la boucle -> $s0
li $s1, 1				# initalisation de la variable pour calculer le carré des nombres -> $s1
Loop_racine_carre:			# boucle pour trouver la racine carré d'un nombre en essayant chaque nombre
bgt $s1, $a0, Exit_Loop_racine_carre	# si le carré qu'on a calculé dépasse le nombre de départ on arrête la boucle
addi $s0, $s0, 1			# sinon on increment le compteur -> $s0
mul $s1, $s0, $s0			# on calcule le carré du compteur -> $s1
b Loop_racine_carre
Exit_Loop_racine_carre:
subi $s0, $s0, 1			# soustraction de 1 du résultat pour accomoder le dépassement d'un nombre dans la boucle -> $s0
move $v0, $s0				# mettre le résultat dans le registre de retour -> $v0
# épilogue
lw $a0, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16
jr $ra
####################



############################## Fonction lecture_cellule
### 
### Cette fonction prend en paramètre deux arguments tels que l'adresse d'une 
### pile qui représente un labyrinthe et l'indice d'une des cellules de ceci. 
### Elle renvoie la valeur de la cellule souhaité.
### 
### Entrées : l'adresse d'un labyrinthe ($a0), l'indice d'une cellule n ($a1)
### Sorties : la valeur de la cellule ($v0)
### 
### Pré-conditions : 0 <= n <= taille maximale labyrinthe - 1
### Post-conditions : -
### 
lecture_cellule:
# prologue
addi $sp, $sp, -16
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $s0, 8($sp)
sw $ra, 12($sp)
# corps
bgtz $a1, Else_lecture_cellule		# condition de cas de base pour la récursivité
jal st_sommet				# si on arrive à l'indice de la cellule rechercé, prend sa valeur
b Endif_lecture_cellule
Else_lecture_cellule:
jal st_sommet				# sinon on prend quand même le sommet pour l'empiler et rendre la pile à la fin en bon état
move $s0, $v0				# sauvegarde de la valeur du sommet pour ne pas écraser -> $s0
jal st_depiler				# depiler pour arriver à un cas plus petit
subi $a1, $a1, 1			# décrémenter l'indice de la cellule -> $a1
jal lecture_cellule			# appel récursif pour continuer à dépiler jusqu'à retrouver la cellule recherché
move $a1, $s0				# paramètre de la fonction st_empiler, le sommet -> $a0
jal st_empiler				# empiler le sommet qui était dépilé avant
Endif_lecture_cellule:
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $s0, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16
jr $ra
####################



############################## Fonction modifier_cellule
### 
### Cette fonction prend en paramètre trois arguments tels que l'adresse d'une 
### pile qui représente un labyrinthe, l'indice d'une des cellules de ceci et
### un entier k. Elle remplace la valeur de la cellule souhaité par l'entier k.
### 
### Entrées : l'adresse d'un labyrinthe ($a0), l'indice d'une cellule n ($a1), un entier k ($a2)
### Sorties : -
### 
### Pré-conditions : 0 <= n <= taille maximale labyrinthe - 1, 0 <= k <= 99
### Post-conditions : La pile qui représente le labyrinthe est modifié
### 
modifier_cellule:
# prologue
addi $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $s0, 12($sp)
sw $ra, 16($sp)
# corps
bgez $a1, Else_modifier_cellule		# condition de cas de base pour la récursivité
move $a1, $a2
jal st_empiler				# rempalcement de la valeur à l'indice n par l'entier k
b Endif_modifier_cellule
Else_modifier_cellule:
jal st_sommet				# on prend le sommet pour l'empiler et rendre la pile à la fin en bon état
move $s0, $v0				# sauvegarde de la valeur du sommet pour ne pas écraser -> $s0
jal st_depiler				# depiler pour arriver à un cas plus petit
subi $a1, $a1, 1			# décrémenter l'indice de la cellule -> $a1
jal modifier_cellule			# appel récursif pour continuer à dépiler jusqu'à retrouver la cellule recherché
bltz $a1, Endif_modifier_cellule	# condition pour empiler que les cellules qui n'avaient pas l'indice n comme indice
move $a1, $s0				# paramètre de la fonction st_empiler, le sommet -> $a0
jal st_empiler				# empiler le sommet qui était dépilé avant
Endif_modifier_cellule:
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $s0, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
jr $ra
####################



############################## Fonction trouver_indice_cellule
### 
### Cette fonction prend en paramètre trois arguments tels que l'adresse d'une 
### pile qui représente un labyrinthe, l'indice d'une des cellules de ceci et
### un entier d qui représente une direction tel que haut, bas, gauche, droite
### par 1, 2, 3, 4 respectivement. Elle renvoie l'indice de la cellule qui se
### situe dans la direction donnée en partant de la cellule donné.
### 
### Entrées : l'adresse d'un labyrinthe ($a0), l'indice d'une cellule c ($a1), un entier pour une direction d ($a2)
### Sorties : l'indice d'une cellule ($v0)
### 
### Pré-conditions : 0 <= c <= taille maximale labyrinthe - 1, 1 <= d <= 4
### Post-conditions : S'il n'y a pas de cellule dans la direction demandé, la fonction renvoie -1
### 
trouver_indice_cellule:
# prologue
addi $sp, $sp, -36
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $s0, 12($sp)
sw $s1, 16($sp)
sw $s2, 20($sp)
sw $s3, 24($sp)
sw $s4, 28($sp)
sw $ra, 32($sp)
# corps
move $s0, $a0					# copier l'adresse de la pile pour ne pas l'écraser -> $s0
lw $a0, 0($s0)					# charger le nombre total de cellules du labyrinthe -> $a0
move $s2, $a0					# copier le nombre total de cellules pour ne pas écraser -> $s2
jal racine_carre				# calcul de la racine carré du nombre total de cellules pour trouver la taille d'une ligne
move $s1, $v0					# taille d'une ligne du labyrinthe -> $s1
bne $a2, 1, Elseif1_trouver_indice_cellule	# condition pour vérifier si on va vers le haut
blt $a1, $s1, OutOfRange_trouver_indice_cellule	# condition pour ne pas calculer le voisin en haut si la cellule est dans la premère ligne
sub $v0, $a1, $s1				# calcul de l'indice du voisin -> $v0
b Endif1_trouver_indice_cellule
Elseif1_trouver_indice_cellule:
bne $a2, 2, Elseif2_trouver_indice_cellule	# condition pour vérifier si on va vers le bas
sub $s3, $s2, $s1				# calcul pour trouver si la cellule fait partie de la dernière ligne -> $s3
bge $a1, $s3, OutOfRange_trouver_indice_cellule	# condition pour ne pas calculer le voisin en bas si la cellule est dans la dernière ligne
add $v0, $a1, $s1				# calcul de l'indice du voisin -> $v0
b Endif1_trouver_indice_cellule
Elseif2_trouver_indice_cellule:
bne $a2, 3, Elseif3_trouver_indice_cellule	# condition pour vérifier si on va vers la gauche
div $a1, $s1					# calcul pour trouver si la cellule fait partie de la première colonne -> $s3
mfhi $s3
beq $s3, 0, OutOfRange_trouver_indice_cellule	# condition pour ne pas calculer le voisin à gauche si la cellule est dans la première colonne
subi $v0, $a1, 1				# calcul de l'indice du voisin -> $v0
b Endif1_trouver_indice_cellule
Elseif3_trouver_indice_cellule:
bne $a2, 4, Endif1_trouver_indice_cellule	# condition pour vérifier si on va vers la droite
div $a1, $s1					# calcul pour trouver si la cellule fait partie de la dernière colonne -> $s4
mfhi $s4
subi $s3, $s1, 1
beq $s3, $s4, OutOfRange_trouver_indice_cellule	# condition pour ne pas calculer le voisin à droite si la cellule est dans la dernière colonne
addi $v0, $a1, 1				# calcul de l'indice du voisin -> $v0
Endif1_trouver_indice_cellule:
bltz $v0, OutOfRange_trouver_indice_cellule	# condition pour vérifier s'il y a un dépassement vers les indices négatives
bge $v0, $s0, OutOfRange_trouver_indice_cellule	# condition pour vérifier s'il y a un dépassement vers les indices au-dela de la taille du labyrinthe
b Exit_OutOfRange_trouver_indice_cellule
OutOfRange_trouver_indice_cellule:
li $v0, -1					# retour de l'indice invalide -1 -> $v0
Exit_OutOfRange_trouver_indice_cellule:
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $s0, 12($sp)
lw $s1, 16($sp)
lw $s2, 20($sp)
lw $s3, 24($sp)
lw $s4, 28($sp)
lw $ra, 32($sp)
addi $sp, $sp, 36
jr $ra
####################



############################## Fonction trouver_voisin_cellule
### 
### Cette fonction prend en paramètre trois arguments tels que l'adresse d'une 
### pile qui représente un labyrinthe, l'indice d'une des cellules de ceci et
### l'adresse d'une pile pour écrire les résultats.
### Elle remplit la pile avec les indices des cellules voisines à la cellule donnée.
### 
### Entrées : l'adresse d'un labyrinthe ($a0), l'indice d'une cellule c ($a1), l'adresse d'une pile ($a2)
### Sorties : -
### 
### Pré-conditions : 0 <= c <= taille maximale labyrinthe - 1, pile est de taille 4 et vide
### Post-conditions : La pile donnée est modifié. S'il n'y a pas de voisin, la pile renvoyée est vide.
### 
trouver_voisin_cellule:
# prologue
addi $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $s0, 12($sp)
sw $ra, 16($sp)
# corps
li $s0, 1					# compteur de la boucle -> $s0
Loop_trouver_voisin_cellule:
bgt $s0, 4, Exit_Loop_trouver_voisin_cellule	# boucle qui teste toutes les 4 directions pour trouver un voisin
move $a2, $s0					# préparation du paramètre pour la fonction trouver_indice_cellule -> $a2
jal trouver_indice_cellule
beq $v0, -1, Endif_trouver_voisin_cellule	# condition pour vérifier si l'indice retourné est valide
lw $a0, 8($sp)					# restauration de l'adresse de la pile de retour -> $a0
move $a1, $v0					# l'indice de la cellule voisine valide trouvée -> $a1
jal st_empiler					# empiler le voisin trouver dans la pile de retour
lw $a0, 0($sp)					# restaurer l'adresse du labyrinthe -> $a0
lw $a1, 4($sp)					# restaurer l'indice de la cellule de départ -> $a1
Endif_trouver_voisin_cellule:
addi $s0, $s0, 1				# incrémenter le compteur -> $s0
b Loop_trouver_voisin_cellule
Exit_Loop_trouver_voisin_cellule:
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $s0, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
jr $ra
####################



############################## Fonction trouver_voisin_non_visite_cellule
### 
### Cette fonction prend en paramètre trois arguments tels que l'adresse d'une 
### pile qui représente un labyrinthe, l'indice d'une des cellules de ceci et
### l'adresse d'une pile pour écrire les résultats.
### Elle remplit la pile avec les indices des cellules voisines non visitées à la cellule donnée.
### 
### Entrées : l'adresse d'un labyrinthe ($a0), l'indice d'une cellule c ($a1), l'adresse d'une pile ($a2)
### Sorties : -
### 
### Pré-conditions : 0 <= c <= taille maximale labyrinthe - 1, pile est de taille 4 et vide
### Post-conditions : La pile donnée est modifié. S'il n'y a pas de voisin non visité, la pile renvoyée est vide.
### 
trouver_voisin_non_visite_cellule:
# prologue
addi $sp, $sp, -16
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $ra, 12($sp)
# corps
jal trouver_voisin_cellule		# remplir la pile avec les indices des voisins
move $a1, $a2				# l'adresse de la pile contenant les indices -> $a1
jal enlever_voisin_visite_cellule	# enlever les indices des voisins visité de la pile
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16
jr $ra
####################



############################## Fonction enlever_voisin_visite_cellule
### 
### Cette fonction prend en paramètre deux arguments tels que l'adresse d'une 
### pile qui représente un labyrinthe et l'adresse d'une pile qui contient des indices.
### Elle enleve les indices des cellules qui était visité de la pile.
### 
### Entrées : l'adresse d'un labyrinthe ($a0), l'adresse d'une pile ($a1)
### Sorties : -
### 
### Pré-conditions : -
### Post-conditions : La pile donnée est modifié. Si toutes les cellules étaient visité, la pile est vide.
### 
enlever_voisin_visite_cellule:
# prologue
addi $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $s0, 8($sp)
sw $s1, 12($sp)
sw $ra, 16($sp)
# corps
move $a0, $a1						# l'adresse de la pile -> $a0
jal st_est_vide
beq $v0, 1, Exit_enlever_voisin_visite_cellule		# condition pour vérifier si la pile des indices est vide
jal st_sommet
move $s0, $v0						# sommet de la pile des indices -> $s0
lw $a0, 0($sp)						# restaurer l'adresse du labyrinthe -> $a0
move $a1, $s0						# sommet de la pile des indices -> $a1
jal lecture_cellule
move $a0, $v0						# la valeur de la cellule à l'indice au sommet de la pile -> $a0
li $a1, 6
jal cell_lecture_bit
move $s1, $v0						# la valeur du bit numéro 6 qui indique si la cellule était visitée ou non -> $s1
lw $a0, 4($sp)						# restaurer l'adresse de la pile -> $a0
jal st_depiler
lw $a0, 0($sp)						# restaurer l'adresse du labyrinthe -> $a0
lw $a1, 4($sp)						# restaurer l'adresse de la pile -> $a1
jal enlever_voisin_visite_cellule			# appel récursif
beq $s1, 1, Exit_enlever_voisin_visite_cellule		# empiler l'élément dépilé seulement si c'était une cellule non visité
move $a0, $a1						# l'adresse de la pile -> $a0
move $a1, $s0						# l'élément dépile auparavant -> $a1
jal st_empiler
Exit_enlever_voisin_visite_cellule:
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $s0, 8($sp)
lw $s1, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
jr $ra
####################



############################## Fonction tirer_hasard_cellule
### 
### Cette fonction prend en paramètre un argument tel que l'adresse d'une pile qui contient des indices.
### Elle choisit un indice au hasard et le renvoi.
### 
### Entrées : l'adresse d'une pile ($a0)
### Sorties : l'indice d'une cellule ($v0)
### 
### Pré-conditions : -
### Post-conditions : Si la pile est vide, l'indice -1 est renvoyé
### 
tirer_hasard_cellule:
# prologue
addi $sp, $sp, -16
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $s0, 8($sp)
sw $ra, 12($sp)
# corps
lw $s0, 4($a0)					# chargement de la taille de la pile -> $s0
bne $s0, 0, Elseif1_tirer_hasard_cellule	# condition pour vérifier si la pile est vide
li $v0, -1					# si oui renvoie de l'indice invalide -1 -> $v0
b Endif_tirer_hasard_cellule
Elseif1_tirer_hasard_cellule:
bne $s0, 1, Elseif2_tirer_hasard_cellule	# condition pour vérifier si la pile n'a qu'un seul élément
jal st_sommet					# si oui renvoie de cet élément -> $v0
b Endif_tirer_hasard_cellule
Elseif2_tirer_hasard_cellule:
li $a0, 0					# borne inférieure pour le calcul d'un nombre aléatoire -> $a0
move $a1, $s0					# borne supérieure pour le calcul d'un nombre aléatoire -> $a1
jal nombre_alea_entre_deux_bornes
move $a1, $v0					# nombre aléatoire -> $a1
lw $a0, 0($sp)					# restauration de l'adresse de la pile -> $a0
jal lecture_cellule				# renvoie de l'indice séléctionné au hasard de la pile -> $v0
Endif_tirer_hasard_cellule:
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $s0, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16
jr $ra
####################



############################## Fonction marquer_visite_cellule
### 
### Cette fonction prend en paramètre deux arguments tel que 
### l'adresse d'une pile qui représente un labyrinthe et
### l'indice d'une cellule de ceci.
### Elle marque la cellule comme visité.
### 
### Entrées : l'adresse d'un labyrinthe ($a0), l'indice d'une cellule n ($a1)
### Sorties : -
### 
### Pré-conditions : 0 <= n <= taille du labyrinthe - 1
### Post-conditions : -
### 
marquer_visite_cellule:
# prologue
addi $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $s0, 12($sp)
sw $ra, 16($sp)
# corps
jal lecture_cellule
move $s0, $v0			# cellule à l'indice n -> $s0
move $a0, $s0
li $a1, 6
jal cell_mettre_bit_a1
move $s0, $v0			# cellule à l'indice n avec le bit numéro 6 qui est 1 -> $s0
lw $a0, 0($sp)
lw $a1, 4($sp)
move $a2, $s0
jal modifier_cellule		# remmetre la cellule modifié à l'indice n
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $s0, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
jr $ra
####################



############################## Fonction casser_mur_direction
### 
### Cette fonction prend en paramètre deux arguments tel qu'un entier
### qui représente une cellule et un entier qui représente une direction
### tel que haut, bas, gauche, droite par 1, 2, 3, 4 respectivement.
### Elle casse le mur de la cellule dans la direction indiqué en modifiant
### le bit représentant et renvoie le nouvel entier.
### 
### Entrées : un entier d'une cellule c ($a0), un entier d'une direction d ($a1)
### Sorties : un entier d'une cellule ($v0)
### 
### Pré-conditions : 0 <= c <= 99, 1 <= d <= 4
### Post-conditions : -
### 
casser_mur_direction:
# prologue
addi $sp, $sp, -12
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
# corps
bne $a1, 1, Elseif1_casser_mur_direction	# condition pour vérifier si on va vers le haut
li $a1, 0					# casser mur en haut
jal cell_mettre_bit_a0
b Endif1_casser_mur_direction
Elseif1_casser_mur_direction:
bne $a1, 2, Elseif2_casser_mur_direction	# condition pour vérifier si on va vers le bas
li $a1, 2					# casser mur en bas
jal cell_mettre_bit_a0
b Endif1_casser_mur_direction
Elseif2_casser_mur_direction:
bne $a1, 3, Elseif3_casser_mur_direction	# condition pour vérifier si on va vers la gauche
li $a1, 3					# casser mur à gauche
jal cell_mettre_bit_a0
b Endif1_casser_mur_direction
Elseif3_casser_mur_direction:
bne $a1, 4, Endif1_casser_mur_direction		# condition pour vérifier si on va vers la droite
li $a1, 1					# casser mur à droite
jal cell_mettre_bit_a0
Endif1_casser_mur_direction:
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
addi $sp, $sp, 12
jr $ra
####################



############################## Fonction casser_mur_cellule
### 
### Cette fonction prend en paramètre trois arguments tel que 
### l'adresse d'une pile qui représente un labyrinthe, l'indice de deux cellules de ceci.
### Elle casse le mur entre ces deux cellules en mettant le bit représentatif à 0.
### 
### Entrées : l'adresse d'un labyrinthe ($a0), l'indice d'une cellule n1 ($a1), l'indice d'une cellule n2 ($a2)
### Sorties : -
### 
### Pré-conditions : 0 <= n1 != n2 <= taille du labyrinthe - 1, les deux cellules sont voisines
### Post-conditions : -
### 
casser_mur_cellule:
# prologue
addi $sp, $sp, -40
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $s0, 12($sp)
sw $s1, 16($sp)
sw $s2, 20($sp)
sw $s3, 24($sp)
sw $s4, 28($sp)
sw $s5, 32($sp)
sw $ra, 36($sp)
# corps
move $s0, $a0					# copier l'adresse de la pile pour ne pas l'écraser -> $s0
lw $a0, 0($s0)					# charger le nombre total de cellules du labyrinthe -> $a0
move $s2, $a0					# copier le nombre total de cellules pour ne pas écraser -> $s2
jal racine_carre				# calcul de la racine carré du nombre total de cellules pour trouver la taille d'une ligne
move $s1, $v0					# taille d'une ligne du labyrinthe -> $s1
move $a0, $s0
addi $s3, $a1, 1
bne $s3, $a2, Elseif1_casser_mur_cellule	# condition pour vérifier si la cellule n2 est à droite de la cellule n1
jal lecture_cellule
move $s4, $v0					# la valeur de la cellule n1 -> $s4
move $a0, $s4
li $a1, 4
jal casser_mur_direction
move $s5, $v0					# la valeur de la cellule n1 après mur cassé -> $s5
move $a2, $s5
lw $a1, 4($sp)
move $a0, $s0
jal modifier_cellule
move $a0, $s0
lw $a1, 8($sp)
jal lecture_cellule
move $s4, $v0					# la valeur de la cellule n2 -> $s4
move $a0, $s4
li $a1, 3
jal casser_mur_direction
move $s5, $v0					# la valeur de la cellule n2 après mur cassé -> $s5
move $a2, $s5
lw $a1, 8($sp)
move $a0, $s0
jal modifier_cellule
b Endif_casser_mur_cellule
Elseif1_casser_mur_cellule:
subi $s3, $a1, 1
bne $s3, $a2, Elseif2_casser_mur_cellule	# condition pour vérifier si la cellule n2 est à gauche de la cellule n1
jal lecture_cellule
move $s4, $v0					# la valeur de la cellule n1 -> $s4
move $a0, $s4
li $a1, 3
jal casser_mur_direction
move $s5, $v0					# la valeur de la cellule n1 après mur cassé -> $s5
move $a2, $s5
lw $a1, 4($sp)
move $a0, $s0
jal modifier_cellule
move $a0, $s0
lw $a1, 8($sp)
jal lecture_cellule
move $s4, $v0					# la valeur de la cellule n2 -> $s4
move $a0, $s4
li $a1, 4
jal casser_mur_direction
move $s5, $v0					# la valeur de la cellule n2 après mur cassé -> $s5
move $a2, $s5
lw $a1, 8($sp)
move $a0, $s0
jal modifier_cellule
b Endif_casser_mur_cellule
Elseif2_casser_mur_cellule:
add $s3, $a1, $s1				# condition pour vérifier si la cellule n2 est au bas de la cellule n1
bne $s3, $a2, Elseif3_casser_mur_cellule
jal lecture_cellule
move $s4, $v0					# la valeur de la cellule n1 -> $s4
move $a0, $s4
li $a1, 2
jal casser_mur_direction
move $s5, $v0					# la valeur de la cellule n1 après mur cassé -> $s5
move $a2, $s5
lw $a1, 4($sp)
move $a0, $s0
jal modifier_cellule
move $a0, $s0
lw $a1, 8($sp)
jal lecture_cellule
move $s4, $v0					# la valeur de la cellule n2 -> $s4
move $a0, $s4
li $a1, 1
jal casser_mur_direction
move $s5, $v0					# la valeur de la cellule n2 après mur cassé -> $s5
move $a2, $s5
lw $a1, 8($sp)
move $a0, $s0
jal modifier_cellule
b Endif_casser_mur_cellule
Elseif3_casser_mur_cellule:
sub $s3, $a1, $s1
bne $s3, $a2, Endif_casser_mur_cellule		# condition pour vérifier si la cellule n2 est au haut de la cellule n1
jal lecture_cellule
move $s4, $v0					# la valeur de la cellule n1 -> $s4
move $a0, $s4
li $a1, 1
jal casser_mur_direction
move $s5, $v0					# la valeur de la cellule n1 après mur cassé -> $s5
move $a2, $s5
lw $a1, 4($sp)
move $a0, $s0
jal modifier_cellule
move $a0, $s0
lw $a1, 8($sp)
jal lecture_cellule
move $s4, $v0					# la valeur de la cellule n2 -> $s4
move $a0, $s4
li $a1, 2
jal casser_mur_direction
move $s5, $v0					# la valeur de la cellule n2 après mur cassé -> $s5
move $a2, $s5
lw $a1, 8($sp)
move $a0, $s0
jal modifier_cellule
Endif_casser_mur_cellule:
# épilogue
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $s0, 12($sp)
lw $s1, 16($sp)
lw $s2, 20($sp)
lw $s3, 24($sp)
lw $s4, 28($sp)
lw $s5, 32($sp)
lw $ra, 36($sp)
addi $sp, $sp, 40
jr $ra
####################
