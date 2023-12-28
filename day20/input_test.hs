module InputTest where

config1 :: [(Char, String, [String])]
config1 =
  [
    (' ', "broadcaster", ["a", "b", "c"]),
    ('%', "a", ["b"]),
    ('%', "b", ["c"]),
    ('%', "c", ["inv"]),
    ('&', "inv", ["a"])
  ]

config2 :: [(Char, String, [String])]
config2 =
  [
    (' ', "broadcaster", ["a"]),
    ('%', "a", ["inv", "con"]),
    ('&', "inv", ["b"]),
    ('%', "b", ["con"]),
    ('&', "con", ["output"])
  ]
