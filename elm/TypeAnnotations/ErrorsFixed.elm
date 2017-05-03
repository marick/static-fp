module TypeAnnotations.ErrorsFixed exposing (..)

f1 : Float -> Float
f1 x =
  x / 3

f2 : List a -> List a -> List a
f2 one two =
  one ++ two

f3 : List a -> List a
f3 list = List.reverse list

f4: List a -> List a
f4 list = List.reverse list

-- or

f4a: List a -> List a
f4a = List.reverse


f5: List a -> (a -> b) -> List b
f5 = flip List.map    
