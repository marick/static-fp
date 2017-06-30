module IVFinal.Types exposing (..)

import IVFinal.App.InputFields as Field
import Animation.Messenger
import IVFinal.Generic.Measures as Measure
import IVFinal.Scenario exposing (Scenario)
import Animation

type alias AnimationModel = Animation.Messenger.State Msg
type alias AnimationStep = Animation.Messenger.Step Msg

-- Just for clarity in sum type
type alias DrainRate = Measure.LitersPerMinute
type alias EndingLevel = Measure.Liters
  
type SimulationStage
  = FormFilling 
  | WatchingAnimation DrainRate
  | Finished DrainRate EndingLevel

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
