module TypeAnnotations.Errors exposing (..)

f1 : number -> number
f1 x =
  x / 3

f2 : List a -> List b -> List b
f2 one two =
  one ++ two

f3 : List a -> Int -> List a
f3 list = List.reverse list

f4: List a -> List a
f4 list = List.reverse

f5: List a -> a -> b -> List b
f5 = flip List.map    

-- Should find more of these. Feel free to make suggestions at
-- the exercise's wiki page.
