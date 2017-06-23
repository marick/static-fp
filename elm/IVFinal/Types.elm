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

  | StartSimulation
  | StartDripping

  | Tick Animation.Msg

type alias Model =
  { desiredDripRate : Field.DripRate

  , droplet : AnimationModel
  }

