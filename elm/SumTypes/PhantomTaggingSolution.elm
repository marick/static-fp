module SumTypes.PhantomTaggingSolution exposing (..)

-- The core trick:

type Tagged tag value = Tagged value

map : (oldValue -> newValue) -> Tagged tag oldValue -> Tagged tag newValue
map f (Tagged value) = 
  Tagged <| f value

map2 : (a -> b -> c) -> Tagged tag a -> Tagged tag b -> Tagged tag c
map2 f (Tagged one) (Tagged two) =
  Tagged <| f one two

untag : Tagged tag value -> value
untag (Tagged value) = value

retag : Tagged oldTag value -> Tagged newTag value
retag (Tagged x) =
  Tagged x


----- Uses  

type DripRate = DripRate_Unused
type Percent = Percent_Unused
type Minutes = Minutes_Unused

dripRate : Float -> Tagged DripRate Float
dripRate = Tagged 

percent : Float -> Tagged Percent Float
percent = Tagged

minutes : Float -> Tagged Minutes Float
minutes = Tagged


minutesUntilCheck : Tagged DripRate Float -> Tagged Minutes Float
minutesUntilCheck drips =
  let
    calculation perSecond = (2000 * 15) / (60 * perSecond)
  in
    map calculation drips |> retag
