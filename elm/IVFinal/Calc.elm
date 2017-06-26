module IVFinal.Calc exposing (..)


import IVFinal.Measures as Measure

import Tagged exposing (Tagged(..))

justMinutes : Measure.Hours -> Measure.Minutes -> Measure.Minutes
justMinutes (Tagged hourPart) (Tagged minutePart) =
  Measure.minutes <| 60 * hourPart + minutePart

litersOverTime : Measure.LitersPerMinute -> Measure.Minutes -> Measure.Liters
litersOverTime (Tagged lpm) (Tagged minutes) =
  lpm * (toFloat minutes) |> Measure.liters



containerVolume : Measure.Liters
containerVolume = Measure.liters 20.0

startingFluid : Measure.Liters
startingFluid = Measure.liters 19.0

minusMinus : Tagged a Float -> Tagged a Float -> Tagged a Float -> Tagged a Float
minusMinus (Tagged x) (Tagged y) (Tagged z) =
  Tagged (x - y - z)

findLevel
    : Measure.DropsPerSecond
    -> Measure.Minutes
    -> Measure.Liters
findLevel dropsPerSecond minutes =
  let 
    litersPerMinute = Measure.flowRate dropsPerSecond
    litersDrained = litersOverTime litersPerMinute minutes
  in
    minusMinus containerVolume startingFluid litersDrained

    
