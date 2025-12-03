type piece =
  {
    mutable mur_h : bool;
    mutable mur_b : bool;
    mutable mur_d : bool;
    mutable mur_g : bool;
  }                                   
type grid = (piece array) array                 (*Notre grille qui est constitué de listes de composants*)

let dim fichier =
  let ouvert = open_in fichier in
  let rec loop lignes colonnes =
    try
      let ligne = input_line ouvert in
      let len = String.length ligne in
      loop (lignes + 1) (max colonnes len)
    with End_of_file ->
      close_in ouvert;
      (lignes, colonnes)
  in
  loop 0 0
    
let load fichier =
  let (h, w) = dim fichier in
  let ouvert = open_in fichier in
  let grid =
    Array.init ((h-1)/3) (fun _ ->                  (*On initialise notre grille vide*)
      Array.init ((w-1) / 3) (fun _ ->              
        { mur_h = false; mur_b = false;             
          mur_g = false; mur_d = false }           
      ))
  in
  let rec loop acc ligne =
    if ligne = h then
      acc
    else begin
      let c = input_line ouvert in
      let longueur = String.length c in
      for i = 0 to (longueur - 1) / 2 do
        let ch_floor = c.[2*i + 1] in
        begin match ch_floor with
        |'-' ->
            if ligne > 0 && ligne < h - 1 then begin
              acc.((ligne/3)-1).((i-1)/3).mur_b <- true;
              acc.((ligne/3)+1).((i-1)/3).mur_h <- true;
            end else if ligne = 0 then
              acc.((ligne/3)+1).((i-1)/3).mur_h <- true
            else
              acc.((ligne/3)-1).((i-1)/3).mur_b <- true
        |_ -> ()
        end;
        let ch_wall = c.[2*i] in
        begin match ch_wall with
        |'|' ->
            let j = (i-1)/3 in
            acc.(ligne/3).(j-1).mur_d <- true;
            acc.(ligne/3).(j+1).mur_g <- true
        |_ -> ()
        end;
      done;
      loop acc (ligne + 1)
    end
    in
    let res = loop grid 0 in
    close_in ouvert;
    res

(*
let piece_to_string_ceilling p = 
  if p.mur_h then "+-+"
  else "+ +"

let piece_to_string_wall p = 
  if p.mur_g then "|"
  else if p.mur_d then "  |"
  else "    "

let piece_to_string_floor p = 
  if p.mur_b then "+-+"
  else "+ +"
*)

let piece_to_string p =
  match (p.mur_h, p.mur_b, p.mur_g, p.mur_d) with
  | (true, true, true, true) -> ("+-+", "|  |", "+-+")
  | (true, true, true, false) -> ("+-+", "|   ", "+-+")
  | (true, true, false, true) -> ("+-+", "   |", "+-+")
  | (true, true, false, false) -> ("+-+", "    ", "+-+")
  | (true, false, true, true) -> ("+-+", "|  |", "+ +")
  | (true, false, true, false) -> ("+-+", "|   ", "+ +")
  | (true, false, false, true) -> ("+-+", "   |", "+ +")
  | (true, false, false, false) -> ("+-+", "    ", "+ +")
  | (false, true, true, true) -> ("   ", "|  |", "+-+")
  | (false, true, true, false) -> ("   ", "|   ", "+-+")
  | (false, true, false, true) -> ("   ", "   |", "+-+")
  | (false, true, false, false) -> ("   ", "    ", "+-+")
  | (false, false, true, true) -> ("   ", "|  |", "+ +")
  | (false, false, true, false) -> ("   ", "|   ", "+ +")
  | (false, false, false, true) -> ("   ", "   |", "+ +")
  | (false, false, false, false) -> ("   ", "    ", "+ +")

(*let print g =
  Array.iter (fun ligne ->
    let floor_array = Array.map piece_to_string_ceilling ligne in
    Array.iter print_endline floor_array;
    let wall_array = Array.map piece_to_string_wall ligne in
    Array.iter print_endline wall_array
  ) g;
  Array.iter print_endline (Array.map (piece_to_string_floor) (g.((Array.length g) - 1)))
*)

let print g =
  Array.iter (fun array ->
     let ceilling_line, wall_line, floor_line =
      Array.fold_left (fun (c_acc, w_acc, f_acc) p ->
         let c, w, f =
          piece_to_string p in (c_acc ^ c, w_acc ^ w, f_acc ^ f)) ("", "", "") array
          in
          print_endline ceilling_line;
          print_endline wall_line;
          print_endline floor_line;
      ) g