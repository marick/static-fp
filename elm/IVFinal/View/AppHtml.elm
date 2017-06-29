module IVFinal.View.AppHtml exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import IVFinal.View.InputFields as Field
import IVFinal.Generic.ValidatedString exposing (ValidatedString)

br : Html msg
br = Html.br [] []

soloButton : String -> List (Attribute msg) -> Html msg
soloButton label attributes =
  Html.p []
    [ Html.button attributes 
        [strong [] [text label]]
    ]
      
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
    
