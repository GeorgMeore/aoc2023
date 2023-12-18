let hash (s : char list) : int =
  let rec loop s acc =
    match s with
    | []    -> acc
    | c::cs -> loop cs ((17 * ((Char.code c) + acc)) mod 256)
  in loop s 0

type command = Remove of char list | Add of char list * int

let parse (sequence : char list) : command =
  let rec iter label chars =
    match chars with
    | ['-']    -> Remove (List.rev label)
    | ['='; l] -> Add (List.rev label, Char.code l - Char.code '0')
    | c::cs    -> iter (c::label) cs
    | _ -> failwith "Malformed command"
  in iter [] sequence

type box = (char list * int) list

let rec add_lense (label : char list) (len : int) (box : box) : box =
  match box with
  | [] -> [(label, len)]
  | l::ls ->
    let (label', _) = l in
     if label = label'
       then (label, len)::ls
       else l::(add_lense label len ls)

let rec remove_lense (label : char list) (box : box) : box =
  match box with
  | [] -> []
  | l::ls ->
    let (label', range) = l in
      if label = label' then ls
      else l::(remove_lense label ls)

type state = box list

let rec apply (patch : box -> box) (n : int) (boxes : box list) =
  match boxes with
  | [] -> failwith "Index out of range"
  | b::bs ->
    if n = 0 then (patch b)::bs
    else b::(apply patch (n - 1) bs)

let execute (sequence : char list) (state : state) : state =
  match parse sequence with
  | Add (label, l) ->
    apply (add_lense label l) (hash label) state
  | Remove label ->
    apply (remove_lense label) (hash label) state

let rec execute_all (state : state) (sequences : char list list) : state =
  match sequences with
  | []    -> state
  | s::ss -> execute_all (execute s state) ss

let box_focusing_power (box : box) : int =
  List.mapi
    (fun i (_, len) -> (i + 1) * len)
    box |>
  List.fold_left (+) 0

let focusing_power (state : state) : int =
  List.mapi
    (fun i box -> (i + 1) * box_focusing_power box)
    state |>
  List.fold_left (+) 0

let initial_state : state =
  let rec build i =
    if i = 256 then []
    else []::(build (i + 1))
  in build 0

let () =
  execute_all initial_state Input.sequences |>
  focusing_power |>
  Printf.printf "%d\n"
