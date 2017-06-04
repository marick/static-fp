module IvArchitecture.Common.Svg exposing (..)

import Html exposing (Html, div)
import Svg exposing (..)
import Svg.Attributes exposing (..)


graphics = {width = "400px", height = "400px"}

wrapper : List (Svg msg) -> Html msg
wrapper content =
  div [] 
    [ svg
        [ version "1.1"
        , x "0"
        , y "0"
        , width graphics.width
        , height graphics.height
        ]
        content
    ]


