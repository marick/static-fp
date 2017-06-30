module IVFinal.Simulation exposing
  ( run
  )

import IVFinal.Types exposing (Model, FinishedForm)
import IVFinal.Simulation.Types exposing (Stage)
import IVFinal.Generic.Measures as Measure
import IVFinal.Scenario exposing (..)
import IVFinal.Apparatus.Droplet as Droplet
import IVFinal.Apparatus.BagFluid as BagFluid
import IVFinal.Simulation.Conversions as C 
import IVFinal.Simulation.Types exposing (..)

run : Scenario -> FinishedForm 
    -> (Model -> Model)
run scenario form model =
  let 
    minutes = C.toMinutes form.hours form.minutes
    flowRate = C.toFlowRate form.dripRate scenario
    finalLevel = C.toFinalLevel flowRate minutes scenario
    containerPercent = Measure.proportion finalLevel scenario.containerVolume
  in
    case Measure.isPositive finalLevel of
      True -> 
        { model | stage = WatchingAnimation flowRate }
          |> Droplet.speedsUp form.dripRate
          |> BagFluid.drains containerPercent minutes
             (\ model ->
               model 
                |> Droplet.slowsDown form.dripRate
                |> finishedWithFluidLeft flowRate finalLevel)
      False ->
        model

               
finishedWithFluidLeft : Measure.LitersPerMinute -> Measure.Liters
                      -> Model -> Model     
finishedWithFluidLeft flowRate finalLevel model =
  let
    howFinished = FluidLeft { finalLevel = finalLevel }
  in
    { model | stage = Finished flowRate howFinished }

