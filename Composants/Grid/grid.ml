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

(* Renvoi les dimensions du contenu d'un fichier (probablement txt) *)
let dim fichier =
  let ouvert = open_in fichier in
  try
    let first = input_line ouvert in
    let len = String.length first in
    let rec loop acc =
      try
        let _ = input_line ouvert in
        loop (acc + 1)
      with End_of_file -> acc                   (*On arrête lorsqu'on est à la fin du fichier en renvoyant l'accumulateur*)
    in
    let lines = loop 1 in
    close_in ouvert;
    (lines, len)
  with e ->
    close_in_noerr ouvert;
    raise e

(* Vérifie que les murs sont sous le bon format *)
let lire_ligne_murs ligne dim=
  let longueur = String.length ligne in
  if snd dim != longueur then failwith "La ligne n'est pas a la bonne longueur"
  else
  let rec loop indice car =
    if indice < longueur - 1 then
      match car with 
        |'+'->loop (indice+1) ligne.[indice+1]                (*Nous avons fait en fonction du format de l'énoncé*)
        |'-'->loop (indice+1) ligne.[indice+1]
        |_-> failwith "Un mur ne peut etre que + ou -" in
  loop 0 ligne.[0]

(* Vérifie que les pièces sont sous le bon format *)
let lire_ligne_piece ligne dim =
  let longueur = String.length ligne in
  if snd dim != longueur then failwith "La ligne n'est pas a la bonne longueur"
  else
  let rec loop indice car =
    if indice < longueur - 1 then
      match car with 
        |' '->loop (indice+1) ligne.[indice+1]                (*Ici aussi nous avons fait en fonction du format de l'énoncé*)
        |'S'->loop (indice+1) ligne.[indice+1]
        |'E'->loop (indice+1) ligne.[indice+1]
        |'|'->loop (indice+1) ligne.[indice+1]
        |_-> failwith "Le format n'est pas respecte" in
  loop 0 ligne.[0]

  (* Vérifie qu'un fichier est sous le bon format *)
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

    (* Créer une ligne de notre grille finale *)
    let create_grid_line l1 l2 l3 dim_grid =                      (*l1, l2 et l3 représentent respectivement un trio de lignes de charactères du fichier, représentants en réalité une ligne de pièces*)
      let res = Array.init (snd dim_grid) (fun _-> {sortie= false; entree = false; mur_h = false; mur_b=false; mur_d= false; mur_g=false}) in
          for i = 0 to (snd dim_grid) - 1 do                      (*On initialise une grille de pièces avec false partout*)
            if l2.[2*i] = '|' then res.(i).mur_g <- true;         (*Puis on met true aux murs, toits, sols selon les charactères*)
            if l1.[2*i+1] = '-' then res.(i).mur_h <- true;
            if l3.[2*i+1] = '-' then res.(i).mur_b <- true;
            (match l2.[2*i+1] with
            | 'E' -> res.(i).entree <- true                       (*On complète l'entrée et la sortie*)
            | 'S' -> res.(i).sortie <- true
            | _ -> ());
            if l2.[2*i+2] = '|' then res.(i).mur_d <- true;
          done;
      res     
  
  (* Converti le labyrinthe d'un fichier selon notre structure de données *)
  let load fichier =

    check_format(fichier);
    let ouvert = open_in fichier in
    let dim = dim fichier in
    let dim_grid = ((fst dim-1)/2, (snd dim -1)/2) in
    let res = Array.init (fst dim_grid) (fun _ -> [||]) in

    let l1 = input_line ouvert in
    let rec loop l1 ind = 
      try
        begin
        let l2 = input_line ouvert in
        let l3 = input_line ouvert in

        res.(ind) <- create_grid_line l1 l2 l3 dim_grid;          (*On a plus qu'à appeler create_grid_line sur chaque ligne de pièces pour remplir la grille*)
        loop l3 (ind + 1)
        end
      with End_of_file ->
        close_in ouvert in
    loop l1 0;
    res

  (* Affiche le labyrinthe d'un fichier *)
  let print grille =
  let lignes = Array.length grille in
  let colones = Array.length grille.(0) in
  for i = 0 to lignes - 1 do
    for j = 0 to colones - 1 do
      Printf.printf "+";
      if grille.(i).(j).mur_h then Printf.printf "-" else Printf.printf " ";    (*Ici on suit le format de l'énoncé aussi*)
    done;
    Printf.printf "+\n";
    for j = 0 to colones - 1 do
      if grille.(i).(j).mur_g then Printf.printf "|" else Printf.printf " ";
      if grille.(i).(j).entree then Printf.printf "E"
      else if grille.(i).(j).sortie then Printf.printf "S"
      else Printf.printf " ";
    done;
    Printf.printf "|\n";
  done;
  for j = 0 to colones - 1 do     (*Dernière ligne de murs*)
    Printf.printf "+-"
  done;
  Printf.printf "+\n";
