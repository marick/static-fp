module IVFinal.App.Layout exposing (..)

{- Random top-level HTML that I wanted to get out of `IV.elm`.
-}

import Html as H exposing (Html)
import Html.Attributes as HA
import Svg as S exposing (Svg)
import Svg.Attributes as SA


wrapper : List (Html msg) -> Html msg
wrapper contents = 
  H.div
    [ HA.style [ ("margin", "4em")
               , ("width", "600px")
               ]
    ]
    [ H.div 
        [ HA.style [("display", "flex")]
        ]
        contents
    , H.div [] boilerplate
    ]
      
canvas : List (Svg msg) -> Html msg
canvas contents =
  H.div []
    [ S.svg 
        [ SA.version "1.1"
        , SA.width "200"
        , SA.height "400"
        ]
        contents
    ]

form : List (Html msg) -> Html msg
form contents = 
  H.div [ HA.style [ ("width", "370px") ]
        ]
    contents


boilerplate : List (Html msg)      
boilerplate =
  [ H.p []
      [ H.text
          """
              This example is derived from an app used to teach
              students of veterinary medicine. Since you don't
              have an instructor watching you, you don't have to get
              the numbers right. Here are some interesting ones
              to try:
          """
      , H.ul []
        [ H.li [] [H.text "Drip rate of 2 for 5 hours."]
        , H.li [] [H.text "Drip rate of 13 for 5 hours, 30 minutes."]
        , H.li [] [H.text "Drip rate of 5 for 16 hours."]
        ]
      ]
  ]
