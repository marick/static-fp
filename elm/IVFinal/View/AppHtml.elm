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

textInput : (Tagged tag String) -> List (Html.Attribute msg) -> Html msg
textInput (Tagged val) eventHandlers = 
  input ([ type_ "text"
         , value val
         ] ++ eventHandlers)
  []

askFor : String -> (Tagged tag String) -> List (Html.Attribute msg) -> Html msg
askFor label tagged eventHandlers =
  span [] 
    [ text <| label ++ ": "
    , textInput tagged eventHandlers
    ]
    
