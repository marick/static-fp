module TypeClass.List exposing (..)

flap : List (a -> b) -> a -> List b
flap funs a =
  let 
    applyOne f = f a
  in
    List.map applyOne funs


secondLevelMap : (a -> b) -> List (List a) -> List (List b)
secondLevelMap f xs =
  (List.map >> List.map) f xs


