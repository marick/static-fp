module IVFinal.Simulation exposing
  ( run
  )

import IVFinal.Types exposing (..)
import IVFinal.Simulation.Types exposing (Stage)
import IVFinal.Generic.Measures as Measure
import IVFinal.Scenario exposing (..)
import IVFinal.Apparatus.Droplet as Droplet
import IVFinal.Apparatus.BagFluid as BagFluid
import IVFinal.Apparatus.ChamberFluid as ChamberFluid
import IVFinal.Apparatus.HoseFluid as HoseFluid
import IVFinal.Simulation.Conversions as C 
import IVFinal.Simulation.Types exposing (..)

moveToWatchingStage : Measure.LitersPerMinute -> ModelTransform
moveToWatchingStage flowRate model = 
  { model | stage = WatchingAnimation flowRate }

moveToFinishedStage : Measure.LitersPerMinute -> HowFinished
                    -> ModelTransform
moveToFinishedStage flowRate howFinished model =
  { model | stage = Finished flowRate howFinished }

type alias CoreInfo =
  { minutes : Measure.Minutes           -- From hours and minutes
  , dripRate : Measure.DropsPerSecond   -- used for animation timings
  , flowRate : Measure.LitersPerMinute  -- Liters are more convenient than mils
  , containerVolume : Measure.Liters   
  , startingVolume : Measure.Liters
  , endingVolume : Measure.Liters
  }

toCoreInfo : Scenario -> FinishedForm -> CoreInfo
toCoreInfo scenario form =
  let 
    minutes = Measure.toMinutes form.hours form.minutes
    dripRate = form.dripRate
    flowRate = C.toFlowRate dripRate scenario
    containerVolume = scenario.containerVolume
    startingVolume = scenario.startingVolume
    endingVolume = C.toFinalLevel flowRate minutes scenario
  in
    { minutes = minutes
    , flowRate = flowRate
    , dripRate = dripRate
    , containerVolume = containerVolume
    , startingVolume = startingVolume
    , endingVolume = endingVolume
  }
  
run : Scenario -> FinishedForm -> ModelTransform
run scenario form =
  let
    core =
      toCoreInfo scenario form

    animations =
      case Measure.isStrictlyNegative core.endingVolume of
        True ->
          overDrain core
        False ->
          partlyDrain core
  in
    moveToWatchingStage core.flowRate
    >> animations


partlyDrain : CoreInfo -> ModelTransform
partlyDrain core = 
  let
    containerPercent = Measure.proportion core.endingVolume core.containerVolume
    howFinished = FluidLeft core.endingVolume

    beginTimeLapse =
      Droplet.entersTimeLapse core.dripRate
        (Continuation lower)

    lower = 
      BagFluid.lowers containerPercent core.minutes
         (Continuation backToDripping)
                  
    backToDripping = 
      Droplet.leavesTimeLapse core.dripRate
        >> moveToFinishedStage core.flowRate howFinished
  in
    beginTimeLapse

overDrain : CoreInfo -> ModelTransform
overDrain core = 
  let
    emptyAt =
      Measure.timeRequired core.flowRate core.startingVolume
    howFinished =
      RanOutAfter emptyAt
  in
    moveToFinishedStage core.flowRate howFinished

