module IVFinal.Types exposing (..)


import IVFinal.FloatString as FloatString exposing (FloatString)

type alias Model =
  { desiredDripRate : FloatString
  }

type Msg
  = ChangeDripRate String
    | Click

