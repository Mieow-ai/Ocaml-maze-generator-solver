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

let dim fichier =
  let ouvert = open_in fichier in
  let rec loop acc =
    try
      let _ = input_line ouvert in
      loop acc+1
    with End_of_file ->
      close_in ouvert;
      acc
  in
  (loop 0, String.length (input_line ouvert))


let lire_ligne_murs ligne dim=
  let longueur = String.length ligne in
  if fst dim != longueur then failwith "La ligne n'est pas à la bonne longueur"
  else
  let rec loop indice car =
    if indice < longueur then
      match car with 
        |'+'->loop (indice+1) ligne.[indice+1] 
        |'-'->loop (indice+1) ligne.[indice+1]
        |_-> failwith "Un mur ne peut être que + ou -" in
  loop 0 ligne.[0]
  
let lire_ligne_piece ligne dim =
  let longueur = String.length ligne in
  if fst dim != longueur then failwith "La ligne n'est pas à la bonne longueur"
  else
  let rec loop indice car =
    if indice < longueur then
      match car with 
        |' '->loop (indice+1) ligne.[indice+1]
        |'S'->loop (indice+1) ligne.[indice+1]
        |'E'->loop (indice+1) ligne.[indice+1]
        |'|'->loop (indice+1) ligne.[indice+1]
        |_-> failwith "Le format n'est pas respecté" in
  loop 0 ligne.[0]

  let check_format fichier = 
    let dimension = dim fichier in
    let ouvert = open_in fichier in
    let rec loop = 
      try
        let l1 = input_line ouvert in
        lire_ligne_murs l1 dimension;
        let l2 = input_line ouvert in
        lire_ligne_piece l2 dimension;
      with End_of_file ->
        close_in ouvert in
    loop


    let create_grid_line l1 l2 l3 dim=
          let dim_grid = ((snd dim-1) / 2,(fst dim-1) / 2) in
          let res = Array.init (snd dim_grid) (fun _ ->              
            { sortie = false; entree = false; mur_h = false; mur_b = false;             
            mur_g = false; mur_d = false }) in
          let rec loop haut cote res = 
            if (haut < snd dim_grid && cote < snd dim_grid) then
              match l1[2*haut +1],l3[2*haut +1] with
                |("-","-") -> res.(haut).mur_h <- true; res.(haut).mur_b <- true;
                              begin match ( l2[cote*2 - 2], l2[cote*2]) with
                                |("|", "|") -> res.(cote).mur_g <- true; res.(cote).mur_d <- true
                                |(" ", " ") -> ()
                                |("|", " ") -> res.(cote).mur_g <- true
                                |(" ", "|") -> res.(cote).mur_d <- true
                                |_ -> failwith "Erreur de format"
                              end
                |(" ", " ")-> begin match ( l2[cote*2 - 2], l2[cote*2]) with
                                |("|", "|") -> res.(cote).mur_g <- true; res.(cote).mur_d <- true
                                |(" ", " ") -> ()
                                |("|", " ") -> res.(cote).mur_g <- true
                                |(" ", "|") -> res.(cote).mur_d <- true
                                |_ -> failwith "Erreur de format"
                              end
                |("-"," ") -> res.(haut).mur_h <- true;
                              begin match ( l2[cote*2 - 2], l2[cote*2]) with
                                |("|", "|") -> res.(cote).mur_g <- true; res.(cote).mur_d <- true
                                |(" ", " ") -> ()
                                |("|", " ") -> res.(cote).mur_g <- true; loop (haut+1) (cote+1) res
                                |(" ", "|") -> res.(cote).mur_d <- true; loop (haut+1) (cote+1) res
                                |_ -> failwith "Erreur de format"
                              end
                |(" ", "-") ->res.(haut).mur_b <- true;
                              begin match ( l2[cote*2 - 2], l2[cote*2]) with
                                |("|", "|") -> res.(cote).mur_g <- true; res.(cote).mur_d <- true; loop (haut+1) (cote+1) res
                                |(" ", " ") -> loop (haut+1) (cote+1) res
                                |("|", " ") -> res.(cote).mur_g <- true; loop (haut+1) (cote+1) res
                                |(" ", "|") -> res.(cote).mur_d <- true; loop (haut+1) (cote+1) res
                                |_ -> failwith "Erreur de format"
                              end
                |_ -> failwith "Erreur de format"
      

          


  let load _ = failwith "todo"
  let print _ = failwith "todo"
  

(*let load fichier =
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
    *)

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

(*let piece_to_string p =
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
*)

(*let print g =
  Array.iter (fun ligne ->
    let floor_array = Array.map piece_to_string_ceilling ligne in
    Array.iter print_endline floor_array;
    let wall_array = Array.map piece_to_string_wall ligne in
    Array.iter print_endline wall_array
  ) g;
  Array.iter print_endline (Array.map (piece_to_string_floor) (g.((Array.length g) - 1)))
*)
(*
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

*)