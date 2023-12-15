let find_starting_position maze =
  let rec iter i =
    match String.index_opt maze.(i) 'S' with
    | Some j -> (i, j)
    | None   -> iter (i + 1)
  in iter 0

let get_adjacent_positions maze pos =
  let (i, j) = pos in
    match maze.(i).[j] with
    | '|'       -> ((i - 1, j), (i + 1, j))
    | '-'       -> ((i, j - 1), (i, j + 1))
    | 'L'       -> ((i - 1, j), (i, j + 1))
    | 'J'       -> ((i, j - 1), (i - 1, j))
    | '7'       -> ((i, j - 1), (i + 1, j))
    | 'F' | 'S' -> ((i + 1, j), (i, j + 1)) (* S type was derived ad-hoc manually *)
    | _         -> failwith "Not a pipe"

let get_next_position maze curr prev =
  let (fst, snd) = get_adjacent_positions maze curr in
    if fst <> prev then fst else snd

let maze_loop_length maze =
  let start = find_starting_position maze in
  let rec traverse curr prev length =
    let next = get_next_position maze curr prev in
      if next = start
        then length + 1
        else traverse next curr (length + 1)
  in
    traverse start start 0

let max_steps maze =
  let loop_length = maze_loop_length maze in
    loop_length / 2 + loop_length mod 2

let () =
  Printf.printf "%d\n" (max_steps Input.maze)
