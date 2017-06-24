module IVFinal.Types exposing (..)

import IVFinal.View.InputFields as Field
import Animation
import Animation.Messenger

type alias AnimationModel = Animation.Messenger.State Msg

type Msg
  = ChangeDripRate String
  | ChangeHours String
  | ChangeMinutes String
  | ResetFields

  | StartDripping
  | StartSimulation

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

  
