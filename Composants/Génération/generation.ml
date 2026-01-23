
(*Renvoie une ligne de toits random (donc constituée de + et de -)*)
let random_line_floors length =
  let rec loop i acc =                                      (*On s'arrête quand on a atteint la longueur d'une ligne*)
    if i = length then acc ^ "+"
    else
      let r = Random.int 100 in                             (*Deux choix possibles pour les toits (soit '-' soit ' ')*)
      let acc =
        if r < 50 then acc ^ "+-"
        else acc ^ "+ "
      in
      loop (i + 1) acc
  in
  loop 0 ""

(*Renvoie une ligne de murs random (donc constituée de | et de " ") pour l'instant*)
let random_line_walls length =
  let rec loop i acc =
    if i = length - 1 then acc ^ "|"
    else
      let r = Random.int 100 in                             (*Deux choix possibles pour les toits (soit '|' soit ' ')*)
      let acc =
        if r < 50 then acc ^ "| "
        else acc ^ "  "
      in
      loop (i + 1) acc
  in
  loop 0 "| "

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

  let first_and_last m =
  let rec loop res m =
    if m = 0 then res ^ "+"
    else loop (res ^ "+-") (m - 1)
  in
  loop "" m

(*Renvoie un fichier dans lequel a été écrit un labyrinthe généré aléatoirement*)
let random n m filename =
  let file = open_out filename in
  let e_row, e_col, s_row, s_col = random_positions n m in
  let first_and_last = first_and_last m in

  output_string file (first_and_last ^ "\n");                 (* ligne du premier toit *)

  for row = 0 to n - 1 do
    let base = random_line_walls m in                         (* ligne des murs *)
    let chars = Bytes.of_string base in
    if row = e_row then Bytes.set chars (2 * e_col + 1) 'E';  (* placement de E et S *)
    if row = s_row then Bytes.set chars (2 * s_col + 1) 'S';
    output_string file (Bytes.to_string chars ^ "\n");
    if row < n - 1 then output_string file (random_line_floors m ^ "\n");
  done;
  output_string file (first_and_last ^ "\n");

  close_out file


let () =
  random 10 10 "test.txt"