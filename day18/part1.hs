module Main where

-- import InputTest
import Input

import Data.Array
import Data.List
import Debug.Trace

type Action = (Char, Int, String)
type Plan   = [Action]

planlimits :: Plan -> (Int, Int, Int, Int)
planlimits plan =
  let iter (i, mini, maxi) (j, minj, maxj) actions =
        case actions of
          [] -> (mini, maxi, minj, maxj)
          ('R', n, _):rest -> iter (i, mini, maxi) (j+n, minj, max maxj (j+n)) rest
          ('L', n, _):rest -> iter (i, mini, maxi) (j-n, min minj (j-n), maxj) rest
          ('D', n, _):rest -> iter (i+n, mini, max maxi (i+n)) (j, minj, maxj) rest
          ('U', n, _):rest -> iter (i-n, min mini (i-n), maxi) (j, minj, maxj) rest
  in iter (0, maxBound, minBound) (0, maxBound, minBound) plan

type Map = Array (Int, Int) Char

mkmap :: Int -> Int -> Char -> Map
mkmap rows cols v =
  array ((0,0), (rows-1, cols-1)) [(xy, v) | xy <- range ((0,0), (rows-1, cols-1))]

nrows :: Map -> Int
nrows m =
  let (_, (r', _)) = bounds m in (r' + 1)

ncols :: Map -> Int
ncols m =
  let (_, (_, c')) = bounds m in (c' + 1)

(!?) :: Map -> (Int, Int) -> Char
m !? i = if inRange (bounds m) i then m!i else ' '

plan2map :: Plan -> Map
plan2map plan =
  let (mini, maxi, minj, maxj) = planlimits plan
      height  = (maxi - mini) + 1
      width   = (maxj - minj) + 1
      starti  = -mini
      startj  = -minj
      coords  = mkmap height width ' '
      fill i j dir steps actions coords =
        case (dir, steps, actions) of
          (_, 0, []) ->
            coords
          (_, 0, (dir, steps, _):actions) ->
            fill i j dir steps actions coords
          ('R', _, _) -> fill i (j+1) dir (steps-1) actions (coords // [((i, j+1), '#')])
          ('L', _, _) -> fill i (j-1) dir (steps-1) actions (coords // [((i, j-1), '#')])
          ('D', _, _) -> fill (i+1) j dir (steps-1) actions (coords // [((i+1, j), '#')])
          ('U', _, _) -> fill (i-1) j dir (steps-1) actions (coords // [((i-1, j), '#')])
  in fill starti startj 'S' 0 plan coords

data Segtype = Ark Int | Wall Int deriving Show

countwhile :: (a -> Bool) -> [a] -> Int
countwhile pred l = length $ takeWhile pred l

--                # #      #    #
-- detect  ### or ### vs ### or ###
--         # #           #        #
segdetect :: Map -> Int -> Int -> Segtype
segdetect m i j =
  let js  = range ((i, j), (i, ncols m - 1))
      dug = (== '#') . (m!?)
      w   = countwhile dug js
  in if dug (i+1, j) && dug (i-1, j+w-1) ||
        dug (i-1, j) && dug (i+1, j+w-1)
       then Wall w
       else Ark w

calcarea :: Map -> Int
calcarea m =
  let iter i j count acc
        | i >= nrows m = acc
        | j >= ncols m = iter (i+1) 0 0 acc
        | otherwise =
          case m!?(i,j) of
            ' ' ->
              if mod count 2 == 1
                then iter i (j+1) count (acc+1)
                else iter i (j+1) count acc
            '#' ->
              case segdetect m i j of
                Ark w  -> iter i (j+w) count (acc+w)
                Wall w -> iter i (j+w) (count+1) (acc+w)
  in iter 0 0 0 0

printmap :: Map -> IO ()
printmap m =
  let iter i j | j >= ncols m = putChar '\n' >> iter (i+1) 0
               | i >= nrows m = return ()
               | otherwise = putChar (m!(i, j)) >> iter i (j+1)
  in iter 0 0

main :: IO ()
main = print $ calcarea $ plan2map plan
