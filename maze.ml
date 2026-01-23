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
            let nom = Sys.argv.(4) in
            Generation.random (int_of_string n) (int_of_string m) nom;
            Printf.printf "Labyrinthe aléatoire généré dans %s\n" nom;
        )
        | "--help" ->
            print_endline "~~~~~~~~~~~~~~~~~~HELP~~~~~~~~~~~~~~~~~~~";
            print_endline "Usage : ./maze.exe <commande> [arguments]";
            print_endline "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
            print_endline "Commandes à dispositions :";
            print_endline "  print <fichier>                  : Charge le fichier en mémoire (Grid.load) et l'affiche.";
            print_endline "  print2 <fichier>                 : Affiche directement le contenu brut d'un fichier.";
            print_endline "  random <lignes> <colonnes> <nom> : Génère un labyrinthe aléatoire de dimensions données et le sauvegarde.";
            print_endline "  solve                            : Résout le labyrinthe.";
            print_endline "  tests                            : Lance le fichier de tests";
            print_endline "  --help                           : Affiche ce message d'aide.";
            print_endline "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        | "solve" -> (
            if Array.length Sys.argv < 3 then
                failwith "fichier à résoudre manquant"
            else
                let fichier = Sys.argv.(2) in
                let g = Grid.load fichier in
                Solve.solve g
        )
        | "tests" -> (
            let chemins = ["./Composants/Tests_functions/tests_fonctions.exe"; "_build/default/Composants/Tests_fonctions/tests_fonctions.exe"] in
            let runner = 
                try Some (List.find (fun p -> Sys.file_exists p) chemins)
                with _ -> None
            in
            let cmd = 
                match runner with
                |Some p -> p
                |None -> "dune exec ./Composants/Tests_fonctions/tests_fonctions.exe" 
            in
            let code = Sys.command cmd in
            if code <> 0 then (prerr_endline "Tests failed"; exit code) else ()
        )
        | _ -> failwith "Commande manquante"