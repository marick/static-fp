
module IVFlat.Simulation exposing
  ( run
  )

import IVFlat.Simulation.Conversions as C 
import IVFlat.Simulation.Types exposing (Stage(..), HowFinished(..))

import IVFlat.Apparatus.Droplet as Droplet
import IVFlat.Apparatus.BagFluid as BagFluid
import IVFlat.Apparatus.ChamberFluid as ChamberFluid
import IVFlat.Apparatus.HoseFluid as HoseFluid
import IVFlat.Form.Types exposing (FinishedForm)
import IVFlat.Scenario exposing (Scenario)
import IVFlat.Types exposing (Model, Continuation(Next), ModelTransform)

import IVFlat.Generic.Measures as Measure

type alias CoreInfo =
  { minutes : Measure.Minutes           -- From hours and minutes
  , dripRate : Measure.DropsPerSecond   -- used for animation timings
  , flowRate : Measure.LitersPerMinute  -- Liters are more convenient than mils
  , containerVolume : Measure.Liters   
  , startingVolume : Measure.Liters
  , endingVolume : Measure.Liters
  }


run : Scenario -> FinishedForm -> ModelTransform
run scenario form =
  let
    core =
      extractCoreInfo scenario form
  in
    case Measure.isStrictlyNegative core.endingVolume of
      True -> overDrain core
      False -> partlyDrain core

{- This is what the student *should* achieve: a case where the
bag is still partly full at the end of the simulation.
-}
partlyDrain : CoreInfo -> ModelTransform
partlyDrain core = 
  let
    containerPercent =
      Measure.proportion core.endingVolume core.containerVolume
          
    -- animation
    beginTimeLapse =
      turnFormOff core >>
      Droplet.entersTimeLapse core.dripRate
      (Next lowerBagLevel)
          
    lowerBagLevel =
      Droplet.streams core.dripRate >>
      BagFluid.lowers containerPercent core.minutes
      (Next endTimeLapse)
                  
    endTimeLapse = 
      Droplet.exitsTimeLapseWithFluidLeft core.dripRate
      (Next finish)

    finish = 
      Droplet.dripsOrStreams core.dripRate >>
      displayFinishedForm (FluidLeft core.endingVolume) core
  in
    beginTimeLapse

{- If too much time is specified, the bag, chamber, and hose will all empty
-}      
overDrain : CoreInfo -> ModelTransform
overDrain core = 
  let
    emptyTime =
      Measure.timeRequired core.flowRate core.startingVolume

    -- animation
    beginTimeLapse =
      turnFormOff core >>
      Droplet.entersTimeLapse core.dripRate
      (Next emptyBag)

    emptyBag =
      Droplet.streams core.dripRate >>
      BagFluid.empties emptyTime
      (Next stopDripping)

    stopDripping = 
      Droplet.streamVanishesDuringTimeLapse
      (Next emptyChamber)

    emptyChamber =
      ChamberFluid.empties
      (Next emptyHose)

    emptyHose =
      HoseFluid.empties
      (Next finish)

    finish =
      displayFinishedForm (RanOutAfter emptyTime) core
  in
    beginTimeLapse



turnFormOff : CoreInfo -> ModelTransform
turnFormOff core model = 
  { model | stage = WatchingAnimation core.flowRate }

displayFinishedForm : HowFinished -> CoreInfo -> ModelTransform
displayFinishedForm howFinished core model =
  { model | stage = Finished core.flowRate howFinished }

extractCoreInfo : Scenario -> FinishedForm -> CoreInfo
extractCoreInfo scenario form =
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
      
