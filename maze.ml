(*Affiche dans la console ce que contient un fichier ouvert en lecture*)
let dump_file f =
    try
        while true do
        let c = input_line f in
        print_endline c
        done
    with End_of_file -> ()

let () =
    if Array.length Sys.argv <= 1 then
        print_endline "projet-ocaml/maze.ml"
    else
        let commande = Sys.argv.(1) in
        match commande with
        | "print" -> (
            let fichier = Sys.argv.(2) in
            let g = Grid.load fichier in
            Grid.print g
          )
        | "print2" -> 
            (try 
                let fichier = Sys.argv.(2) in 
                let ouvert = open_in fichier in
                dump_file ouvert;
                close_in ouvert
            with Invalid_argument _ -> failwith "fichier manquant")
        | "random" -> (
            let n = Sys.argv.(2) in
            let m = Sys.argv.(3) in
            let filename = Sys.argv.(4) in
            failwith "Pas encore implémenté"
            (*Generation.random n m filename;
            Printf.printf "Labyrinthe généré dans le fichier : %s" filename*)
        )
        | "--help" -> ()
        | "solve" -> ()
        | _ -> failwith "Commande manquante"