
(*Renvoie une ligne de toits random (donc constituée de + et de -)*)
val random_line_floors : int -> string

(*Renvoie une ligne de murs random (donc constituée de | et de " ") pour l'instant*)
val random_line_walls : int -> string

(*Renvoie des coordonnées aléatoires (x,y) pour nos entrées sorties*)
val random_positions : int -> int -> int * int * int * int

(*Renvoie un fichier dans lequel a été écrit un labyrinthe généré aléatoirement*)
val random : int -> int -> string -> unit