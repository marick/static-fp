module IVFinal.Simulation.Conversions exposing (..)

{- Various conversions relevant to calculating simulation values.
These are really in a separate module so they can be tested.
-}

import IVFinal.Generic.Measures as Measure
import Tagged exposing (Tagged(Tagged))

toFinalLevel : Measure.LitersPerMinute -> Measure.Minutes
             -> { r | startingVolume : Measure.Liters }
             -> Measure.Liters
toFinalLevel litersPerMinute minutes {startingVolume} =
  let 
    litersDrained = Measure.litersOverTime litersPerMinute minutes
  in
    Tagged.map2 (-) startingVolume litersDrained
    
    
toFlowRate : Measure.DropsPerSecond
           -> { r | dropsPerMil : Int } 
           -> Measure.LitersPerMinute
toFlowRate (Tagged dropsPerSecond) {dropsPerMil} =
  let
    milsPerSecond = dropsPerSecond / (toFloat dropsPerMil)
    milsPerHour = milsPerSecond * 60.0
  in
    Measure.litersPerMinute (milsPerHour / 1000.0)

