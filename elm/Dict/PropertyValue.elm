module Dict.PropertyValue exposing (..)

import Date exposing (Date)
import Maybe.Extra as Maybe

type PropertyValue
  = Int Int
  | Bool Bool
  | Date Date

valueInt : PropertyValue -> Maybe Int
valueInt value = 
  case value of
    Int int -> Just int
    _ -> Nothing

isValueInt : PropertyValue -> Bool
isValueInt = valueInt >> Maybe.isJust

