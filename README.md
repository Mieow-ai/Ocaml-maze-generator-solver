# Projet OCaml : Labyrinthe

Ceci est notre projet labyrinthe qui consiste à généré aléatoirement, afficher et chargé des labyrinthes sous forme de texte dans des fichiers et à partir de fichiers textes ou d'une structure qui nous est propre, notre structure grid.

Le projet vise à explorer des **algorithmes de graphes**, à manipuler des structures de données en **Ocaml**, et à combiner une approche fonctionnelle avec des éléments impératifs (tableaux, entrées-sorties).

## Binôme et Groupe

### Corvoysier Simon
### Shortall Antoine
### LDD2 IM1

## Objectifs du projet

1.  **Algorithmique :** Mise en œuvre d'algorithmes fondamentaux (génération, parcours en profondeur, etc.).
2.  **Paradigmes :** Mélange de code fonctionnel pur et d'effets de bord (gestion de fichiers, `Array`, etc.).
3.  **Génie Logiciel :** Organisation modulaire, utilisation de `dune` pour le build, et gestion des arguments CLI.

---

## Prérequis

* **OCaml** (version récente recommandée)
* **Dune** (système de build)

## Compilation

Pour compiler le projet et générer l'exécutable, on se place à la racine du projet et on fait :

```bash
dune build
```

## Exécution

### Globale
```bash
dune exec -- ./maze.exe <commande> [arguments]
```
### Aide 
```bash
dune exec -- ./maze.exe --help
```
### Exemples
```bash
dune exec -- ./maze.exe random 15 30 data.laby
```
```bash
dune exec -- ./maze.exe print data.laby
```

