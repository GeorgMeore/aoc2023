module Main where

import Data.Ratio
import Debug.Trace

--import TestInput
import Input

intersect :: Hailstone -> Hailstone -> (Rational, Rational)
intersect h1 h2 =
  let ((x1, y1, z1), (dx1, dy1, dz1)) = h1
      ((x2, y2, z2), (dx2, dy2, dz2)) = h2
      k1 = dy1 / dx1
      b1 = y1 - k1*x1
      k2 = dy2 / dx2
      b2 = y2 - k2*x2
  in ((b2 - b1)/(k1 - k2), (k1*b2 - b1*k2)/(k1 - k2))

cross :: Hailstone -> Hailstone -> Bool
cross h1 h2 =
  let ((x1, y1, z1), v1@(dx1, dy1, dz1)) = h1
      ((x2, y2, z2), v2@(dx2, dy2, dz2)) = h2
  in dx1/dx2 /= dy1/dy2 &&
     let (xi, yi) = intersect h1 h2
     in llimit <= xi && xi <= ulimit &&
        llimit <= yi && yi <= ulimit &&
        signum (xi - x1) == signum dx1 &&
        signum (xi - x2) == signum dx2 &&
        signum (yi - y1) == signum dy1 &&
        signum (yi - y2) == signum dy2

count :: [Hailstone] -> Int
count hailstones =
  let iter [] acc = acc
      iter (h:hs) acc =
        iter hs (acc + length (filter (cross h) hs))
  in iter hailstones 0

main :: IO()
main = putStrLn $ show $ count hailstones
