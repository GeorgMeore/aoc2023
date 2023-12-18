let hash s =
  let rec loop s acc =
    match s with
    | []    -> acc
    | c::cs -> loop cs ((17 * ((Char.code c) + acc)) mod 256)
  in
    loop s 0

let () =
  List.to_seq Input.sequences |>
  Seq.map hash |>
  Seq.fold_left (+) 0 |>
  Printf.printf "%d\n"
