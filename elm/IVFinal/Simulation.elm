module IVFinal.Simulation exposing
  ( run
  )

import IVFinal.Types exposing (Model)
import IVFinal.Simulation.Types exposing (Stage)
import IVFinal.Generic.Measures as Measure
import IVFinal.Scenario exposing (..)
import IVFinal.Apparatus.Droplet as Droplet
import IVFinal.Apparatus.BagFluid as BagFluid
import IVFinal.Simulation.Conversions as C 
import IVFinal.Simulation.Types exposing (..)

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
                |> finishedWithFluidLeft flowRate finalLevel)

finishedWithFluidLeft : Measure.LitersPerMinute -> Measure.Liters
                      -> Model -> Model     
finishedWithFluidLeft flowRate finalLevel model =
  let
    howFinished = FluidLeft { finalLevel = finalLevel }
  in
    { model | stage = Finished flowRate howFinished }

