type piece =
  {
    mutable sortie : bool;
    mutable entree : bool;
    mutable mur_h : bool;
    mutable mur_b : bool;
    mutable mur_d : bool;
    mutable mur_g : bool;
  }                                   
type grid = (piece array) array                 (*Notre grille qui est constitué de listes de composants*)

let choose_random_bool () = 
  Random.int 100 < 50

let random_piece (p : piece) =
  {entree = false; sortie = false;mur_h = p.mur_h; mur_b = choose_random_bool (); mur_d = choose_random_bool (); mur_g = choose_random_bool ()}

let random_grid n m =
  let grid =
    Array.init n (fun _ ->                 
      Array.init m (fun _ ->              
        { sortie = false; entree = false;mur_h = false; mur_b = false;             
          mur_g = false; mur_d = false }           
      )) in
  Array.iter (fun piece -> piece.mur_h <- true) grid.(0); 
  Array.iter (fun colonne ->
     Array.iter (fun piece ->
      let rand = random_piece piece in
        piece.mur_d <- rand.mur_d;
        piece.mur_g <- rand.mur_g;
        piece.mur_b <- rand.mur_b;
                ) colonne
              ) grid;
  grid

let random_line_floors length =
  let rec loop i acc =
    if i = length then acc
    else
      let r = Random.int 100 in
      let acc =
        if r < 50 then acc ^ "-+"
        else acc ^ " +"
      in
      loop (i + 1) acc
  in
  loop 0 "+"
      
let random_line_walls length =
  let rec loop i acc =
    if i = length then acc
    else
      let r = Random.int 100 in
      let acc =
        if r < 50 then acc ^ "|  "
        else acc ^ "   "
      in
      loop (i + 1) acc
  in
  loop 0 ""

let random_positions n m =
  let e_row = Random.int n
  and e_col = Random.int m in
  let rec pick () =
    let s_row = Random.int n
    and s_col = Random.int m in
    if s_row = e_row && s_col = e_col then pick ()
    else (s_row, s_col)
  in
  let s_row, s_col = pick () in
  (e_row, e_col, s_row, s_col)

let random_file n m filename =
  let file = open_out filename in
  let e_row, e_col, s_row, s_col = random_positions n m in
  output_string file (random_line_floors m ^ "\n");
  for row = 0 to n - 1 do
    output_string file (random_line_floors m ^ "\n");
    let base = random_line_walls m in
    let chars = Bytes.of_string base in
    let pos =
      if row = e_row then e_col
      else if row = s_row then s_col
      else -1
    in
    if pos <> -1 then
      let offset = pos * 3 + 1 in
      Bytes.set chars offset (if row = e_row then 'E' else 'S');

    output_string file (Bytes.to_string chars ^ "\n");
  done;
  close_out file