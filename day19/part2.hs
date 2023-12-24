module Main where

--import InputTest
import Input

type Range = (Int, Int)
type Combination = (Range, Range, Range, Range)

rangesize :: Range -> Int
rangesize (x, y) = (y - x) + 1

combsize :: Combination -> Int
combsize (r1, r2, r3, r4) =
  rangesize r1 * rangesize r2 * rangesize r3 * rangesize r4

find :: [Workflow] -> String -> Workflow
find (w@(name', _):ws) name
  | name' == name = w
  | otherwise = find ws name

rangeapply :: Range -> Char -> Int -> Maybe Range
rangeapply (i, j) '>' n =
  if j <= n then Nothing else Just (n+1, j)
rangeapply (i, j) '<' n =
  if i >= n then Nothing else Just (i, n-1)

rangesplit :: Range -> Char -> Int -> [Range]
rangesplit (i, j) '>' n
  | i >= n = [(i, j)]
  | j <= n = []
  | otherwise = [(n+1, j), (i, n)]
rangesplit (i, j) '<' n
  | j < n  = [(i, j)]
  | i >= n = []
  | otherwise = [(i, n-1), (n, j)]

combsplit :: Rule -> Combination -> [Combination]
combsplit rule (x, m, a, s) =
  case rule of
    Cond ('x', op, n, next) ->
      [(x', m, a, s) | x' <- rangesplit x op n]
    Cond ('m', op, n, next) ->
      [(x, m', a, s) | m' <- rangesplit m op n]
    Cond ('a', op, n, next) ->
      [(x, m, a', s) | a' <- rangesplit a op n]
    Cond ('s', op, n, next) ->
      [(x, m, a, s') | s' <- rangesplit s op n]

count :: [Workflow] -> String -> Combination -> Int
count workflows "A"  comb = combsize comb
count workflows "R"  comb = 0
count workflows curr comb =
  let (_, rules) = find workflows curr
      tryloop comb (Final next:rest) =
        count workflows next comb
      tryloop comb (first@(Cond (_, _, _, next)):rest) =
        case combsplit first comb of
          []       -> 0
          [c1, c2] -> tryloop c2 rest +
                      count workflows next c1
          [c1]     -> count workflows next c1
  in tryloop comb rules

total :: [Workflow] -> Int
total workflows =
  count workflows "in" ((1, 4000), (1, 4000), (1, 4000), (1, 4000))

main :: IO ()
main = print $ total workflows
