module Animation.A8Stopping.Types exposing (..)

import Animation
import Animation.Messenger

type Msg
  = Start
  | Tick Animation.Msg
  | StopDroplet                     -- Added

type alias AnimationModel = Animation.Messenger.State Msg -- changed

type alias Model =
  { droplet : AnimationModel
  , fluid : AnimationModel
  }

