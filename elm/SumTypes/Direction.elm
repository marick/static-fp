module SumTypes.Direction exposing (..)

type Direction = Up | Down | Left | Right


flip : Direction -> Direction
flip direction =
  case direction of
    Up -> Down
    Down -> Up
    Left -> Right
    Right -> Left

type Wrapper a = Wrapper a

unwrap : Wrapper a -> a
unwrap (Wrapper a) = a          
  
wrapBoth : Wrapper Int -> Wrapper Int -> Wrapper (Int, Int)
wrapBoth (Wrapper first) (Wrapper second) =
  Wrapper (first, second)
