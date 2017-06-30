module IVFinal.Types exposing (..)

import IVFinal.App.InputFields as Field
import Animation.Messenger
import IVFinal.Generic.Measures as Measure
import IVFinal.Scenario exposing (Scenario)
import Animation

type alias AnimationModel = Animation.Messenger.State Msg
type alias AnimationStep = Animation.Messenger.Step Msg

type SimulationStage
  = FormFilling 
  | WatchingAnimation Measure.LitersPerMinute  -- drain rate
  | Finished Measure.Liters -- ending state

type alias Model =
  { scenario : Scenario
  , stage : SimulationStage

  , desiredDripRate : Field.DripRate
  , desiredMinutes : Field.Minutes
  , desiredHours : Field.Hours
      
  , droplet : AnimationModel
  , bagFluid : AnimationModel
  }

type alias FormData r =
  { r
    | desiredDripRate : Field.DripRate
    , desiredHours : Field.Hours
    , desiredMinutes : Field.Minutes
    , stage : SimulationStage
    , scenario : Scenario
  }

type alias DropletData r =
  { r
    | droplet : AnimationModel
  }

type alias BagFluidData r =
  { r
    | bagFluid : AnimationModel
  }
  
type Msg
  = ChangeDripRate String
  | ChangeHours String
  | ChangeMinutes String
  | ResetSimulation

  | DrippingRequested
  | StartDripping Measure.DropsPerSecond

  | SimulationRequested
  | StartSimulation Measure.DropsPerSecond Measure.Hours Measure.Minutes

  | Tick Animation.Msg
  | NextAnimation (Model -> Model)
