module Dict.PropertyStart exposing (..)

import Dict exposing (Dict)
import Date exposing (Date)
-- The following has more functions to create dates, etc. 
import Date.Extra as Date

import Dict.PropertyValue as Value exposing (PropertyValue)

properties : Dict String PropertyValue
properties =
  Dict.fromList [
      ("int1", Value.Int 1)
    , ("int2", Value.Int 2)
    , ("date", Value.Date <| Date.fromCalendarDate 2017 Date.May 26)
    , ("false", Value.Bool False)
    , ("true", Value.Bool True)
    ]
