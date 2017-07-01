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

type alias ModelTransform = Model -> Model 


moveToWatchingStage : Measure.LitersPerMinute -> ModelTransform
moveToWatchingStage flowRate model = 
  { model | stage = WatchingAnimation flowRate }

moveToFinishedStage : Measure.LitersPerMinute -> HowFinished
                    -> ModelTransform
moveToFinishedStage flowRate howFinished model =
  { model | stage = Finished flowRate howFinished }

type alias CoreInfo =
  { minutes : Measure.Minutes           -- From hours and minutes
  , flowRate : Measure.LitersPerMinute  -- Liters are more convenient than mils
  , containerVolume : Measure.Liters    -- from scenario
  , startingFluid : Measure.Liters
  }

toCoreInfo : Scenario -> FinishedForm -> CoreInfo
toCoreInfo scenario form =
  { minutes = C.toMinutes form.hours form.minutes
  , flowRate = C.toFlowRate form.dripRate scenario
  , containerVolume = scenario.containerVolume
  , startingFluid = scenario.startingFluid
  }
  
run : Scenario -> FinishedForm 
    -> (Model -> Model)
run scenario form model =
  let
    core = toCoreInfo scenario form
    finalLevel = C.toFinalLevel core.flowRate core.minutes scenario
    containerPercent = Measure.proportion finalLevel scenario.containerVolume
  in
    case Measure.isPositive finalLevel of
      True -> 
        { model | stage = WatchingAnimation core.flowRate }
          |> Droplet.speedsUp form.dripRate
          |> BagFluid.drains containerPercent core.minutes
             (\ model ->
               model 
                |> Droplet.slowsDown form.dripRate
                |> finishedWithFluidLeft core.flowRate finalLevel)
      False ->
        model

               
finishedWithFluidLeft : Measure.LitersPerMinute -> Measure.Liters
                      -> Model -> Model     
finishedWithFluidLeft flowRate finalLevel model =
  let
    howFinished = FluidLeft { finalLevel = finalLevel }
  in
    { model | stage = Finished flowRate howFinished }

