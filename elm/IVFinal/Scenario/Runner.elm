module IVFinal.Scenario.Runner exposing
  ( run
  )

import IVFinal.Types exposing (Model)
import IVFinal.Util.Measures as Measure
import Tagged exposing (Tagged(..))
import IVFinal.Scenario exposing (..)
import IVFinal.Apparatus.Droplet as Droplet
import IVFinal.Apparatus.BagFluid as BagFluid

run : Scenario
    -> Measure.DropsPerSecond -> Measure.Hours -> Measure.Minutes
    -> (Model -> Model)
run scenario dps hours minutes model =
  let 
    justMinutes = toMinutes hours minutes
    finalLevel = findLevel dps (Debug.log "jm" justMinutes) scenario
    reductionTo = Measure.proportion (Debug.log "fl" finalLevel) scenario.containerVolume
  in
    model 
      |> Droplet.speedsUp dps
      |> BagFluid.drains (Debug.log "rt" reductionTo) justMinutes
            (\ model ->
               Droplet.slowsDown dps model)

-- Private

toMinutes : Measure.Hours -> Measure.Minutes -> Measure.Minutes
toMinutes (Tagged hourPart) (Tagged minutePart) =
  Measure.minutes <| 60 * hourPart + minutePart

findLevel : Measure.DropsPerSecond -> Measure.Minutes -> Scenario
          -> Measure.Liters
findLevel dropsPerSecond minutes scenario =
  let 
    litersPerMinute = flowRate dropsPerSecond scenario
    litersDrained = litersOverTime litersPerMinute minutes
  in
    Tagged.map2 (-) scenario.startingFluid litersDrained
    
    
flowRate : Measure.DropsPerSecond -> Scenario -> Measure.LitersPerMinute
flowRate (Tagged dropsPerSecond) {dropsPerMil} =
  let
    milsPerSecond = dropsPerSecond / (toFloat dropsPerMil)
    milsPerHour = milsPerSecond * 60.0
  in
    Measure.litersPerMinute (milsPerHour / 1000.0)

litersOverTime : Measure.LitersPerMinute -> Measure.Minutes -> Measure.Liters
litersOverTime (Tagged lpm) (Tagged minutes) =
  lpm * (toFloat minutes) |> Measure.liters

minusMinus : Tagged a Float -> Tagged a Float -> Tagged a Float -> Tagged a Float
minusMinus (Tagged x) (Tagged y) (Tagged z) =
  Tagged (x - y - z)

