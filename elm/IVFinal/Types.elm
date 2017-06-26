module IVFinal.Types exposing (..)

import IVFinal.View.InputFields as Field
import Animation
import Animation.Messenger
import IVFinal.Measures as Measure

type alias AnimationModel = Animation.Messenger.State Msg

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

type alias Model =
  { desiredDripRate : Field.DripRate
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
  }
