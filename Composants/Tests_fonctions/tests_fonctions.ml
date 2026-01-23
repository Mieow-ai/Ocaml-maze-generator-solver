

let fail message = prerr_endline ("[FAILED] " ^ message)
let pass message = prerr_endline("[OK] " ^ message)

let verifie_ok nom f =
  try let () = f () in pass nom
  with e -> fail (nom ^ "exception levée :" ^ Printexc.to_string e)

let verifie_pas_ok nom f =
  try let () = f () in fail (nom ^ "n'a pas levé d'exception")
  with _ -> pass nom

let () =
  verifie_ok "check_format_ok" (fun () -> Grid.check_format "test/maze_4x8.laby");
  let mauvais_cas = "test/pasbon.laby" in
  let oc = open_out mauvais_cas in
  output_string oc "++++++\nXXXXXXX\n"; close_out oc;
  verifie_pas_ok "check_format_pas_ok" (fun () -> Grid.check_format mauvais_cas);
  Sys.remove mauvais_cas;

  verifie_ok "lire_ligne_murs_ok" (fun () -> Grid.lire_ligne_murs "+-+-+" (0, 5));
  verifie_pas_ok "lire_ligne_murs_pas_ok" (fun () -> Grid.lire_ligne_murs "+-x-+" (0, 5));

  verifie_ok "lire_ligne_piece_ok" (fun () -> Grid.lire_ligne_piece "| E |" (0, 5));
  verifie_pas_ok "lire_ligne_piece_pas_ok" (fun () -> Grid.lire_ligne_piece "| x |" (0, 5));

  let g = Grid.load "test/maze_3x2.laby" in
  let r = Array.length g in
  let c = Array.length g.(0) in
  if r <> 3 || c <> 2 then fail (Printf.sprintf "load dimensions pas bonnes %d x %d" r c) else pass "load dimensions ok";
  print_endline "Tous les tests sont passés !";
  Printf.printf "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n";
  
