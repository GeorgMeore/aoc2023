module Main where

-- import InputTest
import Input

import Data.List
import Data.Char
import Debug.Trace

data Direction = R | L | U | D
  deriving Show

type Action = (Direction, Int)
type Plan   = [Action]

data Segment = Col (Int, Int, Int) | Row (Int, Int, Int)
  deriving (Show, Eq)

instance Ord Segment where
  Col (i1, j1, _) <= Col (i2, j2, _) =
    j1 < j2 || j1 == j2 && i1 <= i2
  Row (i1, j1, _) <= Row (i2, j2, _) =
    i1 < i2 || i1 == i2 && j1 <= j2

type Limits  = (Int, Int)
type Map     = ((Limits, [Segment]), (Limits, [Segment]))

plan2map :: Plan -> Map
plan2map plan =
  let conv (i, mini, maxi) rows (j, minj, maxj) cols actions =
        case actions of
          [] ->
            (((mini, maxi), sort rows), ((minj, maxj), sort cols))
          (R, n):rest ->
            conv (i, mini, maxi)
                 (Row (i, j, n+1):rows)
                 (j+n, minj, max maxj (j+n))
                 cols
                 rest
          (L, n):rest ->
            conv (i, mini, maxi)
                 (Row (i, j-n, n+1):rows)
                 (j-n, min minj (j-n), maxj)
                 cols
                 rest
          (D, n):rest ->
            conv (i+n, mini, max maxi (i+n))
                 rows
                 (j, minj, maxj)
                 (Col (i, j, n+1):cols)
                 rest
          (U, n):rest ->
            conv (i-n, min mini (i-n), maxi)
                 rows
                 (j, minj, maxj)
                 (Col (i-n, j, n+1):cols)
                 rest
  in conv (0, maxBound, minBound) [] (0, maxBound, minBound) [] plan

slice :: Map -> Int -> ([Segment], [Segment])
slice m i =
  let ((_, rows), (_, cols)) = m in
    (filter (\(Row (i', _, _)) -> i' == i) rows ,
     filter (\(Col (i', _, l)) -> i' <= i && i'+l > i) cols)

slicearea :: ([Segment], [Segment]) -> Int
slicearea (rows, cols) =
  let integrate start rows cols cross acc =
        case (rows, cols) of
          ([], []) -> acc
          (Row (_, j1, _):rows', Col (_, j2, _):cols') | j2 < j1 ->
            if mod cross 2 == 1
              then integrate (j2+1) rows cols' (cross+1) (acc+j2-start+1)
              else integrate (j2+1) rows cols' (cross+1) (acc+1)
          ([], Col (_, j2, _):cols') ->
            if mod cross 2 == 1
              then integrate (j2+1) rows cols' (cross+1) (acc+j2-start+1)
              else integrate (j2+1) rows cols' (cross+1) (acc+1)
          (Row (i1, j1, l1):rows', Col (i2, _, _):Col (i3, _, _):cols') ->
            if signum (i2-i1) == signum (i3-i1)
            then
              if mod cross 2 == 1                                              --        # #
                then integrate (j1+l1) rows' cols' cross (acc+l1+j1-start)     -- ### or ###
                else integrate (j1+l1) rows' cols' cross (acc+l1)              -- # #
            else
              if mod cross 2 == 1                                              --   #    #
                then integrate (j1+l1) rows' cols' (cross+1) (acc+l1+j1-start) -- ### or ###
                else integrate (j1+l1) rows' cols' (cross+1) (acc+l1)          -- #        #
  in integrate 0 rows cols 0 0

rangearea :: Map -> Int -> Int -> Int
rangearea m i1 i2 =
  let s1 = slice m i1
      s2 = slice m i2
      w  = div (i2 - i1 + 1) 2
  in
    if s1 == s2 then
      (i2-i1+1) * slicearea s1
    else
      rangearea m i1 (i1+w-1) + rangearea m (i1+w) i2

calcarea :: Map -> Int
calcarea m =
  let (((imin, imax), _), _) = m in
    rangearea m imin imax

hex2dec :: Char -> Int
hex2dec c
  | c >= '0' && c <= '9' = ord c - ord '0'
  | c >= 'a' && c <= 'f' = ord c - ord 'a' + 10
  | otherwise            = error "Invalid hex digit"

string2hex :: String -> Int
string2hex digits =
  let convert "" acc     = acc
      convert (d:ds) acc = convert ds (acc*16 + hex2dec d)
  in convert digits 0

fixaction :: (Char, Int, String) -> Action
fixaction a =
  let (_, _, ['#', d1, d2, d3, d4, d5, d6]) = a in
    case d6 of
      '0' -> (R, string2hex [d1, d2, d3, d4, d5])
      '1' -> (D, string2hex [d1, d2, d3, d4, d5])
      '2' -> (L, string2hex [d1, d2, d3, d4, d5])
      '3' -> (U, string2hex [d1, d2, d3, d4, d5])
      _   -> error "Invalid direction"

main :: IO ()
main = print $ calcarea $ plan2map (map fixaction plan)
