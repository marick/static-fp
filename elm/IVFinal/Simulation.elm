module IVFinal.Simulation exposing
  ( run
  )

import IVFinal.Types exposing (Model, SimulationStage(..), HowFinished(..))
import IVFinal.Generic.Measures as Measure
import IVFinal.Scenario exposing (..)
import IVFinal.Apparatus.Droplet as Droplet
import IVFinal.Apparatus.BagFluid as BagFluid
import IVFinal.Simulation.Conversions as C 

run : Scenario
    -> Measure.DropsPerSecond -> Measure.Hours -> Measure.Minutes
    -> (Model -> Model)
run scenario dripRate inHours inMinutes model =
  let 
    minutes = C.toMinutes inHours inMinutes
    flowRate = C.toFlowRate dripRate scenario
    finalLevel = C.toFinalLevel flowRate minutes scenario
    containerPercent = Measure.proportion finalLevel scenario.containerVolume
  in
    { model | stage = WatchingAnimation flowRate }
      |> Droplet.speedsUp dripRate
      |> BagFluid.drains containerPercent minutes
            (\ model ->
               model 
                |> Droplet.slowsDown dripRate
                |> finishAnimation flowRate finalLevel)

finishAnimation : Measure.LitersPerMinute -> Measure.Liters -> Model -> Model     
finishAnimation flowRate finalLevel model =
  let
    howFinished = Successfully { finalLevel = finalLevel }
  in
    { model | stage = Finished flowRate howFinished }

