module SumTypes.PhantomTagging exposing (..)

ascendingChoose : Int -> Int -> (String, String) -> String
ascendingChoose x y tuple =
  case x < y of
    True -> Tuple.first tuple
    False -> Tuple.second tuple

-- First version of `Tagged`

type Tagged tag value =
  Tagged value

type DripRate = DripRate
type Percent = Percent

dripRate : Float -> Tagged DripRate Float
dripRate float = Tagged float

isDrip3 x = x == dripRate 3.0
                 
percent : Float -> Tagged Percent Float
percent float = Tagged float
             
map : (wrapped -> wrapped) -> Tagged tag wrapped -> Tagged tag wrapped
map f (Tagged wrapped) = 
  Tagged (f wrapped)

