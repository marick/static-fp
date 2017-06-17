module Animation.A5Fluid.Types exposing (..)

import Animation

type Msg
  = Start
  | Tick Animation.Msg

type alias AnimationModel = Animation.State

type alias Model =
  { droplet : AnimationModel
  }

