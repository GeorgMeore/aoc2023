module InputTest where

data Rule = Cond (Char, Char, Int, String) | Final String
type Workflow = (String, [Rule])
type Rating = (Int, Int, Int, Int)

workflows :: [Workflow]
workflows = [
  ("px",  [Cond ('a','<',2006,"qkq"),
           Cond ('m','>',2090,"A"),
           Final "rfg"]),
  ("pv",  [Cond ('a','>',1716,"R"),
           Final "A"]),
  ("lnx", [Cond ('m','>',1548,"A"),
           Final "A"]),
  ("rfg", [Cond ('s','<',537,"gd"),
           Cond ('x','>',2440,"R"),
           Final "A"]),
  ("qs",  [Cond ('s','>',3448,"A"),
           Final "lnx"]),
  ("qkq", [Cond ('x','<',1416,"A"),
           Final "crn"]),
  ("crn", [Cond ('x','>',2662,"A"),
           Final "R"]),
  ("in",  [Cond ('s','<',1351,"px"),
           Final "qqz"]),
  ("qqz", [Cond ('s','>',2770,"qs"),
           Cond ('m','<',1801,"hdj"),
           Final "R"]),
  ("gd",  [Cond ('a','>',3333,"R"),
           Final "R"]),
  ("hdj", [Cond ('m','>',838,"A"),
           Final "pv"])]

ratings :: [Rating]
ratings = [
  (787,  2655, 1222, 2876),
  (1679, 44,   2067, 496),
  (2036, 264,  79,   2244),
  (2461, 1339, 466,  291),
  (2127, 1623, 2188, 1013)]
