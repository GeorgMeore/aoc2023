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

let maze_loop_points maze =
  let start = find_starting_position maze in
  let rec traverse curr prev points =
    let next = get_next_position maze curr prev in
      if next = start
        then points
        else traverse next curr (next::points)
  in
    traverse start start [start]

let rec append l1 l2 =
  match (l1, l2) with
  | ([], _)    -> l2
  | (x::xs, _) -> x::(append xs l2)

let split l pred =
  let rec iter l left right =
    match l with
    | [] -> (left, right)
    | x::xs ->
      if (pred x)
        then iter xs (x::left) right
        else iter xs left (x::right)
  in
    iter l [] []

let rec qsort gt l =
  match l with
  | [] | [_] -> l
  | x::xs ->
    let (left, right) = split xs (gt x) in
      append (append (qsort gt left) [x]) (qsort gt right)

let qsort_points =
  qsort (fun (i1, j1) (i2, j2) -> j1 > j2 || (j1 = j2 && i1 > i2))

let remove_pipes maze points =
  let (_, rest) = split points (fun (x, y) -> maze.(x).[y] = '|') in
    rest

let rec split_in_columns points =
  match points with
  | [] | [_] -> [points]
  | (i, j)::rest ->
    match split_in_columns rest with
    | ((k, l)::rest)::cols ->
      if j = l
        then ((i, j)::(k, l)::rest)::cols
        else [(i, j)]::((k, l)::rest)::cols
    | _ -> failwith "Impossible"

let rec map f l =
  match l with
  | []    -> []
  | x::xs -> (f x)::(map f xs)

let rec contract_column maze points =
  let rec contract points inside =
    match points with
    | (x, y)::rest when maze.(x).[y] = '-' ->
      (x, y)::(contract rest (not inside))
    | (x1, y1)::(x2, y2)::rest -> (
      match (maze.(x1).[y1], maze.(x2).[y2]) with
      | ('F', 'L') | ('S', 'L') | ('7', 'J') ->
        if inside
          then (x1, y1)::(x2, y2)::(contract rest inside)
          else contract rest inside
      | ('F', 'J') | ('S', 'J') | ('7', 'L') ->
        if inside
          then (x1, y1)::(contract rest (not inside))
          else (x2, y2)::(contract rest (not inside))
      | _ -> failwith "Impossible"
    )
    | _ -> []
  in
    contract points false

let rec column_area points =
  match points with
  | [] -> 0
  | (x1, y1)::(x2, y2)::rest ->
    (x2 - x1 - 1) + (column_area rest)
  | _ -> failwith "Impossible"

let rec sum l =
  match l with
  | [] -> 0
  | x::xs -> x + (sum xs)

let maze_loop_area maze =
  maze_loop_points maze |>
  remove_pipes maze |>
  qsort_points |>
  split_in_columns |>
  map (contract_column maze) |>
  map column_area |>
  sum

let () =
  Printf.printf "%d\n" (maze_loop_area Input.maze)
