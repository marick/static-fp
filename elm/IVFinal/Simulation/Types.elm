module IVFinal.Simulation.Types exposing (..)

import IVFinal.Generic.Measures as Measure

-- Just for clarity in sum type
type alias DrainRate = Measure.LitersPerMinute

type Stage
  = FormFilling 
  | WatchingAnimation DrainRate
  | Finished DrainRate HowFinished

type HowFinished
  = FluidLeft
    { finalLevel : Measure.Liters
    }



  
