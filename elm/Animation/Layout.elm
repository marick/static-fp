module Animation.Layout exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as Event
import Svg as S exposing (Svg)
import Svg.Attributes as SA

wrapper : List (Html msg) -> Html msg
wrapper contents = 
  H.div
    [ HA.style [("margin", "4em")]]
    contents
      
canvas : List (Svg msg) -> Html msg
canvas contents =       
  S.svg 
    [ SA.version "1.1"
    , SA.width "400"
    , SA.height "400"
    ]
    contents

button : msg -> String -> Html msg
button onClick text =       
  H.button
    [ Event.onClick onClick
    , HA.style [ ("position", "absolute")
               , ("font-size", "1.5em")
               ]
    ]
    [H.strong [] [H.text text]]

