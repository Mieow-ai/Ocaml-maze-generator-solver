open Grid

(* Vérifie si les coordonnées sont dans la liste des coordonnées *)
val est_dans_chemin : int -> int -> (int * int) list -> bool
(* Renvoie les coordonnées de l'entrée *)
val entree_coord : grid -> (int * int)
(* Affiche la solution du labyrinthe *)
val print_solve : grid -> (int * int) list -> unit
(* Résout le labyrinthe *)
val solve : grid -> unit