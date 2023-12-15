let rec reduce_sequence seq =
  match seq with
  | x::y::rest -> (y - x) :: (reduce_sequence (y::rest))
  | _          -> []

let first_element seq =
  match seq with
  | []    -> failwith "Empty list"
  | x::_ -> x

let rec all_zeroes seq =
  match seq with
  | []    -> true
  | 0::xs -> all_zeroes xs
  | _     -> false

let rec predict_prev seq =
  if all_zeroes seq
    then 0
    else (first_element seq) - (predict_prev (reduce_sequence seq))

let () =
  let nexts = List.map predict_prev Input.sequences in
  let nexts_sum = List.fold_left (+) 0 nexts in
  Printf.printf "%d\n" nexts_sum
