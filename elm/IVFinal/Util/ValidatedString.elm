module IVFinal.Util.ValidatedString exposing (..)

import Maybe.Extra as Maybe

type alias ValidatedString a =
  { literal : String
  , value : Maybe a
  }

checked : String -> Maybe a -> ValidatedString a
checked literal value =
  { literal = literal
  , value = value
  }


whenValid : ValidatedString a -> result -> (a -> result) -> result
whenValid field animation f =
  Maybe.unwrap animation f field.value
            
