module IVFinal.View.AppHtml exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import IVFinal.View.InputFields as Field
import IVFinal.Util.ValidatedString exposing (ValidatedString)

br : Html msg
br = Html.br [] []

buttonAttributes : Maybe msg -> List (Html.Attribute msg)
buttonAttributes maybe =
  case maybe of
    Nothing -> [disabled True]
    Just msg -> [Event.onClick msg]
                   
button : String -> Maybe msg -> Html msg
button label onClick =
  Html.button
    (buttonAttributes onClick)
    [strong [] [text label]]


button2 : String -> List (Attribute msg) -> Html msg
button2 label events =
  Html.button
    events
    [strong [] [text label]]
      
      
textInput : ValidatedString a  -> List (Html.Attribute msg) -> Html msg
textInput validated eventHandlers = 
  input ([ type_ "text"
         , value validated.literal
         , size 6
         , Field.border validated
         ] ++ eventHandlers)
  []

askFor : String -> ValidatedString a -> List (Html.Attribute msg) -> Html msg
askFor label arg eventHandlers =
  span [] 
    [ text <| label ++ ": "
    , textInput arg eventHandlers
    ]
    
