type piece               (*Notre structure piece *)
type grid                (*Notre grille qui est constitué de listes de composants*)


(* Renvoi les dimensions du contenu d'un fichier (probablement txt) *)
val dim : string -> int * int
(* Vérifie que les murs sont sous le bon format *)
val lire_ligne_murs : string -> 'a * int -> unit
(* Vérifie que les pièces sont sous le bon format *)
val lire_ligne_piece : string -> 'a * int -> unit
(* Vérifie qu'un fichier est sous le bon format *)
val check_format : string -> unit
(* Créer une ligne de notre grille finale *)
val create_grid_line : string -> string -> string -> 'a * int -> piece array
(* Converti le labyrinthe d'un fichier selon notre structure de données *)
val load : string -> grid
(* Affiche le labyrinthe d'un fichier *)
val print : grid -> unit
