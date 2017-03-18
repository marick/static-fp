module SumTypes.SimpleTagging exposing (..)

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
    , td [] (summarizeValue value)
    ]

summarizeValue value =
  case value of
    AsInt int ->
      [ text <| toString int ]
    AsDate date ->
      [ text <| Date.toFormattedString "y-m-d" date ]
    AsBool bool ->
      case bool of
        True -> [trueIcon]
        False -> [falseIcon]

coloredIcon : String -> String -> Html msg
coloredIcon iconName color =
  i [class ("fa " ++ iconName)
    , style [("color", color)]
    ] []

trueIcon : Html msg
trueIcon = coloredIcon "fa-check" "green"

falseIcon : Html msg
falseIcon = coloredIcon "fa-times" "red"
