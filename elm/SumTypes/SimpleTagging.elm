module SumTypes.SimpleTagging exposing (..)

import SumTypes.Percent as Percent exposing (Percent(..))

type DripRate = DropsPerSecond Float

increase1 : Percent -> DripRate -> DripRate
increase1 (Percent percent) (DropsPerSecond rate) =
  DropsPerSecond <| rate * (1.0 + percent) 

increase2 : Percent -> DripRate -> DripRate
increase2 percent (DropsPerSecond rate) =
  DropsPerSecond <| Percent.increase percent rate

