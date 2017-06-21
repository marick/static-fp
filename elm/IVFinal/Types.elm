module IVFinal.Types exposing (..)

import IVFinal.FloatInput as FloatInput exposing (FloatInput)
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
  { desiredDripRate : FloatInput

  , droplet : AnimationModel
  }

