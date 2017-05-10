module SumTypes.SimpleTagging exposing (..)

import SumTypes.Percent as Percent exposing (Percent(..))

type DripRate = DropsPerSecond Float

-- This version knows about percentage calculations.
dripFaster1 : Percent -> DripRate -> DripRate
dripFaster1 (Percent percent) (DropsPerSecond rate) =
  DropsPerSecond <| rate * (1.0 + percent) 

-- This version isolates percentage calculations in the Percent module.
dripFaster2 : Percent -> DripRate -> DripRate
dripFaster2 percent (DropsPerSecond rate) =
  DropsPerSecond <| Percent.increase percent rate

