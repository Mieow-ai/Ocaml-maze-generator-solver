
(*Renvoie une ligne de toits random (donc constituée de + et de -)*)
let random_line_floors length =
  let rec loop i acc =                                      (*On s'arrête quand on a atteint la longueur d'une ligne*)
    if i = length then acc
    else
      let r = Random.int 100 in                             (*Deux choix possibles pour les toits (soit '-' soit ' ')*)
      let acc =
        if r < 50 then acc ^ "-+"
        else acc ^ " +"
      in
      loop (i + 1) acc
  in
  loop 0 "+"

(*Renvoie une ligne de murs random (donc constituée de | et de " ") pour l'instant*)
let random_line_walls length =
  let rec loop i acc =
    if i = length then acc
    else
      let r = Random.int 100 in                             (*Deux choix possibles pour les toits (soit '|' soit ' ')*)
      let acc =
        if r < 50 then acc ^ "| "
        else acc ^ "  "
      in
      loop (i + 1) acc
  in
  loop 0 ""

(*Renvoie des coordonnées aléatoires (x,y) pour nos entrées sorties*)
let random_positions n m =
  let e_row = Random.int n                                  (*coordonnée x de 'E'*)
  and e_col = Random.int m in                               (*coordonnée y de 'E'*)
  let rec choix () =                                        (*C'est en soit un while*)
    let s_row = Random.int n                                (*coordonnée x de 'S'*)
    and s_col = Random.int m in                             (*coordonnée y de 'S'*)
    if s_row = e_row && s_col = e_col then choix ()
    else (s_row, s_col)
  in
  let s_row, s_col = choix () in
  (e_row, e_col, s_row, s_col)

(*Renvoie un fichier dans lequel a été écrit un labyrinthe généré aléatoirement*)
let random n m filename =
  let file = open_out filename in
  let e_row, e_col, s_row, s_col = random_positions n m in
  output_string file (random_line_floors m ^ "\n");         (*On écrit la première ligne*)
  for row = 0 to n - 1 do                                   (*Puis on écrit à chaque ligne de pièces, la ligne de murs et de toits (ici sols)*)
    output_string file (random_line_floors m ^ "\n");       (*sols*)
    let base = random_line_walls m in                       (*murs sans 'E' et 'S'*)
    let chars = Bytes.of_string base in                     (*conversion en bits car les string sont immuables, avec les bits on peut modifier plus facilement*)
    let pos =                                               (*dire si l'on est sur au moins une ligne correspondante à la future position de 'E' ou 'S'*)
      if row = e_row then e_col
      else if row = s_row then s_col
      else -1
    in
    if pos <> -1 then
      Bytes.set chars pos (if row = e_row then 'E' else 'S');      (*On l'écrit dans notre écriture en bits*)

    output_string file (Bytes.to_string chars ^ "\n");                (*Puis on affiche la ligne de murs après re-conversion en string*)
  done;
  close_out file


let () =
  random 10 10 "test.txt"