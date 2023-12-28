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
            let sources = [(n, Low) | (n, _, c) <- modules, name `elem` c]
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

process :: [Module] -> [Signal] -> ([Module], [[Signal]])
process modules signals =
  let loop modules [] emitted =
        (modules, emitted)
      loop modules (s:ss) emitted =
        let (modules', signals') = dispatch modules s
        in loop modules' (ss++signals') (emitted++[signals'])
  in loop modules signals []

traceemits :: String -> [Module] -> [[[Signal]]]
traceemits target modules =
  let starter = [("button", "broadcaster", Low)]
      loop states modules =
        let (modules', emitted) = process modules starter
            emitted' = [[s | s@(_, to, _) <- ss, to == target] | ss <- emitted]
        in if modules' `elem` states
             then []
             else emitted':loop (modules':states) modules'
  in loop [] modules

printlist :: Show a => [a] -> IO()
printlist = foldr ((>>) . print) (return ())

-- By analyzing the input I figured out that the overall schema looks like that:
--
--                 rx
--                  ^
--                  |
--             conjunction
--             ^  ^   ^  ^
--     .-------'.-'   '-.'-------.
--     |        |       |        |
--   group1   group2  group3   group4
--     ^        ^        ^       ^
--     '--------'--------'-------'
--                  |
--             broadcaster
--
-- Each group always outputted Low signals to the conjunction,
-- except during the button press that reset the group to the initial state.
-- I.e. on the last step of the group state loop exactly one High signal was produced.
--
-- So I just needed to figure out the step number which took each group to its last state.
-- LCM would give the right answer, but the periods were all relatively prime, so I just multiplied them.
main :: IO ()
main = print $ product (map (length . traceemits "rm" . translate . (++rest))
                            [groupdh, groupbb, groupqd, groupdp])
