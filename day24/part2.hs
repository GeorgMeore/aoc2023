module Main where

import Data.Ratio
import Debug.Trace

--import TestInput
import Input

popeq :: [[Rational]] -> ([Rational], [[Rational]])
popeq sle =
  let iter left [] = error "all coefficients are zero"
      iter left (e:es)
        | head e /= 0 = (e, left ++ es)
        | otherwise = iter (e:left) es
  in iter [] sle

gauss :: [[Rational]] -> [[Rational]]
gauss sle
  | length sle == 0 || length (head sle) == 1 = sle
  | otherwise =
    let (first, rest) = popeq sle
        coeff = [head l / head first | l <- rest]
        sle'  = [[b - m*a | (a, b) <- zip first row] | (m, row) <- zip coeff rest]
    in first:(gauss (map tail sle'))

solve :: [[Rational]] -> [Rational]
solve sle =
  let calc [[x, v]] = [v/x, -1]
      calc (c:cs) =
        let vals = calc cs
            new  = (sum [-x*y | (x, y) <- zip (tail c) vals]) / (head c)
        in new:vals
  in calc (gauss sle)

calcpos :: [Hailstone] -> Rational
calcpos hailstones =
  let (((p1x, p1y, p1z), (v1x, v1y, v1z)):
       ((p2x, p2y, p2z), (v2x, v2y, v2z)):
       ((p3x, p3y, p3z), (v3x, v3y, v3z)):
       ((p4x, p4y, p4z), (v4x, v4y, v4z)):_) = hailstones
      equations = [
       -- these are derived from pi * vi*ti = ps + vs*ti
       --psx         psy            psz          vsx           vsy           vsz          1
       [(v1y - v2y), -(v1x - v2x),  0          , -(p1y - p2y),  (p1x - p2x), 0          , p1x*v1y - p1y*v1x - p2x*v2y + p2y*v2x],
       [0          ,  (v1z - v2z), -(v1y - v2y),  0          , -(p1z - p2z), (p1y - p2y), p1y*v1z - p1z*v1y - p2y*v2z + p2z*v2y],
       [(v2y - v3y), -(v2x - v3x),  0          , -(p2y - p3y),  (p2x - p3x), 0          , p2x*v2y - p2y*v2x - p3x*v3y + p3y*v3x],
       [0          ,  (v2z - v3z), -(v2y - v3y),  0          , -(p2z - p3z), (p2y - p3y), p2y*v2z - p2z*v2y - p3y*v3z + p3z*v3y],
       [(v3y - v4y), -(v3x - v4x),  0          , -(p3y - p4y),  (p3x - p4x), 0          , p3x*v3y - p3y*v3x - p4x*v4y + p4y*v4x],
       [0          ,  (v3z - v4z), -(v3y - v4y),  0          , -(p3z - p4z), (p3y - p4y), p3y*v3z - p3z*v3y - p4y*v4z + p4z*v4y]]
  in sum $ take 3 $ solve equations

main :: IO()
main = print $ calcpos hailstones
