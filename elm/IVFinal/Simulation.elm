module IVFinal.Simulation exposing
  ( run
  )

import IVFinal.Types exposing (Model, SimulationStage(..))
import IVFinal.Util.Measures as Measure
import Tagged exposing (Tagged(..))
import IVFinal.Scenario exposing (..)
import IVFinal.Apparatus.Droplet as Droplet
import IVFinal.Apparatus.BagFluid as BagFluid

run : Scenario
    -> Measure.DropsPerSecond -> Measure.Hours -> Measure.Minutes
    -> (Model -> Model)
run scenario dripRate inHours inMinutes model =
  let 
    minutes = toMinutes inHours inMinutes
    flowRate = toFlowRate dripRate scenario
    finalLevel = toFinalLevel flowRate minutes scenario
    containerPercent = Measure.proportion finalLevel scenario.containerVolume
  in
    { model | stage = WatchingAnimation flowRate }
      |> Droplet.speedsUp dripRate
      |> BagFluid.drains containerPercent minutes
            (\ model ->
               model 
                |> Droplet.slowsDown dripRate
                |> finishAnimation finalLevel)

finishAnimation : Measure.Liters -> Model -> Model              
finishAnimation finalLevel model =
  { model | stage = Finished finalLevel }

-- Private

toMinutes : Measure.Hours -> Measure.Minutes -> Measure.Minutes
toMinutes (Tagged hourPart) (Tagged minutePart) =
  Measure.minutes <| 60 * hourPart + minutePart

toFinalLevel : Measure.LitersPerMinute -> Measure.Minutes -> Scenario
             -> Measure.Liters
toFinalLevel litersPerMinute minutes scenario =
  let 
--    litersPerMinute = toFlowRate dropsPerSecond scenario
    litersDrained = litersOverTime litersPerMinute minutes
  in
    Tagged.map2 (-) scenario.startingFluid litersDrained
    
    
toFlowRate : Measure.DropsPerSecond -> Scenario -> Measure.LitersPerMinute
toFlowRate (Tagged dropsPerSecond) {dropsPerMil} =
  let
    milsPerSecond = dropsPerSecond / (toFloat dropsPerMil)
    milsPerHour = milsPerSecond * 60.0
  in
    Measure.litersPerMinute (milsPerHour / 1000.0)

litersOverTime : Measure.LitersPerMinute -> Measure.Minutes -> Measure.Liters
litersOverTime (Tagged lpm) (Tagged minutes) =
  lpm * (toFloat minutes) |> Measure.liters

