let count_arrangements (syms, sizes) =
  let rec count syms broken sizes =
    match (syms, sizes) with
    | ([], [n]) when broken = n -> 1
    | ([], []) when broken = 0  -> 1
    | ('#'::syms', n::sizes') ->
      if (broken + 1) > n then 0
      else count syms' (broken + 1) sizes
    | ('.'::syms', _) when broken = 0 ->
      count syms' 0 sizes
    | ('.'::syms', n::sizes') when broken = n ->
      count syms' 0 sizes'
    | ('?'::syms', _) ->
      (count ('#'::syms') broken sizes) + (count ('.'::syms') broken sizes)
    | _ -> 0
  in
    count syms 0 sizes

let () =
  Input.records |>
  List.map count_arrangements |>
  List.fold_left (+) 0 |>
  Printf.printf "%d\n"
