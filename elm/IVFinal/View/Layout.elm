module IVFinal.View.Layout exposing (..)

import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import Svg.Attributes as SA

-- CSS is really confusing.

wrapper : List (Html msg) -> Html msg
wrapper contents = 
  H.div
    [ HA.style [ ("margin", "4em")
               , ("width", "800px")
               ]
    ]
    contents
      
canvas : List (Svg msg) -> Html msg
canvas contents =
  H.div
    [ HA.style [ ("width", "200 px")
               , ("float", "left")
               ]
    ]
    [ S.svg 
        [ SA.version "1.1"
        , SA.width "200"
        , SA.height "600"
        ]
        contents
    ]

form : List (Html msg) -> Html msg
form contents = 
  H.div 
    [ HA.style [ ("width", "600 px")
               , ("float", "left")
               ]
    ]
    contents
