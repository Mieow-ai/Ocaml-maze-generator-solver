open Grid

(* Vérifie si les coordonnées sont dans la liste des coordonnées *)
let est_dans_chemin x y chemin =
  List.exists (fun (px, py) -> px = x && py = y) chemin

(* Affiche la solution du labyrinthe *)
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
      if grille.(i).(j).mur_g then Printf.printf "|" else Printf.printf " ";    (*Pour cette fonction on a gardé*)
      if grille.(i).(j).entree then Printf.printf "E"                           (*Le même format que pour la fonction*)
      else if grille.(i).(j).sortie then Printf.printf "S"                      (*Print du module grid mais en rajoutant*)
      else if est_dans_chemin i j chemin then Printf.printf "*"                 (*les étoiles pour tracer le chemin*)
      else Printf.printf " ";
    done;
    Printf.printf "|\n";
  done;
  for j = 0 to colonnes - 1 do
    Printf.printf "+-"
  done;
  Printf.printf "+\n"

(* Renvoie les coordonnées de l'entrée *)
let entree_coord grille =
  let n = Array.length grille in
  let m = Array.length grille.(0) in
  let rec loop_i i =
    if i >=n then failwith "Pas trouvée"
    else
      let rec loop_j j =
        if j >= m then loop_i (i + 1)
        else if grille.(i).(j).entree then (i, j)      (*si on trouve l'entrée on renvoie ses coordonnées*)
        else loop_j (j + 1)
      in loop_j 0
  in loop_i 0

(* Résout le labyrinthe *)
let solve grille = 
  let n = Array.length grille in
  let m = Array.length grille.(0) in
  let deja_vu = Array.make_matrix n m false in   (*Matrice de même dimension que la grille initialisée à false*)
  let rec parcours (x, y) = 
    if grille.(x).(y).sortie  then Some [(x, y)] (*Si on est à la sortie, c'est bon*)
    else (
      deja_vu.(x).(y) <- true;                   (*Sinon on met qu'on est déjà passé par là*)
      let mouvements = [                         (*On définit les directions possibles (gauche, droite, haut, bas)*)
        (-1, 0, grille.(x).(y).mur_h);
        (1, 0, grille.(x).(y).mur_b);
        (0, -1, grille.(x).(y).mur_g);
        (0, 1, grille.(x).(y).mur_d);
      ] in
      let rec mouv_rec mouv =                    (*Cette sous-fonction va tester toutes les directions*)
        match mouv with
        | [] -> None                             (*Directions épuisées, on a pas trouvé de chemin*)
        | (dx, dy, is_mur) :: mm ->
          let nx, ny = x + dx, y + dy in
          if nx >= 0 && nx < n && ny >= 0 && ny < m && not is_mur && not deja_vu.(nx).(ny) then (* On vérifie si après déplacement on est dans limites de grille, que ce n'est pas un mur et qu'on est pas déjà passé par là*)
            match parcours (nx, ny) with         (*On parcourt dans cette direction*)
            |Some chemin -> Some ((x, y) :: chemin) (*Si il y a déjà un chemin vers la sortie on ajoute les coordonnées de position actuelle*)
            |None -> mouv_rec mm                    (*Sinon on teste sur une autre direction*)
          else
            mouv_rec mm
      in mouv_rec mouvements
    )
    in
    let depart_pos = entree_coord grille in
    match parcours depart_pos with                  (*On appelle parcours depuis l'entrée*)
    |Some chemin -> 
      Printf.printf "Chemin trouvé ! Longueur  : %d étapes. \n" (List.length chemin);
      print_solve grille chemin
    |None -> print_endline "Aucun chemin possible vers la sortie"
    
