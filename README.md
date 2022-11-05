# Projet d'Architecture S3 (2022-2023)

## Introduction

Ceci est le projet labyrinthe réalisé dans le cadre de l'UE "Architecture des Ordinateurs" du semmestre 3 de l'année universitaire 2022-23. Il a été fait dans 6 jours pendant les vacances de la semaine du 31 octobre pour être rendu le dimanche 6 novembre. 

Le fichier rendu du projet est celui nommé "labyrinthe.s" contenant du code source assembleur MIPS. Il est à executer avec le simulateur MARS inclus.

Avec le pdf du sujet vous pouvez vous renseigner sur le projet. Malheureusement d'un point de vue optimisation, complexité et efficacité, il n'est pas le meilleur même si j'ai suivi avec précision la progression conseillée.

## Commandes à utiliser pour l'execution

Dans un premier temps rendez le shell script "print_maze.sh" executable par :

```bash
chmod u+x print_maze.sh
```

Puis, executer ces deux lignes de commandes en mettant la taille que vous voulez :

```bash
java -jar Mars4_5.jar p me labyrinthe.s pa <taille du labyrinthe> > laby.txt

./print_maze.sh laby.txt
```

