module SumTypes.Property exposing (..)

import Date exposing (Date)
import Date.Extra as Date
import Html exposing (..)
import Html.Attributes exposing (..)


type PropertyValue
  = AsInt Int
  | AsBool Bool
  | AsDate Date

type Property = Property String PropertyValue

summarize : Property -> Html msg
summarize (Property name value) =             
  tr []
    [ td [] [text name]
    , td [] [summarizeValue value]
    ]

summarizeValue value =
  case value of
    AsInt int ->
      text <| toString int
    AsDate date ->
      text <| Date.toFormattedString "y-MM-dd" date
    AsBool bool ->
      case bool of
        True -> coloredIcon "fa-check" "green"
        False -> coloredIcon "fa-times" "red"

coloredIcon iconName color =
  i [ class ("fa " ++ iconName)
    , style [("color", color)]
    ]
    []
