module TypeAnnotations.ErrorsFixed exposing (..)

-- See https://github.com/marick/static-fp/wiki/Type-annotations for commentary.

f1 : Float -> Float
f1 x =
  x / 3

----------    
    
f2 : List a -> List a -> List a
f2 one two =
  one ++ two

-- or, just for fun

f2a : List a -> List String -> List String
f2a nonstrings strings =
  List.map toString nonstrings ++ strings

----------    
    
f3 : List a -> List a
f3 list = List.reverse list

----------    
    
f4: List a -> List a
f4 list = List.reverse list

-- or

f4a: List a -> List a
f4a = List.reverse

----------    

f5: List a -> (a -> b) -> List b
f5 = flip List.map    
