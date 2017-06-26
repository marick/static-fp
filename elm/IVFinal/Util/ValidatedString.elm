module IVFinal.Util.ValidatedString exposing (..)

type alias ValidatedString a =
  { literal : String
  , value : Maybe a
  }

checked : String -> Maybe a -> ValidatedString a
checked literal value =
  { literal = literal
  , value = value
  }
