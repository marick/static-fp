module IVFinal.Simulation.Conversions exposing (..)

import IVFinal.Generic.Measures as Measure
import Tagged exposing (Tagged(Tagged))

toMinutes : Measure.Hours -> Measure.Minutes -> Measure.Minutes
toMinutes (Tagged hourPart) (Tagged minutePart) =
  Measure.minutes <| 60 * hourPart + minutePart

toFinalLevel : Measure.LitersPerMinute -> Measure.Minutes
             -> { r | startingVolume : Measure.Liters }
             -> Measure.Liters
toFinalLevel litersPerMinute minutes {startingVolume} =
  let 
    litersDrained = litersOverTime litersPerMinute minutes
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

litersOverTime : Measure.LitersPerMinute -> Measure.Minutes -> Measure.Liters
litersOverTime (Tagged lpm) (Tagged minutes) =
  lpm * (toFloat minutes) |> Measure.liters

bagRanOutAfter : Measure.Minutes -> Measure.Liters -> Measure.Liters
                   -> Measure.Minutes
bagRanOutAfter (Tagged totalMinutes) (Tagged excess) (Tagged containerVolume) =
  let
    totalFluid = excess + containerVolume
    containerDrainProportion = containerVolume / totalFluid
    timeDraining = round (containerDrainProportion * (toFloat totalMinutes))
  in
    Measure.minutes (totalMinutes - timeDraining)
  
                     
