open Grid


let est_dans_chemin x y chemin =
  List.exists (fun (px, py) -> px = x && py = y) chemin

let print_solve (grille : grid) chemin = 
  let lignes = Array.length grille in
  let colonnes = Array.length grille.(0) in
  for i = 0 to lignes - 1 do
    for j = 0 to colonnes - 1 do
      Printf.printf "+";
      if grille.(i).(j).mur_h then Printf.printf "-" else Printf.printf " ";
    done;
    Printf.printf "+\n";
    for j = 0 to colonnes - 1 do
      if grille.(i).(j).mur_g then Printf.printf "|" else Printf.printf " ";
      if grille.(i).(j).entree then Printf.printf "E"
      else if grille.(i).(j).sortie then Printf.printf "S"
      else if est_dans_chemin i j chemin then Printf.printf "*"
      else Printf.printf " ";
    done;
    Printf.printf "|\n";
  done;
  for j = 0 to colonnes - 1 do
    Printf.printf "+-"
  done;
  Printf.printf "+\n"

let entree_coord grille =
  let n = Array.length grille in
  let m = Array.length grille.(0) in
  let rec loop_i i =
    if i >=n then failwith "Pas trouvée"
    else
      let rec loop_j j =
        if j >= m then loop_i (i + 1)
        else if grille.(i).(j).entree then (i, j)
        else loop_j (j + 1)
      in loop_j 0
  in loop_i 0

let solve grille = 
  let n = Array.length grille in
  let m = Array.length grille.(0) in
  let deja_vu = Array.make_matrix n m false in
  let rec parcours (x, y) = 
    if grille.(x).(y).sortie  then Some [(x, y)]
    else (
      deja_vu.(x).(y) <- true;
      let mouvements = [
        (-1, 0, grille.(x).(y).mur_h);
        (1, 0, grille.(x).(y).mur_b);
        (0, -1, grille.(x).(y).mur_g);
        (0, 1, grille.(x).(y).mur_d);
      ] in
      let rec mouv_rec mouv =
        match mouv with
        | [] -> None
        | (dx, dy, is_mur) :: mm ->
          let nx, ny = x + dx, y + dy in
          if nx >= 0 && nx < n && ny >= 0 && ny < m && not is_mur && not deja_vu.(nx).(ny) then
            match parcours (nx, ny) with
            |Some chemin -> Some ((x, y) :: chemin)
            |None -> mouv_rec mm
          else
            mouv_rec mm
      in mouv_rec mouvements
    )
    in
    let depart_pos = entree_coord grille in
    match parcours depart_pos with
    |Some chemin -> 
      Printf.printf "Chemin trouvé ! Longueur  : %d étapes. \n" (List.length chemin);
      print_solve grille chemin
    |None -> print_endline "Aucun chemin possible vers la sortie"
    
