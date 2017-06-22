module IVFinal.FloatInput exposing (..)

type alias FloatInput =
  { literal : String
  , value : Maybe Float
  }

fromString : String -> FloatInput
fromString string =
  let
    withLiteral = { literal = string, value = 0.0 }
  in
    case String.toFloat string of
      Err _ ->
        { withLiteral | value = Nothing }
      Ok 0.0 ->
        { withLiteral | value = Nothing }
      Ok float ->
        { withLiteral | value = Just float } 
