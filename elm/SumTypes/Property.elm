module SumTypes.Property exposing (..)

import Date exposing (Date)
import Date.Extra as Date
import Html exposing (..)
import Html.Attributes exposing (..)


type PropertyValue
  = Int Int
  | Bool Bool
  | Date Date

type Property = Property String PropertyValue

summarize : Property -> Html msg
summarize (Property name value) =             
  tr []
    [ td [] [text name]
    , td [] [summarizeValue value]
    ]

summarizeValue value =
  case value of
    Int int ->
      text <| toString int
    Date date ->
      text <| Date.toFormattedString "y-MM-dd" date
    Bool bool ->
      case bool of
        True -> coloredIcon "fa-check" "green"
        False -> coloredIcon "fa-times" "red"

coloredIcon iconName color =
  i [ class ("fa " ++ iconName)
    , style [("color", color)]
    ]
    []
