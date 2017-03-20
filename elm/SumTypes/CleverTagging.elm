module SumTypes.CleverTagging exposing (..)

type Tagged tag value
  = Tagged value

type PercentTag = PercentTag
type DripRateTag = DripRateTag

type alias Percent = Tagged PercentTag Float  
type alias DripRate = Tagged DripRateTag Float  

dripRate : Float -> DripRate
dripRate = Tagged
             
percent : Float -> Percent
percent = Tagged
             
map : (wrapped -> wrapped) -> Tagged tag wrapped -> Tagged tag wrapped
map f (Tagged wrapped) = 
  Tagged (f wrapped)



ascendingChoose : Int -> Int -> (String, String) -> String
ascendingChoose x y tuple =
  case x < y of
    True -> Tuple.first tuple
    False -> Tuple.second tuple

    
