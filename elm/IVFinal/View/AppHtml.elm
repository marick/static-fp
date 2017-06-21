module IVFinal.View.AppHtml exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Event
import Tagged exposing (Tagged(..))

br = Html.br [] []

button : String -> msg -> Html msg
button label onClick =       
  Html.button
    [ Event.onClick onClick
    ]
    [strong [] [text label]]

textInput : {r | literal : String} -> List (Html.Attribute msg) -> Html msg
textInput {literal} eventHandlers = 
  input ([ type_ "text"
         , value literal
         ] ++ eventHandlers)
  []

askFor : String -> {r | literal : String } -> List (Html.Attribute msg) -> Html msg
askFor label arg eventHandlers =
  span [] 
    [ text <| label ++ ": "
    , textInput arg eventHandlers
    ]
    
