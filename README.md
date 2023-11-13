# Projet d'Architecture S3 (2022-2023)

## Introduction

Ceci est le projet labyrinthe réalisé dans le cadre de l'UE "Architecture des Ordinateurs" du semestre 3 de l'année universitaire 2022-23. Il a été fait dans **6 jours** pendant les vacances de la semaine du 31 octobre pour être rendu le dimanche 6 novembre. 😳

Le fichier rendu du projet est celui nommé `labyrinthe.s` contenant du code source assembleur MIPS. Il est à executer avec le simulateur MARS inclus.

Avec le [pdf du sujet](https://git.unistra.fr/erken/labyrinthe/-/blob/master/ProjetArchi.pdf) vous pouvez vous renseigner sur le projet. Malheureusement d'un point de vue optimisation, complexité et efficacité, il n'est pas le meilleur même si j'ai suivi avec précision la progression conseillée.

### Correction finale (14.11.2023)

Au moment de rendu de ce projet le 06.11.2022, pour plusieurs raisons (contrainte de temps sévère, être un dévéloppeur novice sans beaucoup de vision...), je n'avais pas pu réussir les demandes du sujet et le spec à 100%. Notamment, j'avais remplacé l'algorithme décrit dans le sujet par un plus simple par fausse impression et peur de complexité et temps d'execution inenvisageable. Mais au moment je me suis rendu compte qu'en fait il n'y avait pas de problème, c'était trop tard pour reécrire des parties pour implementer l'algorithme proposé comme tel et se débarasser des déviations introduits par rapport au sujet.

Cette différence dans le choix d'algorithme était la raison pour laquelle la sortie (le labyrinthe aléatoire généré à une unique solution) n'était même pas proche des exemples dans le sujet. Pourtant jusqu'à l'étape finale qui était la sortie, tous les autres systèmes internes marchait sans soucis. Mais à cet époque là je pensais le problème plus grand et plus compliqué que juste la différence dans l'algorithme.

Le fait que je n'avais pas pu fournir un résultat au spec, principalement à cause de la contrainte de temps me dérangait depuis que j'avais rendu le projet. Mais malheureusement l'année scolaire continuait à toute vitesse et je ne pouvais pas revenir à ce projet pour le laisser dans un état correcte et complet.

Mais, me voici 💪, de retour le 14.11.2023 (après exactement un an, quelle coïncidence 🤔) pour ne pas laisser mes efforts en vain, ayant accumulé plus de connaissances et de l'éxperience en informatique (maintenant en L3) pour corriger le passé. Un dernier effort, pour laisser ce projet reposer en paix, ça le mérite... 🫡

Les quelques petits changements (surprenant comment c'était simple en fait) que j'ai fait sont les suivants :

* Changer le seed pour le générateur pseudo aléatoire dans `Alea.s` par l'horloge système à chaque appel pour avoir un génération de labyrinthe correctement aléatoire.
* Remplacer l'algorithme complétement par celui dans le sujet situé dans la fonction `generer_laby`.
  * Utiliser le deuxième octet des mots mémoire qui stockent les cellules du labyrinthe pour stocker les indices des cellules dans les cellules sans autre structure de donnée (bits numéro 8+). (Extension au sujet du projet parce que je suis paresseux pour faire plus, mon but n'est rien d'autre à ce moment là de rendre le projet fonctionnel)
  * Corriger et simplifier la fonction `cell_mettre_bit_a0` pour que cela ne touche pas les autres bits que concerné. (Pour que la solution du point précedent marche)
  * Améliorer la fonction `creer_laby` pour créer le labyrinthe initial mais avec les indices encodés dans les cellules correspondantes.
  * Corriger la fonction `nettoyer_laby` pour mettre à 0 tous les bits de chaque cellule sauf les 6 premiers.

Ces changements ne font que rendre le projet fonctionnel avec la sortie et le fonctionnement désormais correspondant au spec. Mais ce n'est toujours pas sa version ultime : le plus lisible, le mieux documenté ou le plus optimisé. Peu importe, ça marche et ça marche bien. C'était un drôle de défi amusant qui m'a fait bien réfléchir, et c'est ce qui compte. J'ai beaucoup appris grâce à ce projet.

Il existe un rapport de projet (`Rapport.pdf`) dans l'itération de [rendu officel](https://git.unistra.fr/erken/labyrinthe/-/tree/Rendu_Final) pour vous renseigner sur les difficultés que j'ai eu et les choix d'implémentation lors de mon travail initial sur ce projet. Jetez un oeil à cette version pour voir ce projet dans son état au moment du rendu officiel.

## Commandes à utiliser pour l'execution

Dans un premier temps rendez le shell script "print_maze.sh" executable par :

```bash
chmod u+x print_maze.sh
```

Puis, executer ces deux lignes de commandes en mettant la taille que vous voulez dans l'intervalle **[2; 9]**:

```bash
java -jar Mars4_5.jar p me labyrinthe.s pa {taille du labyrinthe} > laby.txt

./print_maze.sh laby.txt
```
