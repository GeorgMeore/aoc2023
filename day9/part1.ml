let rec reduce_sequence seq =
  match seq with
  | x::y::rest -> (y - x) :: (reduce_sequence (y::rest))
  | _          -> []

let rec last_element seq =
  match seq with
  | []    -> failwith "Empty list"
  | x::[] -> x
  | _::xs -> last_element xs

let rec all_zeroes seq =
  match seq with
  | []    -> true
  | 0::xs -> all_zeroes xs
  | _     -> false

let rec predict_next seq =
  if all_zeroes seq
    then 0
    else (last_element seq) + (predict_next (reduce_sequence seq))

let () =
  let nexts = List.map predict_next Input.sequences in
  let nexts_sum = List.fold_left (+) 0 nexts in
  Printf.printf "%d\n" nexts_sum
