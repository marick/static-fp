module SumTypes.Aliases exposing (..)

type Tagged tag value = Tagged value

type PercentTag = PercentTagUnused
type DripRateTag = DripRateTagUnused

type alias Percent = Tagged PercentTag Float  
type alias DripRate = Tagged DripRateTag Float  

map : (oldValue -> newValue) -> Tagged tag oldValue -> Tagged tag newValue
map f (Tagged value) = 
  Tagged <| f value

-----------

dripRate : Float -> DripRate
dripRate = Tagged
             
percent : Float -> Percent
percent = Tagged
             
doubleDripRate : DripRate -> DripRate
doubleDripRate rate =
  map ((*) 2) rate

    
