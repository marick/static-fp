module SumTypes.DripRate exposing (..)

import SumTypes.Percent as Percent exposing (Percent(..))

type DripRate = DropsPerSecond Float

map : (Float -> Float) -> DripRate -> DripRate
map f (DropsPerSecond wrapped) =
  DropsPerSecond <| f wrapped
           
increase : Percent -> DripRate -> DripRate
increase percent rate =
  map (Percent.increase percent) rate
