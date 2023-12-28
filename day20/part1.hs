module Main where

import InputTest
import Input

import Debug.Trace

data Type = High | Low
  deriving (Show, Eq)

type Signal = (String, String, Type)

data State = Flip Bool | Conj [(String, Type)] | Bcast
  deriving (Show, Eq)

type Module = (String, State, [String])

translate :: [(Char, String, [String])] -> [Module]
translate config =
  let convert dsc =
        case dsc of
          (' ', name, conn) -> (name, Bcast,      conn)
          ('%', name, conn) -> (name, Flip False, conn)
          ('&', name, conn) -> (name, Conj [],    conn)
      modules = map convert config
      link mod =
        case mod of
          (name, Conj [], conns) ->
            let sources = [(n, Low) | (n, _, c) <- modules, elem name c]
            in (name, Conj sources, conns)
          _ -> mod
      linked = map link modules
  in linked

handle :: Module -> Signal -> (Module, [Signal])
handle mod@(name, state, conns) sig@(from, to, sigtype) =
  let trans state sigtype =
        case (state, sigtype) of
          (Bcast,      _)   -> (state, [sigtype])
          (Flip _,    High) -> (state, [])
          (Flip False, Low) -> (Flip True, [High])
          (Flip True,  Low) -> (Flip False, [Low])
          (Conj vals,  _) ->
            let vals'   = [(n, if n == from then sigtype else t) | (n, t) <- vals]
                allhigh = and [t == High | (_, t) <- vals']
            in if allhigh
                 then (Conj vals', [Low])
                 else (Conj vals', [High])
      (state', sigtypes) = trans state sigtype
      mod' = (name, state', conns)
      emit = [(name, n, t) | t <- sigtypes, n <- conns]
  in (mod', emit)

dispatch :: [Module] -> Signal -> ([Module], [Signal])
dispatch [] signal = ([], [])
dispatch modules signal =
  let first@(name, _, _):rest = modules
      (from, to, _) = signal
  in if name == to
       then let (first', emitted) = handle first signal
            in (first':rest, emitted)
       else let (rest', emitted) = dispatch rest signal
            in (first:rest', emitted)

process :: [Module] -> [Signal] -> ([Module], Int, Int)
process modules signals =
  let loop modules [] nlow nhigh =
        (modules, nlow, nhigh)
      loop modules (s:ss) nlow nhigh =
        let (modules', signals') = dispatch modules s
            (_, _, sigtype)      = s
        in case sigtype of
             High -> loop modules' (ss++signals') nlow (nhigh+1)
             Low  -> loop modules' (ss++signals') (nlow+1) nhigh
  in loop modules signals 0 0

countpulses :: [Module] -> Int
countpulses modules =
  let starter = [("button", "broadcaster", Low)]
      loop i modules nlow nhigh
        | i >= 1000 = nlow * nhigh
        | otherwise =
          let (modules', nlow', nhigh') = process modules starter
          in loop (i+1) modules' (nlow+nlow') (nhigh+nhigh')
  in loop 0 modules 0 0

main :: IO ()
main = print $ countpulses (translate config)
