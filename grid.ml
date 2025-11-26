type piece =
  {
    mur_h : bool;
    mur_b : bool;
    mur_d : bool;
    mur_g : bool;
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
    Array.init h (fun _ ->
      Array.init (w / 3) (fun _ ->
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
              acc.(ligne-1).((i-1)/3).mur_b <- true;
              acc.(ligne+1).((i-1)/3).mur_h <- true;
            end else if ligne = 0 then
              acc.(ligne+1).((i-1)/3).mur_h <- true
            else
              acc.(ligne-1).((i-1)/3).mur_b <- true
        |_ -> ()
        end;
        let ch_wall = c.[2*i] in
        begin match ch_wall with
        |'|' ->
            let j = (i-1)/3 in
            acc.(ligne).(j-1).mur_d <- true;
            acc.(ligne).(j+1).mur_g <- true
        |_ -> ()
        end;
      done;
      loop acc (ligne + 1)
    end
    in
    let res = loop grid 0 in
    close_in ouvert;
    res


