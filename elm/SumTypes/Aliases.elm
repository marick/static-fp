module SumTypes.Aliases exposing (..)

type Tagged tag value = Tagged value

type PercentTag = PercentTag
type DripRateTag = DripRateTag

type alias Percent = Tagged PercentTag Float  
type alias DripRate = Tagged DripRateTag Float  

dripRate : Float -> DripRate
dripRate = Tagged
             
percent : Float -> Percent
percent = Tagged
             
doubleDripRate : DripRate -> DripRate
doubleDripRate rate =
  map ((*) 2) rate

map : (wrapped -> wrapped) -> Tagged tag wrapped -> Tagged tag wrapped
map f (Tagged wrapped) = 
  Tagged (f wrapped)

