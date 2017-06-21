module IVFinal.FloatInput exposing (..)

type alias FloatInput =
  { literal : String
  , value : Maybe Float
  }

fromString : String -> FloatInput
fromString string =
    case String.toFloat string of
      Err _ ->
        { literal = string
        , value = Nothing
        }
      Ok float ->
        { literal = string
        , value = Just float
        }
