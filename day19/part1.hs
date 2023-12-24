module Main where

--import InputTest
import Input

findworkflow :: [Workflow] -> String -> Workflow
findworkflow (w@(name', _):ws) name
  | name' == name = w
  | otherwise = findworkflow ws name

check :: Int -> Char -> Int -> Bool
check x '>' y = x > y
check x '<' y = x < y

tryrules :: Workflow -> Rating -> String
tryrules workflow rating =
  let (_, rules)    = workflow
      (x, m, a, s)  = rating
      tryloop rules =
        case rules of
          [Final next] -> next
          (Cond ('x', op, lim, next):_) | check x op lim -> next
          (Cond ('m', op, lim, next):_) | check m op lim -> next
          (Cond ('a', op, lim, next):_) | check a op lim -> next
          (Cond ('s', op, lim, next):_) | check s op lim -> next
          (r:rs) -> tryloop rs
  in tryloop rules

accept :: [Workflow] -> Rating -> Bool
accept workflows rating =
 let loop "A"  = True
     loop "R"  = False
     loop curr = loop (tryrules (findworkflow workflows curr) rating)
 in loop "in"

total :: [Workflow] -> [Rating] -> Int
total workflows ratings =
  sum [x+m+a+s | r@(x, m, a, s) <- ratings, accept workflows r]

main :: IO ()
main = print $ total workflows ratings
